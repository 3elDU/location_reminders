import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class Geofences extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get geofenceId => text()();
  TextColumn get placeDescription => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get radius => real()();
}

enum ReminderState { active, postponed, completed }

class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get geofenceId => integer().references(Geofences, #id)();
  TextColumn get placeDescription => text()();
  BoolColumn get onetime => boolean()();
  TextColumn get title => text()();
  TextColumn get note => text()();
  TextColumn get state => textEnum<ReminderState>()();
}

@DriftDatabase(tables: [Reminders])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'app_db');
  }
}
