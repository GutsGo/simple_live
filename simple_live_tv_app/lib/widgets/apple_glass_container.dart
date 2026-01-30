import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:simple_live_tv_app/app/app_style.dart';

class AppleGlassContainer extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double blur;
  final Color? color;
  final Border? border;

  const AppleGlassContainer({
    required this.child,
    this.borderRadius,
    this.padding,
    this.blur = 20.0,
    this.color,
    this.border,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? AppStyle.radius16,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? AppColors.appleGlass,
            borderRadius: borderRadius ?? AppStyle.radius16,
            border: border ??
                Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}
