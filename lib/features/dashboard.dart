import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/features/controller/navcontroller.dart';
import 'package:food_delivery/features/favorite/views/favorite_screen.dart';
import 'package:food_delivery/features/home/view/homescreen.dart';
import 'package:food_delivery/features/orders/controller/order_controller.dart';
import 'package:food_delivery/features/orders/views/order_screen.dart';
import 'package:food_delivery/features/profile/views/profile_screen.dart';
import 'package:get/get.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final NavController controller = Get.put(NavController());



  static const Color activeColor = Color(0xFFFF3B1F);
  static const Color inactiveColor = Colors.grey;
  final List<Widget> screens = [
    const HomeScreen(),
    FavoriteScreen(),
    ProfileScreen(),
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
      backgroundColor: AppColor.background,
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
        
              final bool isActive = index < screens.length && controller.selectedIndex.value == index;

              return GestureDetector(
                onTap: () {
                  if (index == 3) {
                  
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderScreen(
                          statuses: OrderController.historyStatuses,
                          screenTitle: 'History',
                          emptyIcon: Icons.history_rounded,
                          emptyTitle: 'No history yet',
                          showClearHistory: true, 
                        ),
                      ),
                    );
                  } else {
                    controller.changeTab(index);
                  }
                },
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