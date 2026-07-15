// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _geofenceIdMeta = const VerificationMeta(
    'geofenceId',
  );
  @override
  late final GeneratedColumn<String> geofenceId = GeneratedColumn<String>(
    'geofence_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _placeDescriptionMeta = const VerificationMeta(
    'placeDescription',
  );
  @override
  late final GeneratedColumn<String> placeDescription = GeneratedColumn<String>(
    'place_description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    geofenceId,
    placeDescription,
    title,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('geofence_id')) {
      context.handle(
        _geofenceIdMeta,
        geofenceId.isAcceptableOrUnknown(data['geofence_id']!, _geofenceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_geofenceIdMeta);
    }
    if (data.containsKey('place_description')) {
      context.handle(
        _placeDescriptionMeta,
        placeDescription.isAcceptableOrUnknown(
          data['place_description']!,
          _placeDescriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_placeDescriptionMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      geofenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}geofence_id'],
      )!,
      placeDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_description'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final int id;
  final String geofenceId;
  final String placeDescription;
  final String title;
  final String note;
  const Reminder({
    required this.id,
    required this.geofenceId,
    required this.placeDescription,
    required this.title,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['geofence_id'] = Variable<String>(geofenceId);
    map['place_description'] = Variable<String>(placeDescription);
    map['title'] = Variable<String>(title);
    map['note'] = Variable<String>(note);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      geofenceId: Value(geofenceId),
      placeDescription: Value(placeDescription),
      title: Value(title),
      note: Value(note),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<int>(json['id']),
      geofenceId: serializer.fromJson<String>(json['geofenceId']),
      placeDescription: serializer.fromJson<String>(json['placeDescription']),
      title: serializer.fromJson<String>(json['title']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'geofenceId': serializer.toJson<String>(geofenceId),
      'placeDescription': serializer.toJson<String>(placeDescription),
      'title': serializer.toJson<String>(title),
      'note': serializer.toJson<String>(note),
    };
  }

  Reminder copyWith({
    int? id,
    String? geofenceId,
    String? placeDescription,
    String? title,
    String? note,
  }) => Reminder(
    id: id ?? this.id,
    geofenceId: geofenceId ?? this.geofenceId,
    placeDescription: placeDescription ?? this.placeDescription,
    title: title ?? this.title,
    note: note ?? this.note,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      geofenceId: data.geofenceId.present
          ? data.geofenceId.value
          : this.geofenceId,
      placeDescription: data.placeDescription.present
          ? data.placeDescription.value
          : this.placeDescription,
      title: data.title.present ? data.title.value : this.title,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('geofenceId: $geofenceId, ')
          ..write('placeDescription: $placeDescription, ')
          ..write('title: $title, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, geofenceId, placeDescription, title, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.geofenceId == this.geofenceId &&
          other.placeDescription == this.placeDescription &&
          other.title == this.title &&
          other.note == this.note);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<int> id;
  final Value<String> geofenceId;
  final Value<String> placeDescription;
  final Value<String> title;
  final Value<String> note;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.geofenceId = const Value.absent(),
    this.placeDescription = const Value.absent(),
    this.title = const Value.absent(),
    this.note = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required String geofenceId,
    required String placeDescription,
    required String title,
    required String note,
  }) : geofenceId = Value(geofenceId),
       placeDescription = Value(placeDescription),
       title = Value(title),
       note = Value(note);
  static Insertable<Reminder> custom({
    Expression<int>? id,
    Expression<String>? geofenceId,
    Expression<String>? placeDescription,
    Expression<String>? title,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (geofenceId != null) 'geofence_id': geofenceId,
      if (placeDescription != null) 'place_description': placeDescription,
      if (title != null) 'title': title,
      if (note != null) 'note': note,
    });
  }

  RemindersCompanion copyWith({
    Value<int>? id,
    Value<String>? geofenceId,
    Value<String>? placeDescription,
    Value<String>? title,
    Value<String>? note,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      geofenceId: geofenceId ?? this.geofenceId,
      placeDescription: placeDescription ?? this.placeDescription,
      title: title ?? this.title,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (geofenceId.present) {
      map['geofence_id'] = Variable<String>(geofenceId.value);
    }
    if (placeDescription.present) {
      map['place_description'] = Variable<String>(placeDescription.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('geofenceId: $geofenceId, ')
          ..write('placeDescription: $placeDescription, ')
          ..write('title: $title, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [reminders];
}

typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      required String geofenceId,
      required String placeDescription,
      required String title,
      required String note,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      Value<String> geofenceId,
      Value<String> placeDescription,
      Value<String> title,
      Value<String> note,
    });

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get geofenceId => $composableBuilder(
    column: $table.geofenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeDescription => $composableBuilder(
    column: $table.placeDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geofenceId => $composableBuilder(
    column: $table.geofenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeDescription => $composableBuilder(
    column: $table.placeDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get geofenceId => $composableBuilder(
    column: $table.geofenceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get placeDescription => $composableBuilder(
    column: $table.placeDescription,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
          Reminder,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> geofenceId = const Value.absent(),
                Value<String> placeDescription = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> note = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                geofenceId: geofenceId,
                placeDescription: placeDescription,
                title: title,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String geofenceId,
                required String placeDescription,
                required String title,
                required String note,
              }) => RemindersCompanion.insert(
                id: id,
                geofenceId: geofenceId,
                placeDescription: placeDescription,
                title: title,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
      Reminder,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
}
