import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../providers/package_provider.dart';
import 'package_placeholder.dart';

/// One reel card. Three media paths, all with the same chrome
/// (overlay, action column, info block):
///
///   1. **YouTube** (`pkg.isYouTube`) → `YoutubePlayer` (iframe).
///      Only initialised when this card is *current*; off-screen
///      cards show the YouTube poster thumbnail to keep WebView
///      count low.
///   2. **Direct MP4** (`pkg.hasVideo` + non-YouTube) → uses the
///      `VideoPlayerController` handed in by the pager's sliding
///      window. No init logic here — the pager owns the lifecycle.
///   3. **Image only** → `CachedNetworkImage` of the banner /
///      thumbnail / first frame URL.
class PackageReelsCard extends StatefulWidget {
  final PackageModel package;
  final bool isCurrent;
  final bool isGlobalMuted;
  final VoidCallback onToggleMute;

  /// Provided by the pager when this card is hosting a direct-MP4
  /// package and falls inside the preload window.
  final VideoPlayerController? directVideoController;

  const PackageReelsCard({
    super.key,
    required this.package,
    required this.isCurrent,
    required this.isGlobalMuted,
    required this.onToggleMute,
    this.directVideoController,
  });

  @override
  State<PackageReelsCard> createState() => _PackageReelsCardState();
}

class _PackageReelsCardState extends State<PackageReelsCard> {
  YoutubePlayerController? _ytController;
  bool _showPlayPauseOverlay = false;
  bool _isPaused = false;
  bool _descExpanded = false;

  bool get _isYouTube => widget.package.isYouTube && widget.package.hasVideo;
  bool get _isDirectVideo =>
      widget.package.hasVideo && !widget.package.isYouTube;
  bool get _isImageOnly => !widget.package.hasVideo;

  /// Default WhatsApp number — fallback when the package itself
  /// doesn't carry one. Update if Rehman Travels has a different
  /// official sales line.
  static const String _defaultWhatsappNumber = '923345488801';

  Future<void> _openWhatsApp() async {
    final raw = (widget.package.whatsappNo ?? '').trim();
    final sanitised = raw.isNotEmpty
        ? raw.replaceAll(RegExp(r'[^0-9]'), '')
        : _defaultWhatsappNumber;
    final msg = Uri.encodeComponent(
      'Hi Rehman Travels! I am interested in *${widget.package.title}*. '
      'Please share the details and pricing.',
    );
    final uri = Uri.parse('https://wa.me/$sanitised?text=$msg');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('WhatsApp launch failed: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isCurrent && _isYouTube) _attachYouTube();
  }

  @override
  void didUpdateWidget(covariant PackageReelsCard old) {
    super.didUpdateWidget(old);
    if (_isYouTube) {
      if (widget.isCurrent && _ytController == null) {
        _attachYouTube();
      } else if (!widget.isCurrent && _ytController != null) {
        _detachYouTube();
      } else if (widget.isCurrent &&
          _ytController != null &&
          widget.isGlobalMuted != old.isGlobalMuted) {
        // youtube_player_flutter has separate mute() / unMute() JS
        // commands — setVolume alone doesn't actually toggle mute on
        // the iframe, which is why the mute icon appeared dead.
        if (widget.isGlobalMuted) {
          try { _ytController!.mute(); } catch (_) {}
        } else {
          try {
            _ytController!.unMute();
            _ytController!.setVolume(100);
          } catch (_) {}
        }
      }
    }
  }

  @override
  void dispose() {
    _detachYouTube();
    super.dispose();
  }

  void _attachYouTube() {
    final id = widget.package.youtubeVideoId;
    if (id == null || id.isEmpty) return;
    if (kDebugMode) {
      debugPrint('=== Reels: attaching YouTube player for $id');
    }
    _ytController = YoutubePlayerController(
      initialVideoId: id,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: widget.isGlobalMuted,
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

  void _detachYouTube() {
    final ctrl = _ytController;
    _ytController = null;
    if (ctrl == null) return;
    try {
      ctrl.dispose();
    } catch (_) {}
  }

  void _flashOverlay({required bool isPaused}) {
    if (!mounted) return;
    setState(() {
      _showPlayPauseOverlay = true;
      _isPaused = isPaused;
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _showPlayPauseOverlay = false);
    });
  }

  void _toggleVideoPlayback() {
    if (_isImageOnly) return;
    if (_isYouTube && _ytController != null) {
      // Iframe controller's `value.playerState` is the source of
      // truth — but the local `_isPaused` flag mirrors it well
      // enough for a single tap toggle. Flip it, fire the right
      // command, flash the overlay.
      try {
        if (_isPaused) {
          _ytController!.play();
        } else {
          _ytController!.pause();
        }
      } catch (_) {}
      _flashOverlay(isPaused: !_isPaused);
      _isPaused = !_isPaused;
      return;
    }
    final c = widget.directVideoController;
    if (c == null) return;
    try {
      if (c.value.isPlaying) {
        c.pause();
        _flashOverlay(isPaused: true);
      } else {
        c.play();
        _flashOverlay(isPaused: false);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Always-on poster behind the player so swipes feel instant.
        Positioned.fill(child: _poster()),
        // Active media on top of the poster.
        Positioned.fill(child: _media()),
        // Dark scrim for legibility of the overlays.
        Positioned.fill(child: _scrim()),
        // Tap-to-play/pause hit area + double-tap is not wired for
        // packages (no like in this app yet).
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _toggleVideoPlayback,
          ),
        ),
        if (_showPlayPauseOverlay && !_isImageOnly)
          Center(
            child: AnimatedOpacity(
              opacity: _showPlayPauseOverlay ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
        // Right-side action column — TikTok-style stacked icons.
        // Small, transparent, no big blobs. Logo on top, then mute,
        // then share. Counts hidden because packages don't have
        // like / comment metrics yet.
        Positioned(
          right: 14,
          bottom: 120,
          child: _ActionColumn(
            package: widget.package,
            isMuted: widget.isGlobalMuted,
            onToggleMute: widget.onToggleMute,
            showMute: !_isImageOnly,
            onWhatsApp: _openWhatsApp,
          ),
        ),
        // Bottom info block — minimal: @handle, title, expandable desc.
        Positioned(
          left: 16,
          right: 84,
          bottom: 28,
          child: _InfoBlock(
            package: widget.package,
            isExpanded: _descExpanded,
            onToggleExpand: () {
              if (!mounted) return;
              setState(() => _descExpanded = !_descExpanded);
            },
            onWhatsApp: _openWhatsApp,
          ),
        ),
      ],
    );
  }

  Widget _poster() {
    final url = widget.package.primaryImageUrl;
    if (url == null) return PackagePlaceholder(title: widget.package.title);
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(color: Colors.black),
      errorWidget: (_, __, ___) =>
          PackagePlaceholder(title: widget.package.title),
    );
  }

  Widget _media() {
    if (_isYouTube && widget.isCurrent && _ytController != null) {
      return _YoutubeFill(controller: _ytController!);
    }
    if (_isDirectVideo) {
      final c = widget.directVideoController;
      if (c == null || !c.value.isInitialized) return const SizedBox.shrink();
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: c.value.size.width,
            height: c.value.size.height,
            child: VideoPlayer(c),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _scrim() {
    // Stronger gradient at the bottom — readable text against a
    // bright video frame is more important than seeing the bottom of
    // the video, and the heavy fade only touches the lower 35% so
    // the subject of the reel stays visible. Top fade keeps the
    // back-button and right-action icons crisp.
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.32),
              Colors.transparent,
              Colors.black.withValues(alpha: 0.40),
              Colors.black.withValues(alpha: 0.78),
            ],
            stops: const [0.0, 0.30, 0.65, 1.0],
          ),
        ),
      ),
    );
  }
}

/// Stretches the 16:9 YouTube iframe across the whole screen so the
/// 9:16 content area fills bottom-to-top edges (TikTok feel).
class _YoutubeFill extends StatelessWidget {
  final YoutubePlayerController controller;
  const _YoutubeFill({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: LayoutBuilder(
        builder: (ctx, c) {
          final sw = c.maxWidth;
          final sh = c.maxHeight;
          // The player is 16:9. Over-scale so the central 9:16
          // content area fills the screen height edge-to-edge.
          final playerH = sw * 16 / 9;
          final playerW = playerH * 16 / 9;
          return OverflowBox(
            alignment: Alignment.center,
            minWidth: 0,
            maxWidth: double.infinity,
            minHeight: 0,
            maxHeight: double.infinity,
            child: SizedBox(
              width: playerW,
              height: playerH < sh ? sh : playerH,
              child: YoutubePlayer(
                controller: controller,
                showVideoProgressIndicator: false,
                bottomActions: const [],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// TikTok-style stacked column on the right edge of the reel.
/// Top → bottom: thumbnail-as-avatar (with a small accent ring),
/// mute toggle, share. No background blobs — icons sit directly on
/// the video / scrim like the reference design.
class _ActionColumn extends StatelessWidget {
  final PackageModel package;
  final bool isMuted;
  final VoidCallback onToggleMute;
  final bool showMute;
  final VoidCallback onWhatsApp;

  const _ActionColumn({
    required this.package,
    required this.isMuted,
    required this.onToggleMute,
    required this.showMute,
    required this.onWhatsApp,
  });

  @override
  Widget build(BuildContext context) {
    // Side column intentionally minimal — Rehman Travels brand
    // avatar + mute button. The Contact / WhatsApp action lives on
    // the bottom CTA pill instead, so the side rail stays clean.
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _Avatar(
          url: package.fullThumbnailUrl ?? package.youtubeThumbnailUrl,
          label: 'R', // Rehman Travels initial as fallback
        ),
        if (showMute) ...[
          const SizedBox(height: 22),
          _ActionIcon(
            icon: isMuted
                ? Icons.volume_off_rounded
                : Icons.volume_up_rounded,
            onTap: onToggleMute,
          ),
        ],
      ],
    );
  }
}

/// Brand avatar shown at the top of the action column. Always
/// renders the Rehman Travels logo (asset) — the parameter is kept
/// so callers can pass through fallback data, but the badge stays
/// brand-locked to keep the side rail visually consistent across
/// the entire reels feed.
class _Avatar extends StatelessWidget {
  final String? url;
  final String label;
  const _Avatar({required this.url, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      padding: const EdgeInsets.all(2), // gives room for the white ring
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Image.asset(
            'assets/icons/logo.png',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Text(
              label.isNotEmpty ? label.characters.first.toUpperCase() : 'R',
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Bare action icon for the right column. Drop shadow keeps it
/// readable on bright video frames; no chip / pill background.
class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          color: Colors.white,
          size: 30,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.55),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tight bottom-left info block — modelled on the Cencai reference:
///   1. **CTA pill** ("View Details" / "Book Now") in white-on-dark
///      so the user always knows what action the card invites.
///   2. **Title** — bold 16-17pt, max 2 lines.
///   3. **Description** — collapsed to 2 lines with an inline
///      `more ⌃` toggle that flips to `less ⌄` when expanded.
///   4. **Tag chips row** — package type with a heart icon and an
///      optional "Featured" badge.
class _InfoBlock extends StatelessWidget {
  final PackageModel package;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback onWhatsApp;

  const _InfoBlock({
    required this.package,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onWhatsApp,
  });

  IconData _typeIcon() {
    switch (package.packageType.toLowerCase()) {
      case 'umrah':
      case 'hajj':
        return Icons.mosque_rounded;
      case 'tour':
        return Icons.landscape_rounded;
      case 'hotel':
        return Icons.hotel_rounded;
      case 'flight':
        return Icons.flight_rounded;
      case 'visa':
        return Icons.credit_card_rounded;
      case 'combo':
        return Icons.workspace_premium_rounded;
      default:
        return Icons.favorite_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final desc = package.description ?? '';
    final type = package.packageTypeLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. CTA pill — single tappable action that fires the
        //    WhatsApp lead. Same destination + pre-fill as the
        //    avatar tap above.
        _CtaPill(label: 'Contact Us', onTap: onWhatsApp),
        const SizedBox(height: 12),

        // 2. Title — bold, prominent.
        Text(
          package.title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.2,
            height: 1.2,
            shadows: [
              Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 1)),
            ],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        // 3. Description with inline `more ⌃` / `less ⌄` toggle.
        if (desc.isNotEmpty) ...[
          const SizedBox(height: 6),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onToggleExpand,
            child: _ExpandableDescription(
              text: desc,
              expanded: isExpanded,
              onToggle: onToggleExpand,
            ),
          ),
        ],

        // 4. Tag chips — package type with icon + a featured badge
        //    when applicable.
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            if (type.isNotEmpty) _TagChip(icon: _typeIcon(), label: type),
            if (package.isFeatured)
              _TagChip(
                icon: Icons.local_fire_department_rounded,
                label: 'Featured',
                background: const Color(0xFFFFB534),
                foreground: Colors.black,
                borderless: true,
              ),
          ],
        ),
      ],
    );
  }
}

/// Premium CTA pill — full WhatsApp-green gradient surface with the
/// real WhatsApp glyph (white SVG) and a tight arrow. Reads as a
/// single recognisable "tap to chat on WhatsApp" affordance instead
/// of a generic "Contact" button. Layered shadows + a pressed-in
/// inner border give it tangible depth on a busy video frame.
class _CtaPill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _CtaPill({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        splashColor: Colors.white.withValues(alpha: 0.20),
        highlightColor: Colors.white.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 16, 10),
          decoration: BoxDecoration(
            // WhatsApp brand green with a slight top-light gradient
            // so the surface reads as a real glossy button instead
            // of a flat fill.
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF2DD96E),
                Color(0xFF1FB95C),
              ],
            ),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
              width: 1,
            ),
            boxShadow: [
              // Anchored close shadow — sits the pill on the surface
              BoxShadow(
                color: const Color(0xFF1FB95C).withValues(alpha: 0.45),
                blurRadius: 10,
                spreadRadius: -2,
                offset: const Offset(0, 4),
              ),
              // Soft outer halo — separates from busy video
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.30),
                blurRadius: 18,
                spreadRadius: -4,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/whatsapp.svg',
                width: 17,
                height: 17,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 9),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.15,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 15,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact icon + label chip used at the bottom of the info block.
/// Two presets: glass-on-dark (default) and solid (orange "Featured").
class _TagChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? background;
  final Color? foreground;
  final bool borderless;

  const _TagChip({
    required this.icon,
    required this.label,
    this.background,
    this.foreground,
    this.borderless = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = background ?? Colors.black.withValues(alpha: 0.32);
    final fg = foreground ?? Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: borderless
            ? null
            : Border.all(
                color: Colors.white.withValues(alpha: 0.20),
                width: 0.6,
              ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: fg, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fg,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Suppresses an unused-warning when [kDebugMode] isn't referenced.
// ignore: unused_element
final _kKeepDebug = kDebugMode;

/// Shows up to 2 lines of [text] when collapsed and the full text
/// when expanded, with an inline "show more" / "show less" hint
/// styled to match the description body. Uses a single [TextPainter]
/// pass to detect overflow — the toggle is hidden when the text
/// fits within 2 lines so we don't show a useless hint.
class _ExpandableDescription extends StatelessWidget {
  final String text;
  final bool expanded;
  final VoidCallback onToggle;

  const _ExpandableDescription({
    required this.text,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(
      fontSize: 12.5,
      color: Color(0xD9FFFFFF), // white @ 85%
      height: 1.3,
      shadows: [
        Shadow(color: Colors.black45, blurRadius: 3, offset: Offset(0, 1)),
      ],
    );
    final hintStyle = TextStyle(
      fontSize: 12.5,
      fontWeight: FontWeight.w700,
      color: Colors.white.withValues(alpha: 0.95),
      height: 1.3,
      shadows: const [
        Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 1)),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Probe whether the full text overflows 2 lines at this width.
        final probe = TextPainter(
          text: TextSpan(text: text, style: bodyStyle),
          maxLines: 2,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);
        final didOverflow = probe.didExceedMaxLines;

        if (!didOverflow) {
          // Short description — render as-is, no toggle clutter.
          return Text(text, style: bodyStyle);
        }

        return RichText(
          maxLines: expanded ? null : 3,
          overflow: TextOverflow.fade,
          text: TextSpan(
            style: bodyStyle,
            children: [
              TextSpan(text: expanded ? text : '$text  '),
              TextSpan(
                text: expanded ? '  show less' : 'show more',
                style: hintStyle,
                recognizer: null, // tap handled by parent GestureDetector
              ),
            ],
          ),
        );
      },
    );
  }
}
