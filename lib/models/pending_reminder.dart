import 'package:flutter/foundation.dart';
import 'package:location_reminders/models/location.dart';
import 'package:location_reminders/models/reminder_list.dart';
import 'package:location_reminders/services/database.dart';
import 'package:location_reminders/models/geofence.dart';

class PendingReminderModel extends ChangeNotifier {
  final DatabaseService _database;
  final ReminderListModel? list;
  PendingReminderModel(this._database, {this.list})
    : _geofence = Geofence.empty(_database);

  bool creating = false;

  String _title = '';
  String _note = '';
  bool _onetime = false;
  Geofence _geofence;

  Geofence get geofence => _geofence;
  String get title => _title;
  Location get location => _geofence.location;
  String get note => _note;
  double get radius => _geofence.radius;
  bool get onetime => _onetime;

  bool get isValid => _title.isNotEmpty && _geofence.location.isNotEmpty;

  void startCreation(Location location) {
    creating = true;
    _title = '';
    _note = '';
    _geofence = Geofence.empty(_database);

    notifyListeners();
  }

  void finishCreation() async {
    creating = false;
    notifyListeners();

    await _database.create(this);
    list?.markChanged();
  }

  void updateLocation(Location location) {
    _geofence.location = location;
    notifyListeners();
  }

  void updateRadius(double radius) {
    _geofence.radius = radius;
    notifyListeners();
  }

  void updateTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void updateNote(String note) {
    _note = note;
    notifyListeners();
  }

  void updateOnetime(bool onetime) {
    _onetime = onetime;
    notifyListeners();
  }
}
