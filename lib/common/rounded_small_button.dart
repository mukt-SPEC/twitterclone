import 'package:flutter/material.dart';

class RoundedSmallButton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonText;
  final Color buttonColor;
  final Color textColor;

  const RoundedSmallButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    required this.buttonColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: buttonColor,
        ),

        child: Text(buttonText, style: TextStyle(color: textColor)),
      ),
    );
  }
}
