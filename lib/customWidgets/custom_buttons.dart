import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatefulWidget {
  final double? height;
  final double? width;
  final Color? color;
  final double? borderRadius;
  final Widget child;
  final dynamic
      onPressed; // Accepts either VoidCallback or Future<void> Function()
  final bool showLoading;

  const CustomButton({
    Key? key,
    this.height,
    this.width,
    this.color,
    this.borderRadius,
    required this.child,
    required this.onPressed,
    this.showLoading = true,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    if (_isLoading || widget.onPressed == null) return;

    final isAsync = widget.onPressed is Future<void> Function();

    if (isAsync && widget.showLoading) {
      setState(() => _isLoading = true);
    }

    try {
      final result = widget.onPressed();
      if (result is Future) {
        await result;
      }
    } catch (e) {
      debugPrint("CustomButton error: $e");
    }

    if (mounted && isAsync && widget.showLoading) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 48,
      width: widget.width ?? Get.width,
      child: ElevatedButton(
        onPressed: _handlePress,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.color ?? Get.theme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Get.theme.primaryColor,
                ),
              )
            : widget.child,
      ),
    );
  }
}
