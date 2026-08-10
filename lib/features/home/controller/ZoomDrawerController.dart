// import 'package:get/get.dart';

// class MainDrawerController extends GetxController {
//   // 0.0 = fully closed, 1.0 = fully open
//   RxDouble dragValue = 0.0.obs;
//   RxBool isDrawerOpen = false.obs;
//   RxBool isDragging = false.obs;

//   void toggleDrawer() {
//     isDrawerOpen.value = !isDrawerOpen.value;
//     dragValue.value = isDrawerOpen.value ? 1.0 : 0.0;
//   }

//   void closeDrawer() {
//     isDrawerOpen.value = false;
//     dragValue.value = 0.0;
//   }

//   void openDrawer() {
//     isDrawerOpen.value = true;
//     dragValue.value = 1.0;
//   }

//   // Drag ke doraan live update
//   void updateDrag(double delta, double maxDrag) {
//     isDragging.value = true;
//     double newValue = dragValue.value + (delta / maxDrag);
//     dragValue.value = newValue.clamp(0.0, 1.0);
//   }

//   // Finger uthane par decide karo: open rahe ya close ho
//   void endDrag() {
//     isDragging.value = false;
//     if (dragValue.value > 0.5) {
//       openDrawer();
//     } else {
//       closeDrawer();
//     }
//   }
// }
import 'package:get/get.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class MainDrawerController extends GetxController {
  final ZoomDrawerController zoomDrawerController = ZoomDrawerController();

  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
  }

  void openDrawer() {
    zoomDrawerController.open?.call();
  }

  void closeDrawer() {
    zoomDrawerController.close?.call();
  }
}