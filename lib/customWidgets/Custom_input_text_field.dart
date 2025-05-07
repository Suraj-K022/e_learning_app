import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final IconData? prefixIcon;
  final double? prefixIconSize;
  final Color? prefixIconColor;
  final double? height;
  final int? maxLines;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final int? maxDigits;
  final TextInputType? keyboardType;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixTap,
    this.prefixIcon,
    this.prefixIconSize,
    this.prefixIconColor,
    this.height,
    this.maxLines = 1,
    this.onChanged,
    this.readOnly = false,
    this.maxDigits,
    this.keyboardType,
    this.errorText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller ?? _internalController;

    return SizedBox(
      height: widget.maxLines! > 1 ? 100 : widget.height,
      child: TextFormField(
        cursorColor: Get.theme.primaryColor,
        controller: controller,
        obscureText: widget.obscureText,
        maxLines: widget.maxLines,
        readOnly: widget.readOnly,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        inputFormatters: [
          if (widget.maxDigits != null)
            LengthLimitingTextInputFormatter(widget.maxDigits),
          if (widget.keyboardType == TextInputType.number)
            FilteringTextInputFormatter.digitsOnly,
        ],
        style: GoogleFonts.poppins(
          color: Get.theme.secondaryHeaderColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: GoogleFonts.poppins(color: Colors.grey),
          errorText: widget.errorText,
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Get.theme.primaryColor),
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          prefixIcon: widget.prefixIcon != null
              ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              widget.prefixIcon,
              color: widget.prefixIconColor ?? Get.theme.primaryColor,
              size: widget.prefixIconSize ?? 20,
            ),
          )
              : null,
          suffixIcon: widget.suffixIcon != null
              ? GestureDetector(
            onTap: widget.onSuffixTap,
            child: Icon(
              widget.suffixIcon,
              color: Colors.grey,
            ),
          )
              : null,
        ),
      ),
    );
  }
}
