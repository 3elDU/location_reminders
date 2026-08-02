import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:location_reminders/database.dart';
import 'package:location_reminders/models/reminder_handle.dart';
import 'package:location_reminders/services/database.dart';

class ReminderListModel extends ChangeNotifier {
  ReminderListModel(this._database) {
    _refresh();
  }

  final DatabaseService _database;

  List<Reminder> _reminders = [];
  Map<ReminderState, int> _counts = {};
  bool _loading = true;
  ReminderState _filter = .active;
  String _query = '';

  UnmodifiableListView<Reminder> get list => UnmodifiableListView(_reminders);
  UnmodifiableMapView<ReminderState, int> get counts =>
      UnmodifiableMapView(_counts);
  bool get loading => _loading;
  ReminderState get filter => _filter;
  String get query => _query;

  Map<ReminderState, int> _countFetchedReminders() {
    final Map<ReminderState, int> map = {};

    for (final reminder in _reminders) {
      if (map.containsKey(reminder.state)) {
        map[reminder.state] = map[reminder.state]! + 1;
      } else {
        map[reminder.state] = 1;
      }
    }

    return map;
  }

  void _refresh() async {
    _loading = true;
    notifyListeners();

    _reminders = await _database.query(
      states: [_filter],
      search: _query.isNotEmpty ? query : null,
    );

    // if the search query is not empty, count the reminders matched by it.
    // otherwise, count all the reminder in the database.
    _counts = query.isNotEmpty
        ? _countFetchedReminders()
        : await _database.counts();

    _loading = false;
    notifyListeners();
  }

  void setFilter(ReminderState filter) {
    _filter = filter;
    _refresh();
  }

  void setSearchQuery(String query) {
    _query = query;
    _refresh();
  }

  /// should be called when the database is mutated. refreshes the list of reminders
  void markChanged() {
    _refresh();
  }

  /// Get a modifiable reminder handle
  ReminderHandle getHandle(int index) => ReminderHandle(
    reminder: _reminders[index],
    list: this,
    database: _database,
  );
}
