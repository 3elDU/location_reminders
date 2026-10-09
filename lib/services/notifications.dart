import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _plugin.initialize(
      settings: InitializationSettings(
        android: AndroidInitializationSettings('@drawable/ic_stat_name'),
      ),
    );
  }

  Future<void> showNotification(
    String title,
    String body,
    String? payload,
  ) async {
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
      payload: payload,
    );
  }
}
