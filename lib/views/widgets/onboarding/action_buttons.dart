import 'package:flutter/material.dart';

class OnboardingActionButtons extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onSkip;
  final VoidCallback onContinue;
  final VoidCallback onGetStarted;

  const OnboardingActionButtons({
    super.key,
    required this.isLastPage,
    required this.onSkip,
    required this.onContinue,
    required this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return isLastPage
        ? _buildFullWidthButton(
      context: context,
      text: 'Get Started',
      onPressed: onGetStarted,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    )
        : _buildDualButtons(
      context: context,
      primaryColor: primaryColor,
    );
  }

  Widget _buildDualButtons({required BuildContext context, required Color primaryColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade600,
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Skip', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildFullWidthButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color foregroundColor}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}