import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomRadioButton<T> extends StatelessWidget {
  final T? value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;

  const CustomRadioButton({
    Key? key,
    this.value,
    this.groupValue,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: () {
        if (value != null && onChanged != null) {
          onChanged!(value);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Get.theme.primaryColor : Get.theme.hintColor,
            width: 2.0,
          ),
        ),
        child: Icon(
          Icons.circle,
          size: 12,
          color: isSelected ? Get.theme.primaryColor : Get.theme.hintColor,
        ),
      ),
    );
  }
}
