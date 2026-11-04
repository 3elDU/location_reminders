/// A utility class to encode a notification id in a string payload
class NotificationPageDeeplink {
  NotificationPageDeeplink(this.geofenceId);

  final String geofenceId;

  static NotificationPageDeeplink? tryFromPayload(String? payload) {
    if (payload == null) return null;

    final match = RegExp(r'^\/notes\/([0-9a-f-]+)$').firstMatch(payload);

    if (match == null || match.groupCount != 1) {
      return null;
    }

    return NotificationPageDeeplink(match[1]!);
  }

  @override
  String toString() => '/notes/$geofenceId';
}
