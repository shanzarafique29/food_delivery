// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/foundation.dart';

// @pragma('vm:entry-point')
// void notificationTapBackground(NotificationResponse notificationResponse) {
//   if (notificationResponse.payload == 'offers') {
//     debugPrint(
//       'Background notification payload: ${notificationResponse.payload}',
//     );
//   }
// }

// class NotificationService {
//   static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin _localNotifications =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> initialize() async {
//     // 1. Request permission
//     await _messaging.requestPermission(alert: true, badge: true, sound: true);

//     // 2. Subscribe to topic
//     await _messaging.subscribeToTopic('offers');

//     // 3. Local notifications initialization
//     const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosInit = DarwinInitializationSettings();

//     const initSettings = InitializationSettings(
//       android: androidInit,
//       iOS: iosInit,
//     );

//     await _localNotifications.initialize(
//       settings: initSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         if (response.payload == 'offers') {
//           _navigateToOffersScreen();
//         }
//       },
//       onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
//     );

//     const androidChannel = AndroidNotificationChannel(
//       'offers_channel',
//       'Offers Notifications',
//       description: 'Notifications for new offers',
//       importance: Importance.max,
//     );

//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(androidChannel);

//     // 5. Handle FOREGROUND messages (FCM doesn't show heads-up UI automatically in foreground)
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _showLocalNotification(message);
//     });

//     // 6. Handle notification click when app is in BACKGROUND
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint('App opened from background via notification');
//       _navigateToOffersScreen();
//     });

//     // 7. Handle notification click when app was TERMINATED
//     final initialMessage = await _messaging.getInitialMessage();
//     if (initialMessage != null) {
//       debugPrint('App launched from terminated state via notification');
//       _navigateToOffersScreen();
//     }
//   }

//   // Local notification display logic
//   static Future<void> _showLocalNotification(RemoteMessage message) async {
//     final notification = message.notification;
//     if (notification == null) return;

//     const androidDetails = AndroidNotificationDetails(
//       'offers_channel',
//       'Offers Notifications',
//       channelDescription: 'Notifications for new offers',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const iosDetails = DarwinNotificationDetails();
//     const details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _localNotifications.show(
//       id: message.hashCode,
//       title: notification.title,
//       body: notification.body,
//       notificationDetails: details,
//       payload: 'offers',
//     );
//   }

//   // Placeholder navigation trigger
//   static void _navigateToOffersScreen() {
//     debugPrint('Navigating to Offers Screen...');
//     // Implement global navigator key or app router logic here
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:food_delivery/features/orders/controller/order_controller.dart';
import 'package:food_delivery/features/orders/views/order_screen.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  if (notificationResponse.payload == 'offers') {
    debugPrint(
      'Background notification payload: ${notificationResponse.payload}',
    );
  } else if (notificationResponse.payload == 'order_update') {
    debugPrint('Background notification payload: order_update');
  }
}

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // 1. Request permission
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // 2. Subscribe to topic (offers ke liye)
    await _messaging.subscribeToTopic('offers');

    // ✅ NEW — device ka FCM token Firestore mein save karo, taake admin
    // is user ko specific order-status notification bhej sake
    await _saveTokenToFirestore();
    _messaging.onTokenRefresh.listen((_) => _saveTokenToFirestore());

    // 3. Local notifications initialization
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload == 'offers') {
          _navigateToOffersScreen();
        } else if (response.payload == 'order_update') {
          _navigateToOrdersScreen();
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // ✅ Offers channel (already tha)
    const offersChannel = AndroidNotificationChannel(
      'offers_channel',
      'Offers Notifications',
      description: 'Notifications for new offers',
      importance: Importance.max,
    );

    // ✅ NEW — order updates ke liye alag channel
    const orderChannel = AndroidNotificationChannel(
      'order_updates_channel',
      'Order Updates',
      description: 'Notifications when your order status changes',
      importance: Importance.max,
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(offersChannel);
    await androidPlugin?.createNotificationChannel(orderChannel); // ✅ NEW

    // 5. Handle FOREGROUND messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    // 6. Handle notification click when app is in BACKGROUND
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('App opened from background via notification');
      _handleMessageNavigation(message);
    });

    // 7. Handle notification click when app was TERMINATED
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('App launched from terminated state via notification');
      _handleMessageNavigation(initialMessage);
    }
  }

  // ✅ NEW — FCM token ko users/{uid} document mein save karta hai
  static Future<void> _saveTokenToFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return; // login se pehle koi token save nahi hoga

      final token = await _messaging.getToken();
      if (token == null) return;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Failed to save FCM token: $e');
    }
  }

  static void _handleMessageNavigation(RemoteMessage message) {
    if (message.data['orderId'] != null &&
        message.data['orderId'].toString().isNotEmpty) {
      _navigateToOrdersScreen();
    } else {
      _navigateToOffersScreen();
    }
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final bool isOrderUpdate =
        message.data['orderId'] != null &&
        message.data['orderId'].toString().isNotEmpty;

    final androidDetails = AndroidNotificationDetails(
      isOrderUpdate ? 'order_updates_channel' : 'offers_channel',
      isOrderUpdate ? 'Order Updates' : 'Offers Notifications',
      channelDescription: isOrderUpdate
          ? 'Notifications when your order status changes'
          : 'Notifications for new offers',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: message.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: details,
      payload: isOrderUpdate ? 'order_update' : 'offers',
    );
  }

  static void _navigateToOffersScreen() {
    debugPrint('Navigating to Offers Screen...');
  }

  static void _navigateToOrdersScreen() {
    debugPrint('Navigating to Orders Screen...');
    Get.to(
      () => const OrderScreen(
        statuses: OrderController.activeStatuses,
        screenTitle: 'Orders',
      ),
    );
  }
}
