import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';

import '../providers/package_provider.dart';
import '../widgets/package_reels_card.dart';

/// Reels-style vertical pager for packages.
///
/// Memory model — this is the important bit:
///
///   * `video_player` (used for direct MP4 packages) holds platform
///     resources behind every controller. iOS AVPlayer caps you at
///     ~16 active sessions; older Android MediaCodec stacks die at
///     ~8. So we keep at most 4 controllers alive at once via a
///     sliding window: `[current - _preloadBehind, current + _preloadAhead]`.
///   * YouTube videos use `youtube_player_iframe` — each player is a
///     WebView. WebViews are heavy too (~30-50MB each), so we
///     intentionally only initialise the YouTube player on the
///     **current** page; neighbours show their thumbnail until they
///     become current. The iframe player lives inside the card
///     widget, not this controller pool.
///   * Image-only packages don't need a controller.
///
/// `PreloadPageView.builder` is the same widget the sample uses —
/// builds neighbour pages eagerly so thumbnails / images are ready
/// the instant the user starts swiping.
class PackageReelsView extends ConsumerStatefulWidget {
  final List<PackageModel> packages;
  final int initialIndex;

  const PackageReelsView({
    super.key,
    required this.packages,
    this.initialIndex = 0,
  });

  @override
  ConsumerState<PackageReelsView> createState() => _PackageReelsViewState();
}

class _PackageReelsViewState extends ConsumerState<PackageReelsView> {
  late final PreloadPageController _pageController;
  int _currentIndex = 0;
  bool _isGlobalMuted = false;
  bool _isDisposed = false;

  // Sliding-window for direct-MP4 controllers only — YouTube and
  // image cards bypass this pool entirely.
  static const int _preloadAhead = 1;
  static const int _preloadBehind = 1;
  final Map<int, VideoPlayerController> _controllers = {};
  final Map<int, String> _controllerUrls = {};
  final Set<int> _initializing = {};
  final Set<String> _prefetchedThumbnails = {};

  @override
  void initState() {
    super.initState();
    _currentIndex =
        widget.initialIndex.clamp(0, widget.packages.length - 1);
    _pageController = PreloadPageController(
      initialPage: _currentIndex,
      keepPage: true,
    );
    _preloadWindow();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _disposeAllControllers();
    _pageController.dispose();
    super.dispose();
  }

  // ── Window helpers ─────────────────────────────────────────────
  Set<int> _windowIndices() {
    if (widget.packages.isEmpty) return const {};
    final maxIndex = widget.packages.length - 1;
    final start = (_currentIndex - _preloadBehind).clamp(0, maxIndex);
    final end = (_currentIndex + _preloadAhead).clamp(0, maxIndex);
    return {for (int i = start; i <= end; i++) i};
  }

  void _preloadWindow() {
    for (final i in _windowIndices()) {
      _ensureController(i);
      _prefetchThumbnail(i);
    }
  }

  void _prefetchThumbnail(int index) {
    if (!mounted || _isDisposed) return;
    if (index < 0 || index >= widget.packages.length) return;
    final url = widget.packages[index].primaryImageUrl;
    if (url == null || url.isEmpty) return;
    if (_prefetchedThumbnails.contains(url)) return;
    _prefetchedThumbnails.add(url);
    try {
      precacheImage(CachedNetworkImageProvider(url), context).catchError((_) {
        _prefetchedThumbnails.remove(url);
      });
    } catch (_) {
      _prefetchedThumbnails.remove(url);
    }
  }

  // ── Controller lifecycle ────────────────────────────────────────
  Future<void> _ensureController(int index) async {
    if (_isDisposed) return;
    if (index < 0 || index >= widget.packages.length) return;
    if (_controllers.containsKey(index)) return;
    if (_initializing.contains(index)) return;

    final pkg = widget.packages[index];
    // YouTube and image cards have their own playback path — they
    // don't go through this `video_player` pool.
    if (!pkg.hasVideo || pkg.isYouTube) return;
    final url = pkg.videoUrl;
    if (url == null || url.isEmpty) return;

    _initializing.add(index);
    final ctrl = VideoPlayerController.networkUrl(Uri.parse(url));
    try {
      await ctrl.initialize();
      // Stale check — by the time `initialize` completes the user
      // may have scrolled away, the offer slug may have shifted
      // beneath us, or the widget may be gone.
      final stillValid = !_isDisposed &&
          mounted &&
          index < widget.packages.length &&
          widget.packages[index].videoUrl == url &&
          _windowIndices().contains(index);
      if (!stillValid) {
        try {
          ctrl.dispose();
        } catch (_) {}
        return;
      }

      try {
        ctrl.setLooping(true);
        ctrl.setVolume(0.0); // muted on init — _activate raises it
      } catch (_) {}

      _controllers[index] = ctrl;
      _controllerUrls[index] = url;

      if (index == _currentIndex) _activate(_currentIndex);
      if (mounted && !_isDisposed) setState(() {});
    } catch (e) {
      debugPrint('Reels: video init failed at $index — $e');
      try {
        ctrl.dispose();
      } catch (_) {}
    } finally {
      _initializing.remove(index);
    }
  }

  void _activate(int index) {
    if (_isDisposed) return;
    _controllers.forEach((i, ctrl) {
      try {
        if (!ctrl.value.isInitialized) return;
        if (i == index) {
          ctrl.setVolume(_isGlobalMuted ? 0.0 : 1.0);
          if (!ctrl.value.isPlaying) ctrl.play();
        } else {
          ctrl.setVolume(0.0);
          if (ctrl.value.isPlaying) ctrl.pause();
        }
      } catch (e) {
        debugPrint('Reels: activate error at $i — $e');
      }
    });
  }

  void _disposeStaleControllers() {
    final window = _windowIndices();
    final toRemove = <int>[];
    _controllers.forEach((i, _) {
      if (!window.contains(i)) toRemove.add(i);
    });
    for (final i in toRemove) {
      _disposeController(i);
    }
  }

  void _disposeController(int index) {
    final ctrl = _controllers.remove(index);
    _controllerUrls.remove(index);
    if (ctrl == null) return;
    try {
      ctrl.pause();
    } catch (_) {}
    try {
      ctrl.dispose();
    } catch (e) {
      debugPrint('Reels: dispose error at $index — $e');
    }
  }

  void _disposeAllControllers() {
    final indices = _controllers.keys.toList();
    for (final i in indices) {
      _disposeController(i);
    }
    _initializing.clear();
  }

  // ── Page change ─────────────────────────────────────────────────
  void _onPageChanged(int index) {
    if (_isDisposed || _currentIndex == index) return;
    _currentIndex = index;
    _activate(index);
    if (mounted) setState(() {});
    _preloadWindow();
    _disposeStaleControllers();
  }

  void _toggleGlobalMute() {
    if (_isDisposed || !mounted) return;
    setState(() {
      _isGlobalMuted = !_isGlobalMuted;
      final ctrl = _controllers[_currentIndex];
      try {
        if (ctrl != null && ctrl.value.isInitialized) {
          ctrl.setVolume(_isGlobalMuted ? 0.0 : 1.0);
        }
      } catch (_) {}
    });
  }

  VideoPlayerController? _controllerFor(int index) {
    final c = _controllers[index];
    if (c == null) return null;
    try {
      if (c.value.isInitialized) return c;
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.packages.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'No packages to show',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PreloadPageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: widget.packages.length,
            onPageChanged: _onPageChanged,
            physics: const ClampingScrollPhysics(),
            preloadPagesCount: 1,
            itemBuilder: (context, index) {
              final pkg = widget.packages[index];
              return PackageReelsCard(
                key: ValueKey(pkg.slug),
                package: pkg,
                isCurrent: index == _currentIndex,
                isGlobalMuted: _isGlobalMuted,
                onToggleMute: _toggleGlobalMute,
                directVideoController: _controllerFor(index),
              );
            },
          ),
        ],
      ),
    );
  }
}
