import 'package:flutter/material.dart';

class MoMSearchBar extends StatelessWidget {
  final TextEditingController controller;

  final Function(String) onChanged;

  const MoMSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Color(0xffE5A122)),
      onChanged: onChanged,
      cursorColor: Color(0xffE5A122),
      autocorrect: true,
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.search_rounded, color: Color(0xffE5A122)),
        hintText: "Search...",
        hintStyle: TextStyle(color: Color(0xffE5A122)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffE5A122), width: 3),
          borderRadius: BorderRadius.circular(50),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffE5A122), width: 3),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
