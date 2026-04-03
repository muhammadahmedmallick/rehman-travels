import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme.dart';

class FullScreenLoader extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const FullScreenLoader({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content
        AbsorbPointer(
          absorbing: isLoading,
          child: child,
        ),

        // Blur overlay + loader
        if (isLoading)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                color: Colors.black.withValues(alpha: 0.35),
                child: Center(
                  child: Container(
                    width: 220,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 30, offset: const Offset(0, 10))],
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      // Logo with spinner around it
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Spinner ring around logo
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(
                                strokeWidth: 3.5,
                                color: AppColors.primary,
                                backgroundColor: AppColors.border,
                              ),
                            ),
                            // Logo in center
                            ClipOval(
                              child: Image.asset(
                                'assets/icons/logo.png',
                                width: 70,
                                height: 70,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (message != null) ...[
                        const SizedBox(height: 20),
                        DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            decoration: TextDecoration.none,
                          ),
                          child: Text(
                            message!,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ]),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
