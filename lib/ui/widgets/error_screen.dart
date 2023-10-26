import 'package:flutter/material.dart';
import 'package:nike/common/exceptions.dart';

class ErrorScreen extends StatelessWidget {
  final GestureTapCallback onPressed;
  final AppExceptions exception;
  const ErrorScreen({
    super.key, required this.onPressed, required this.exception,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(exception.message),
        ElevatedButton(
            onPressed: onPressed,
            child: const Text('تلاش مجدد'))
      ],
    ));
  }
}
