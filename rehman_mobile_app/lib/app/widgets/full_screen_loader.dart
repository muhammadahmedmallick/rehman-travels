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
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 8))],
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      SizedBox(
                        width: 40, height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: AppColors.primary,
                        ),
                      ),
                      if (message != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          message!,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary),
                          textAlign: TextAlign.center,
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
