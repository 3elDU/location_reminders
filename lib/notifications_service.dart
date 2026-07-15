import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _plugin.initialize(
      settings: InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
  }

  Future<void> showNotification(String title, String body) async {
    debugPrint('Sending notification with title "$title" and body "$body"');
    await _plugin.show(
      id: Random().nextInt(1048576),
      title: title,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'geofence_triggers',
          'Geofence Triggers',
          styleInformation: BigTextStyleInformation(body, contentTitle: title),
        ),
      ),
      payload: 'test',
    );
  }
}
