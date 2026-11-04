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
  bool get searchQueryPresent => _query.isNotEmpty;

  Map<ReminderState, int> _countFetchedReminders() {
    final Map<ReminderState, int> map = {};

    for (final reminder in _reminders) {
      map.update(reminder.state, (value) => value + 1, ifAbsent: () => 1);
    }

    return map;
  }

  void _refresh() async {
    _loading = true;
    notifyListeners();

    _reminders = await _database.query(
      // HACK:
      // when a search query is present, perform filtering by state after the
      // count, so that the reminder counts are visible for every category.
      states: searchQueryPresent ? [] : [_filter],
      search: searchQueryPresent ? query : null,
    );

    // with a non-empty search query, count only the reminders matched by it.
    _counts = searchQueryPresent
        ? _countFetchedReminders()
        : await _database.counts();

    if (searchQueryPresent) {
      _reminders.retainWhere((el) => el.state == _filter);
    }

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

  ReminderHandle createHandle(Reminder reminder) =>
      ReminderHandle(reminder: reminder, list: this, database: _database);
}
