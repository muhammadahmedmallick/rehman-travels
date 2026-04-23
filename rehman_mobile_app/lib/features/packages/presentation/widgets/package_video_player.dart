import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/package_provider.dart';
import '../providers/video_controller_provider.dart';
import 'package_placeholder.dart';

class PackageVideoPlayer extends ConsumerStatefulWidget {
  final PackageModel package;
  final bool isActive;
  const PackageVideoPlayer({super.key, required this.package, required this.isActive});

  @override
  ConsumerState<PackageVideoPlayer> createState() => _State();
}

class _State extends ConsumerState<PackageVideoPlayer> {
  VideoPlayerController? _ctrl;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    if (!widget.package.isYouTube && widget.package.hasVideo) _initMp4();
  }

  @override
  void didUpdateWidget(PackageVideoPlayer old) {
    super.didUpdateWidget(old);
    if (!widget.package.isYouTube && _ready && _ctrl != null) {
      final muted = ref.read(videoControllerProvider).isMuted(widget.package.slug);
      _ctrl!.setVolume(muted ? 0 : 1);
      widget.isActive ? _ctrl!.play() : _ctrl!.pause();
    }
  }

  Future<void> _initMp4() async {
    try {
      final c = VideoPlayerController.networkUrl(Uri.parse(widget.package.videoUrl!));
      await c.initialize();
      await c.setLooping(true);
      await c.setVolume(0);
      if (!mounted) { c.dispose(); return; }
      setState(() { _ctrl = c; _ready = true; });
      if (widget.isActive) c.play();
    } catch (_) {}
  }

  @override
  void dispose() { _ctrl?.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    if (widget.package.isYouTube) {
      return _YT(package: widget.package, isActive: widget.isActive);
    }
    if (!_ready || _ctrl == null) return Container(color: Colors.black);
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _ctrl!.value.size.width,
          height: _ctrl!.value.size.height,
          child: VideoPlayer(_ctrl!),
        ),
      ),
    );
  }
}

// ── Official YouTube IFrame player via youtube_player_flutter ────────────
// This uses YouTube's whitelisted IFrame API — not a raw iframe — so
// 503 / embed-blocked errors don't happen. Video scales to fill screen.

class _YT extends StatefulWidget {
  final PackageModel package;
  final bool isActive;
  const _YT({required this.package, required this.isActive});

  @override
  State<_YT> createState() => _YTState();
}

class _YTState extends State<_YT> {
  late YoutubePlayerController _yt;

  @override
  void initState() {
    super.initState();
    _yt = YoutubePlayerController(
      initialVideoId: widget.package.youtubeVideoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: true,
        hideControls: true,
        hideThumbnail: true,
        disableDragSeek: true,
        enableCaption: false,
        forceHD: false,
        useHybridComposition: false,
      ),
    );
  }

  @override
  void didUpdateWidget(_YT old) {
    super.didUpdateWidget(old);
    widget.isActive ? _yt.play() : _yt.pause();
  }

  @override
  void dispose() { _yt.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final thumb = widget.package.youtubeThumbnailUrl;
    return Stack(
      fit: StackFit.expand,
      children: [
        // Poster behind (shown while buffering)
        if (thumb != null)
          CachedNetworkImage(
            imageUrl: thumb,
            fit: BoxFit.cover,
            placeholder: (_, _) => Container(color: Colors.black),
            errorWidget: (_, _, _) => PackagePlaceholder(title: widget.package.title),
          )
        else
          PackagePlaceholder(title: widget.package.title),

        // Over-size the 16:9 player so the 9:16 content region fills screen
        ClipRect(
          child: LayoutBuilder(builder: (ctx, c) {
            final sw = c.maxWidth;
            final sh = c.maxHeight;
            // Content inside iframe is 9:16 letterboxed in 16:9 player.
            // Make player so wide that its content area = sw, then height fits sh.
            final playerH = sw * 16 / 9;
            final playerW = playerH * 16 / 9;
            return OverflowBox(
              alignment: Alignment.center,
              minWidth: 0, maxWidth: double.infinity,
              minHeight: 0, maxHeight: double.infinity,
              child: SizedBox(
                width: playerW,
                height: playerH < sh ? sh : playerH,
                child: YoutubePlayer(
                  controller: _yt,
                  showVideoProgressIndicator: false,
                  bottomActions: const [],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
