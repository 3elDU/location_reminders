import 'package:flutter/foundation.dart';
import 'package:location_reminders/database.dart';
import 'package:location_reminders/deeplink/notification_page.dart';
import 'package:location_reminders/notifications_service.dart';
import 'package:location_reminders/reminders_service.dart';
import 'package:native_geofence/native_geofence.dart';

@pragma('vm:entry-point')
Future<void> geofenceTriggered(GeofenceCallbackParams params) async {
  debugPrint('Geofence triggered with params: $params');

  final reminders = RemindersService(AppDatabase());
  final notifications = NotificationsService();

  // TODO: figure out when android can send multiple items there
  final geofence = params.geofences.first;

  final reminder = await reminders.find(geofence.id);
  if (reminder == null) {
    debugPrint('Reminder not found in database: ${geofence.id}');
    return;
  }

  await notifications.init();
  notifications.showNotification(
    reminder.title,
    reminder.note,
    NotificationPageDeeplink(reminder.geofenceId).toString(),
  );

  if (reminder.onetime) {
    // TODO: sync with list state, when app is open
    await reminders.complete(reminder);
  }
}
