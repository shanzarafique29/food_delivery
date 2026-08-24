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