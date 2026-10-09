import 'package:flutter/foundation.dart';
import 'package:location_reminders/database.dart';
import 'package:location_reminders/deeplink/notification_page.dart';
import 'package:location_reminders/services/notifications.dart';
import 'package:location_reminders/services/database.dart';
import 'package:native_geofence/native_geofence.dart';

@pragma('vm:entry-point')
Future<void> geofenceTriggered(GeofenceCallbackParams params) async {
  debugPrint('Geofence triggered with params: $params');

  final reminders = DatabaseService(database: AppDatabase());
  final notifications = NotificationsService();

  // TODO: figure out when android can send multiple items there
  final geofence = params.geofences.first;

  final reminder = await reminders.findReminder(geofence.id);
  if (reminder == null) {
    debugPrint('Reminder not found in database: ${geofence.id}');
    return;
  }

  if (reminder.state != .active) return;

  await notifications.init();
  notifications.showNotification(
    reminder.title,
    reminder.note,
    NotificationPageDeeplink(geofence.id).toString(),
  );

  if (reminder.onetime) {
    // TODO: sync with list state, when app is open
    await reminders.complete(reminder);
  }
}
