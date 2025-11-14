import 'package:flutter/material.dart';

class ResendCodeButton extends StatelessWidget {
  final int countdown;
  final VoidCallback onResend;

  const ResendCodeButton({
    super.key,
    required this.countdown,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    bool isActive = countdown == 0;
    String countdownText = countdown.toString().padLeft(2, '0');

    return TextButton(
      onPressed: isActive ? onResend : null,
      child: Text(
        isActive
            ? "Kirim Ulang Kode"
            : "Kirim Ulang Kode (00:$countdownText)",
        style: TextStyle(
          color: isActive ? Theme.of(context).primaryColor : Colors.grey,
          fontSize: 16,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}