import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSwitch extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? activeCircleColor;
  final Color? inactiveCircleColor;

  const CustomSwitch({
    Key? key,
    this.initialValue = false,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.activeCircleColor,
    this.inactiveCircleColor,
  }) : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late bool isSwitched;

  @override
  void initState() {
    super.initState();
    isSwitched = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSwitched = !isSwitched;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(isSwitched);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 40,
        height: 24,
        decoration: BoxDecoration(
          color: isSwitched
              ? (widget.activeColor ?? Colors.blue)
              : (widget.inactiveColor ?? Get.theme.hintColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: isSwitched ? 20 : 3,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: isSwitched
                      ? (widget.activeCircleColor ?? Get.theme.scaffoldBackgroundColor)
                      : (widget.inactiveCircleColor ?? Get.theme.secondaryHeaderColor),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}