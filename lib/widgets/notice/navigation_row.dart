import 'package:flutter/material.dart';
import 'navigation_button.dart';

class NavigationRow extends StatelessWidget {
  final VoidCallback? onPrevPressed;
  final VoidCallback? onNextPressed;

  const NavigationRow({
    super.key,
    this.onPrevPressed,
    this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NavigationButton(
            text: 'PREV',
            icon: Icons.arrow_back,
            onTap: onPrevPressed ?? () {},
          ),
          NavigationButton(
            text: 'NEXT',
            icon: Icons.arrow_forward,
            onTap: onNextPressed ?? () {},
          ),
        ],
      ),
    );
  }
}
