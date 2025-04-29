import 'package:flutter/material.dart';
import '../constants.dart';

class MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const MenuButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: onPressed,
      child: Text(text, style: buttonTextStyle),
    );
  }
}
