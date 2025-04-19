import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'customtext.dart';

class CustomDropdownField extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final ValueChanged<String>? onChanged;
  final String? selectedValue;
  final double? height;
  final bool readOnly;

  const CustomDropdownField({
    super.key,
    required this.hintText,
    required this.items,
    this.onChanged,
    this.selectedValue,
    this.height,
    this.readOnly = false,
  });

  @override
  State<CustomDropdownField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  String? _selectedValue;
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (!widget.readOnly) {
              setState(() => _isDropdownOpen = !_isDropdownOpen);
            }
          },
          child: Container(
            height: widget.height ?? 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedValue ?? widget.hintText,
                  style: GoogleFonts.poppins(
                    color: _selectedValue != null
                        ? Get.theme.secondaryHeaderColor
                        : Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Icon(
                  _isDropdownOpen
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Get.theme.primaryColor,
                ),
              ],
            ),
          ),
        ),
        if (_isDropdownOpen)
          Container(
            width: Get.width,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              // border: Border.all(color: Colors.grey.shade100,),
              color: Get.theme.cardColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(widget.items.length, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedValue = widget.items[index];
                          _isDropdownOpen = false;
                        });
                        if (widget.onChanged != null) {
                          widget.onChanged!(widget.items[index]);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Poppins(
                          text: widget.items[index],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Get.theme.secondaryHeaderColor,
                        ),
                      ),
                    ),
                    if (index != widget.items.length - 1)
                      Divider(
                          height: 1,
                          color: Get.theme.hintColor.withOpacity(.4)),
                  ],
                );
              }),
            ),
          ),
      ],
    );
  }
}
