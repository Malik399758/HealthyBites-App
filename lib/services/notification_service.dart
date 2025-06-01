// push notification
/*

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Get Token for current device
  static Future<String?> getDeviceToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Initialize FCM and set up listeners
  static Future<void> initFCM() async {
    await _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received in foreground: ${message.notification?.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("App opened from background: ${message.notification?.title}");
    });
  }

  static Future<void> sendNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    const String serverKey = '';

    final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode({
        "to": token,
        "notification": {
          "title": title,
          "body": body,
        },
        "priority": "high",
      }),
    );

    if (response.statusCode == 200) {
      print("Notification sent");
    } else {
      print("Failed to send notification: ${response.body}");
    }
  }
}
*/
