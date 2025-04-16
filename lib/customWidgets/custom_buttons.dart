import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  final double? borderRadius;
  final Widget child; // Now accepts any widget
  final VoidCallback onPressed;

  // Default values
  static const double defaultHeight = 48;
  static double defaultWidth = Get.width;
  static const double defaultBorderRadius = 8;

  const CustomButton({
    Key? key,
    this.height,
    this.width,
    this.color,
    this.borderRadius,
    required this.child, // Now required to pass a widget
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? defaultHeight,
      width: width ?? Get.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Get.theme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? defaultBorderRadius),
          ),
        ),
        onPressed: onPressed,
        child: child, // Displaying the passed widget
      ),
    );
  }
}
