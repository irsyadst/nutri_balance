import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpInputField extends StatelessWidget {
  final TextEditingController controller;
  final int length;
  final Function(String)? onCompleted;
  final PinTheme? defaultPinTheme;
  final PinTheme? focusedPinTheme;
  final PinTheme? errorPinTheme;

  const OtpInputField({
    super.key,
    required this.controller,
    this.length = 6,
    this.onCompleted,
    this.defaultPinTheme,
    this.focusedPinTheme,
    this.errorPinTheme,
  });

  @override
  Widget build(BuildContext context) {
    final defaultTheme = defaultPinTheme ?? PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black87),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
    );

    final focusedTheme = focusedPinTheme ?? defaultTheme.copyWith(
      decoration: defaultTheme.decoration!.copyWith(
        border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
        color: Colors.white,
      ),
    );

    final errorTheme = errorPinTheme ?? defaultTheme.copyWith(
      decoration: defaultTheme.decoration!.copyWith(
        border: Border.all(color: Colors.redAccent, width: 1.5),
      ),
    );


    return Pinput(
      length: length,
      controller: controller,
      defaultPinTheme: defaultTheme,
      focusedPinTheme: focusedTheme,
      errorPinTheme: errorTheme,
      onCompleted: onCompleted,
      autofocus: true,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
    );
  }
}