import 'package:flutter/material.dart';

class NoticeBoardHeader extends StatelessWidget implements PreferredSizeWidget {
  const NoticeBoardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xff10162a),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'NOTICE BOARD',
            style: TextStyle(
              color: Color(0xffE5A122),
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const Divider(
          color: Color(0xffE5A122),
          thickness: 1.2,
          height: 0,
          indent: 18,
          endIndent: 18,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.2);
}
