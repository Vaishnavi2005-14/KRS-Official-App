import 'package:flutter/material.dart';

class AttendanceHome extends StatefulWidget {
  const AttendanceHome({super.key});

  @override
  State<AttendanceHome> createState() => _AttendanceHomeState();
}

class _AttendanceHomeState extends State<AttendanceHome> {
  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(s.height * 0.1),
        child: SafeArea(
          child: Center(
            child: Text(
              "ATTENDANCE",
              style: TextStyle(
                color: Color(0xffE5A122),
                fontSize: s.width * 0.1,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xffE5A122),
        child: Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
