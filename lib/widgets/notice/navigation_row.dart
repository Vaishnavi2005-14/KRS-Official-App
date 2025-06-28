import 'package:flutter/material.dart';
import 'navigation_button.dart';

class NavigationRow extends StatelessWidget {
  final VoidCallback? onPrevPressed;
  final VoidCallback? onNextPressed;
  final bool showPrev;
  final bool showNext;

  const NavigationRow({
    super.key,
    this.onPrevPressed,
    this.onNextPressed,
    required this.showPrev,
    required this.showNext,
  });

  @override
  Widget build(BuildContext context) {
    // If neither button should be shown, render nothing
    if (!showPrev && !showNext) {
      return const SizedBox.shrink();
    }

    // If both are shown, space them out
    if (showPrev && showNext) {
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

    // If only one is shown, align it left or right
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        mainAxisAlignment:
            showPrev ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (showPrev)
            NavigationButton(
              text: 'PREV',
              icon: Icons.arrow_back,
              onTap: onPrevPressed ?? () {},
            ),
          if (showNext)
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
