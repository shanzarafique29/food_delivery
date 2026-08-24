// import 'package:flutter/material.dart';
// import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
// import 'package:food_delivery/const/app_colors.dart';
// import 'package:get/get.dart';
// import 'package:food_delivery/features/dashboard.dart';
// import 'package:food_delivery/features/home/controller/ZoomDrawerController.dart';
// import 'package:food_delivery/features/home/view/side_menu_screen.dart';

// class RootScreen extends StatelessWidget {
//   const RootScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final drawerController = Get.put(MainDrawerController());

//     ZoomDrawer(
//       controller: drawerController.zoomDrawerController,
//       menuScreen: const SideMenuScreen(),
//       mainScreen: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(28),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.25),
//               blurRadius: 30,
//               spreadRadius: 2,
//               offset: const Offset(0, 12),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(28),
//           child: Dashboard(),
//         ),
//       ),
//       borderRadius: 28.0,
//       showShadow: false,
//       angle: 0.0,
//       mainScreenScale: 0.18,
//       slideWidth: MediaQuery.of(context).size.width * 0.65,
//       menuBackgroundColor: AppColor.primary,
//     );

//     return ZoomDrawer(
//       controller: drawerController.zoomDrawerController,
//       menuScreen: const SideMenuScreen(),
//       mainScreen: GestureDetector(
//         onTap: () {
//           if (drawerController.zoomDrawerController.isOpen?.call() ?? false) {
//             drawerController.closeDrawer();
//           }
//         },
//         child: Dashboard(),
//       ),
//       borderRadius: 28.0,
//       showShadow: true,
//       angle: 0.0,
//       mainScreenScale: 0.18,
//       slideWidth: MediaQuery.of(context).size.width * 0.65,
//       openCurve: Curves.easeOutCubic,
//       closeCurve: Curves.easeInCubic,
//       duration: Duration(milliseconds: 280),
//       dragOffset: 60.0,
//       openDragSensitivity: 400,
//       closeDragSensitivity: 400,
//       menuBackgroundColor: AppColor.primary,
//       menuScreenWidth: MediaQuery.of(context).size.width * 0.65,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:get/get.dart';
import 'package:food_delivery/features/dashboard.dart';
import 'package:food_delivery/features/home/controller/ZoomDrawerController.dart';
import 'package:food_delivery/features/home/view/side_menu_screen.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerController = Get.put(MainDrawerController());

    return ZoomDrawer(
      controller: drawerController.zoomDrawerController,

      menuScreen: const SideMenuScreen(),

      mainScreen: GestureDetector(
        onTap: () {
          if (drawerController.zoomDrawerController.isOpen?.call() ?? false) {
            drawerController.closeDrawer();
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Dashboard(),
        ),
      ),

      borderRadius: 28.0,
      showShadow: true,
      angle: 0.0,
      mainScreenScale: 0.18,

      slideWidth: MediaQuery.of(context).size.width * 0.65,
      menuScreenWidth: MediaQuery.of(context).size.width * 0.65,

      openCurve: Curves.easeOutCubic,
      closeCurve: Curves.easeInCubic,

      duration: const Duration(milliseconds: 280),

      dragOffset: 60.0,
      openDragSensitivity: 400,
      closeDragSensitivity: 400,

      menuBackgroundColor: AppColor.primary,
    );
  }
}