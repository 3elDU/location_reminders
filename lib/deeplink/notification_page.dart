/// A utility class to encode a notification id in a string payload
class NotificationPageDeeplink {
  NotificationPageDeeplink(this.geofenceId);

  final String geofenceId;

  static NotificationPageDeeplink? tryFromPayload(String? payload) {
    if (payload == null) return null;

    final match = RegExp(r'^\/notes\/(zone_\d+)$').firstMatch(payload);

    return match != null ? NotificationPageDeeplink(match[1]!) : null;
  }

  @override
  String toString() => '/notes/$geofenceId';
}
