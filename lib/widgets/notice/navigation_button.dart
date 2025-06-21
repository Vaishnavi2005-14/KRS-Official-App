import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const NavigationButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xffE5A122), width: 1.5),
        foregroundColor: const Color(0xffE5A122),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        text,
        style: const TextStyle(
          color: Color(0xffE5A122),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      onPressed: onTap,
    );
  }
}
