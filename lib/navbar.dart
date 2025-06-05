import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:krs_app/providers/navprovider.dart';
import 'package:provider/provider.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final navProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      body: navProvider.currentScreen,
      bottomNavigationBar: Container(
        height: h * 0.1,
        decoration: const BoxDecoration(
          color: Color(0xff06132A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              context,
              navProvider,
              index: 0,
              image: 'assets/home.svg',
            ),
            _buildNavItem(
              context,
              navProvider,
              index: 1,
              image: 'assets/attendance.svg',
            ),
            _buildNavItem(
              context,
              navProvider,
              index: 2,
              image: 'assets/profile.svg',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    NavigationProvider navProvider, {
    required int index,
    required String image,
  }) {
    final double h = MediaQuery.of(context).size.height;
    final bool isSelected = navProvider.selectedIndex == index;
    return InkWell(
      onTap: () => navProvider.setIndex(index),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffE5A122) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(
          image,
          height: h * 0.06,
          width: h * 0.06,
          colorFilter: ColorFilter.mode(
            isSelected ? Colors.black : Color(0xffE5A122),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
