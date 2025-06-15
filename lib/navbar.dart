import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:krs_app/providers/navprovider.dart';
import 'package:provider/provider.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final navProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      body: navProvider.currentScreen,
      bottomNavigationBar: Container(
        height: isTablet ? screenHeight * 0.1 : screenHeight * 0.11,
        decoration: const BoxDecoration(
          color: Color(0xff06132A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 15 : 10,
          horizontal: screenWidth * 0.05,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              context,
              navProvider,
              index: 0,
              image: 'assets/home.svg',
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              isTablet: isTablet,
            ),
            _buildNavItem(
              context,
              navProvider,
              index: 1,
              image: 'assets/mail-notification.svg',
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              isTablet: isTablet,
            ),
            _buildNavItem(
              context,
              navProvider,
              index: 2,
              image: 'assets/profile.svg',
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              isTablet: isTablet,
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
    required double screenWidth,
    required double screenHeight,
    required bool isTablet,
  }) {
    final bool isSelected = navProvider.selectedIndex == index;
    return InkWell(
      onTap: () => navProvider.setIndex(index),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 18 : 13),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffE5A122) : Colors.transparent,
          borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
        ),
        child: SvgPicture.asset(
          image,
          height: isTablet ? screenHeight * 0.05 : screenHeight * 0.04,
          width: isTablet ? screenHeight * 0.05 : screenHeight * 0.04,
          colorFilter: ColorFilter.mode(
            isSelected ? Colors.black : Color(0xffE5A122),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
