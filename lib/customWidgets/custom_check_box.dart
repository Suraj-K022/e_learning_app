import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CustomCheckBox({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          border: Border.all(
            color: value ? Get.theme.primaryColor : Colors.grey.shade400,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: value
            ? Icon(
          Icons.check,
          color: Get.theme.primaryColor,
          size: 16,
        )
            : null,
      ),
    );
  }
}
