import 'package:flutter/foundation.dart';
import 'package:location_reminders/database.dart';
import 'package:location_reminders/models/reminder_list.dart';
import 'package:location_reminders/services/database.dart';

class ReminderHandle extends ChangeNotifier {
  Reminder reminder;
  final ReminderListModel _list;
  final DatabaseService _database;

  ReminderHandle({
    required this.reminder,
    required this._list,
    required this._database,
  });

  void uncomplete() async {
    reminder = await _database.uncomplete(reminder);
    _list.markChanged();
    notifyListeners();
  }

  void complete() async {
    reminder = await _database.complete(reminder);
    _list.markChanged();
    notifyListeners();
  }
}
