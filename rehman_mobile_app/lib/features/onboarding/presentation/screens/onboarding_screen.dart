import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/routes.dart';
import '../../../../main.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;
  Timer? _autoTimer;
  bool _imagesReady = false;

  static const _pages = [
    _PageData(
      image: 'assets/stories/img_1.jpg',
      title: 'Begin Your\nHoly Journey',
      description: 'Complete Umrah & Hajj packages with guided tours, premium hotels & seamless transport',
    ),
    _PageData(
      image: 'assets/stories/img_2.jpg',
      title: 'Fly Anywhere\nAnytime',
      description: 'Compare 100+ airlines and book the best fares on domestic & international flights',
    ),
    _PageData(
      image: 'assets/stories/img_3.jpg',
      title: 'Explore The\nWorld With Us',
      description: 'Your trusted travel partner for global destinations, visa services & holiday packages',
    ),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesReady) _precacheImages();
  }

  Future<void> _precacheImages() async {
    await Future.wait(_pages.map((p) => precacheImage(AssetImage(p.image), context)));
    if (!mounted) return;
    setState(() => _imagesReady = true);
    _startAutoTimer();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoTimer() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(milliseconds: 2500), (_) {
      if (_currentPage < _pages.length - 1) {
        _controller.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
      }
    });
  }

  void _onNext() {
    _autoTimer?.cancel();
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
      _startAutoTimer();
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    ref.read(onboardingSeenProvider.notifier).state = true;
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final topPad = MediaQuery.of(context).padding.top;

    if (!_imagesReady) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Color(0xFFF5A623), strokeWidth: 2)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── IMAGE PAGES (crossfade instead of slide) ──
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            child: SizedBox.expand(
              key: ValueKey(_currentPage),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(_pages[_currentPage].image, fit: BoxFit.cover),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.35, 0.55, 0.75, 1.0],
                        colors: [
                          Colors.black.withValues(alpha: 0.15),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.15),
                          Colors.black.withValues(alpha: 0.55),
                          Colors.black.withValues(alpha: 0.92),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── INVISIBLE PAGEVIEW (swipe detection only) ──
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (i) {
              setState(() => _currentPage = i);
              _startAutoTimer();
            },
            itemBuilder: (_, __) => const SizedBox.expand(),
          ),

          // ── SKIP ──
          Positioned(
            top: topPad + 10,
            right: 20,
            child: GestureDetector(
              onTap: _completeOnboarding,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1),
                ),
                child: const Text('Skip', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
          ),

          // ── LOGO ──
          Positioned(
            top: topPad + 10,
            left: 20,
            child: Image.asset('assets/icons/logo.png', height: 40),
          ),

          // ── BOTTOM CONTENT (text crossfades smoothly) ──
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(28, 0, 28, bottomPad + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                    layoutBuilder: (currentChild, previousChildren) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          ...previousChildren,
                          if (currentChild != null) currentChild,
                        ],
                      );
                    },
                    child: Text(
                      _pages[_currentPage].title,
                      key: ValueKey('t$_currentPage'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, height: 1.15, letterSpacing: -0.5),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Description
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                    layoutBuilder: (currentChild, previousChildren) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          ...previousChildren,
                          if (currentChild != null) currentChild,
                        ],
                      );
                    },
                    child: Text(
                      _pages[_currentPage].description,
                      key: ValueKey('d$_currentPage'),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.75), height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      final isActive = _currentPage == i;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFFF5A623) : Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5A623),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageData {
  final String image;
  final String title;
  final String description;

  const _PageData({
    required this.image,
    required this.title,
    required this.description,
  });
}
