import 'package:flutter/material.dart';
import 'package:food_delivery/features/controller/navcontroller.dart';
import 'package:food_delivery/features/favoritescreen.dart';
import 'package:food_delivery/features/historyscreen.dart';
import 'package:food_delivery/features/homescreen.dart';
import 'package:food_delivery/features/profilescreen.dart';
import 'package:get/get.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final NavController controller = Get.put(NavController());

  static const Color activeColor = Color(0xFFFF3B1F);
  static const Color inactiveColor = Colors.grey;

  final List<Widget> screens = const [
    HomeScreen(),
    Favoritescreen(),
    Profilescreen(),
    Historyscreen(),
  ];

  final List<IconData> icons = const [
    Icons.home_rounded,
    Icons.favorite_border_rounded,
    Icons.person_outline_rounded,
    Icons.history_rounded,
  ];

  @override
  Widget build(BuildContext context) {
       final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: screens,
        ),
      ),
      bottomNavigationBar: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (index) {
              final bool isActive = controller.selectedIndex.value == index;
              return GestureDetector(
                onTap: () => controller.changeTab(index),
                child: Icon(
                  icons[index],
                  color: isActive ? activeColor : inactiveColor,
                  size: size.width * 0.08,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}