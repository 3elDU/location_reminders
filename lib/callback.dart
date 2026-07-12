import 'package:flutter/foundation.dart';
import 'package:location_reminders/notifications_service.dart';
import 'package:native_geofence/native_geofence.dart';

@pragma('vm:entry-point')
Future<void> geofenceTriggered(GeofenceCallbackParams params) async {
  debugPrint('Geofence triggered with params: $params');

  final notifications = NotificationsService();
  await notifications.init();

  notifications.showNotification(
    params.geofences.map((g) => g.id).join(', '),
    'Geofence triggered event ${params.event.name}, location ${params.location ?? 'N/A'}',
  );
}
