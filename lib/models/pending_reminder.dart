import 'package:flutter/foundation.dart';
import 'package:location_reminders/models/location.dart';
import 'package:location_reminders/models/reminder_list.dart';
import 'package:location_reminders/services/database.dart';

class PendingReminderModel extends ChangeNotifier {
  final DatabaseService _database;
  final ReminderListModel? list;
  PendingReminderModel(this._database, {this.list});

  bool creating = false;

  String _title = '';
  Location? _location;
  String _note = '';
  double _radius = 150;
  bool _onetime = false;

  String get title => _title;
  Location? get location => _location;
  String get note => _note;
  double get radius => _radius;
  bool get onetime => _onetime;

  bool get isValid => _title.isNotEmpty && _location != null;

  void startCreation(Location location) {
    creating = true;
    _title = '';
    _note = '';
    _radius = 150;
    _location = location;
    notifyListeners();
  }

  void finishCreation() async {
    creating = false;
    notifyListeners();

    await _database.create(this);
    list?.markChanged();
  }

  void updateLocation(Location location) {
    _location = location;
    notifyListeners();
  }

  void updateRadius(double radius) {
    _radius = radius;
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
