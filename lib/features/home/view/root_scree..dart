// import 'package:flutter/material.dart';
// import 'package:food_delivery/features/dashboard.dart';
// import 'package:food_delivery/features/home/controller/ZoomDrawerController.dart';
// import 'package:get/get.dart';
// import 'package:food_delivery/features/home/view/side_menu_screen.dart';

// class RootScreen extends StatelessWidget {
//   const RootScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final drawerController = Get.put(MainDrawerController());
//     final size = MediaQuery.of(context).size;
//     final double maxDragDistance = size.width * 0.65;

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Stack(
//         children: [
//           // Background orange menu
//           const SideMenuScreen(),

//           // Foreground: Dashboard (draggable + tappable)
//           Obx(() {
//             final progress = drawerController.dragValue.value;
//             final isOpen = drawerController.isDrawerOpen.value;
//             final isDragging = drawerController.isDragging.value;

//             final double translateX = maxDragDistance * progress;
//             final double scale = 1.0 - (0.18 * progress);
//             final double radius = 28 * progress;

//             return AnimatedContainer(
//               duration: isDragging
//                   ? Duration.zero
//                   : const Duration(milliseconds: 280),
//               curve: Curves.easeOutCubic,
//               transform: Matrix4.identity()
//                 ..translate(translateX)
//                 ..scale(scale),
//               transformAlignment: Alignment.centerLeft,
//               // 👇 Ye outer container SIRF shadow ke liye — koi clip nahi
//               decoration: BoxDecoration(
//   borderRadius: BorderRadius.circular(radius),
//   boxShadow: progress > 0
//       ? [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.25 * progress),
//             blurRadius: 20,
//             spreadRadius: 2,
//             offset: const Offset(-8, 12), // thoda niche aur left shadow
//           ),
//         ]
//       : [],
// ),

//               child: GestureDetector(
//                 onHorizontalDragUpdate: (details) {
//                   drawerController.updateDrag(
//                     details.delta.dx,
//                     maxDragDistance,
//                   );
//                 },
//                 onHorizontalDragEnd: (details) {
//                   if (details.primaryVelocity != null) {
//                     if (details.primaryVelocity! > 300) {
//                       drawerController.openDrawer();
//                       return;
//                     } else if (details.primaryVelocity! < -300) {
//                       drawerController.closeDrawer();
//                       return;
//                     }
//                   }
//                   drawerController.endDrag();
//                 },
//                 onTap: () {
//                   if (isOpen) {
//                     drawerController.closeDrawer();
//                   }
//                 },
//                 // 👇 Ye ClipRRect SIRF rounding/clip ke liye — koi shadow nahi
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(radius),
//                   child: AbsorbPointer(
//                     absorbing: isOpen,
//                     child: Dashboard(),
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ],
//       ),
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
     

ZoomDrawer(
  controller: drawerController.zoomDrawerController,
  menuScreen: const SideMenuScreen(),
  mainScreen: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 30,
          spreadRadius: 2,
          offset: const Offset(0, 12),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Dashboard(),
    ),
  ),
  borderRadius: 28.0,
  showShadow: false,
  angle: 0.0,
  mainScreenScale: 0.18,
  slideWidth: MediaQuery.of(context).size.width * 0.65,
  menuBackgroundColor: AppColor.primary,
);

    return ZoomDrawer(
      controller: drawerController.zoomDrawerController,
      menuScreen: const SideMenuScreen(),
      mainScreen: GestureDetector(
        onTap: () {
          if (drawerController.zoomDrawerController.isOpen?.call() ?? false) {
            drawerController.closeDrawer();
          }
        },
        child: Dashboard(),
      ),
      borderRadius: 28.0,
      showShadow: true,
      angle: 0.0,
      mainScreenScale: 0.18,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      openCurve: Curves.easeOutCubic,
      closeCurve: Curves.easeInCubic,
      duration:  Duration(milliseconds: 280),
      dragOffset: 60.0,
      openDragSensitivity: 400,
      closeDragSensitivity: 400,
      menuBackgroundColor: AppColor.primary,
      menuScreenWidth: MediaQuery.of(context).size.width * 0.65
    );
  }
}