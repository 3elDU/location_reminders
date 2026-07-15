import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';

class PendingNoteModel extends ChangeNotifier {
  bool creating = false;

  String _title = '';
  Location? _location;
  String _note = '';
  double _radius = 150;

  String get title => _title;
  Location? get location => _location;
  String get note => _note;
  double get radius => _radius;

  void startCreation(Location location) {
    creating = true;
    _title = '';
    _note = '';
    _radius = 150;
    _location = location;
    notifyListeners();
  }

  void finishCreation() {
    creating = false;
    notifyListeners();
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
}
