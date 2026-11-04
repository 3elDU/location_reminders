// User-facing permission info
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDescription {
  const PermissionDescription(
    this.name,
    this.description,
    this.reasonForUse,
    this.request,
  );

  final String name;
  final String description;
  final String reasonForUse;
  // Returns true if granted
  final Future<bool> Function() request;
}

// Manages Android permissions
class PermissionService {
  // permissions that require explicit user action to grant
  static const Map<String, PermissionDescription> requiredPermissions = {
    "location": PermissionDescription(
      "Location",
      "Access location while the app is open",
      "Used to automatically center the map at your location",
      requestLocation,
    ),
    "background_location": PermissionDescription(
      "Background Location",
      "Access your location while the app is in background",
      "Used to check, which reminders are close to you",
      requestBackgroundLocation,
    ),
    "notification": PermissionDescription(
      "Notifications",
      "Send you notifications",
      "Used to send you the reminders",
      requestNotifications,
    ),
  };

  static Future<List<PermissionDescription>> get missingPermissions async {
    List<PermissionDescription> missing = [];

    final locationStatus = await Permission.location.status;
    final bgLocationStatus = await Permission.locationAlways.status;
    final notificationStatus = await Permission.notification.status;

    if (!locationStatus.isGranted) {
      missing.add(requiredPermissions['location']!);
    }
    if (!bgLocationStatus.isGranted) {
      missing.add(requiredPermissions['background_location']!);
    }
    if (!notificationStatus.isGranted) {
      missing.add(requiredPermissions['notification']!);
    }

    return missing;
  }

  static Future<bool> requestLocation() {
    return Permission.location.request().then((status) => status.isGranted);
  }

  static Future<bool> requestBackgroundLocation() {
    return Permission.locationAlways.request().then(
      (status) => status.isGranted,
    );
  }

  static Future<bool> requestNotifications() {
    return FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()!
        .requestNotificationsPermission()
        .then((granted) => granted ?? false);
  }
}
