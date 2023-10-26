import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class CustomBadge extends StatelessWidget {
  final int value;
  const CustomBadge({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Visibility(
      visible: value > 0,
      child: Container(
        height: 18,
        width: 18,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: themeData.colorScheme.primary, shape: BoxShape.circle),
        child: Text(
          value.toString().toPersianDigit(),
          style: themeData.textTheme.bodyMedium!
              .copyWith(color: themeData.colorScheme.onPrimary, fontSize: 10),
        ),
      ),
    );
  }
}
