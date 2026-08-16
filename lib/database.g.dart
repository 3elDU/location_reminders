// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $GeofencesTable extends Geofences
    with TableInfo<$GeofencesTable, Geofence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GeofencesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _radiusMeta = const VerificationMeta('radius');
  @override
  late final GeneratedColumn<double> radius = GeneratedColumn<double>(
    'radius',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    geofenceId,
    placeDescription,
    latitude,
    longitude,
    radius,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'geofences';
  @override
  VerificationContext validateIntegrity(
    Insertable<Geofence> instance, {
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
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('radius')) {
      context.handle(
        _radiusMeta,
        radius.isAcceptableOrUnknown(data['radius']!, _radiusMeta),
      );
    } else if (isInserting) {
      context.missing(_radiusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Geofence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Geofence(
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
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      radius: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}radius'],
      )!,
    );
  }

  @override
  $GeofencesTable createAlias(String alias) {
    return $GeofencesTable(attachedDatabase, alias);
  }
}

class Geofence extends DataClass implements Insertable<Geofence> {
  final int id;
  final String geofenceId;
  final String placeDescription;
  final double latitude;
  final double longitude;
  final double radius;
  const Geofence({
    required this.id,
    required this.geofenceId,
    required this.placeDescription,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['geofence_id'] = Variable<String>(geofenceId);
    map['place_description'] = Variable<String>(placeDescription);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['radius'] = Variable<double>(radius);
    return map;
  }

  GeofencesCompanion toCompanion(bool nullToAbsent) {
    return GeofencesCompanion(
      id: Value(id),
      geofenceId: Value(geofenceId),
      placeDescription: Value(placeDescription),
      latitude: Value(latitude),
      longitude: Value(longitude),
      radius: Value(radius),
    );
  }

  factory Geofence.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Geofence(
      id: serializer.fromJson<int>(json['id']),
      geofenceId: serializer.fromJson<String>(json['geofenceId']),
      placeDescription: serializer.fromJson<String>(json['placeDescription']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      radius: serializer.fromJson<double>(json['radius']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'geofenceId': serializer.toJson<String>(geofenceId),
      'placeDescription': serializer.toJson<String>(placeDescription),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'radius': serializer.toJson<double>(radius),
    };
  }

  Geofence copyWith({
    int? id,
    String? geofenceId,
    String? placeDescription,
    double? latitude,
    double? longitude,
    double? radius,
  }) => Geofence(
    id: id ?? this.id,
    geofenceId: geofenceId ?? this.geofenceId,
    placeDescription: placeDescription ?? this.placeDescription,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    radius: radius ?? this.radius,
  );
  Geofence copyWithCompanion(GeofencesCompanion data) {
    return Geofence(
      id: data.id.present ? data.id.value : this.id,
      geofenceId: data.geofenceId.present
          ? data.geofenceId.value
          : this.geofenceId,
      placeDescription: data.placeDescription.present
          ? data.placeDescription.value
          : this.placeDescription,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      radius: data.radius.present ? data.radius.value : this.radius,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Geofence(')
          ..write('id: $id, ')
          ..write('geofenceId: $geofenceId, ')
          ..write('placeDescription: $placeDescription, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('radius: $radius')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    geofenceId,
    placeDescription,
    latitude,
    longitude,
    radius,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Geofence &&
          other.id == this.id &&
          other.geofenceId == this.geofenceId &&
          other.placeDescription == this.placeDescription &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.radius == this.radius);
}

class GeofencesCompanion extends UpdateCompanion<Geofence> {
  final Value<int> id;
  final Value<String> geofenceId;
  final Value<String> placeDescription;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> radius;
  const GeofencesCompanion({
    this.id = const Value.absent(),
    this.geofenceId = const Value.absent(),
    this.placeDescription = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.radius = const Value.absent(),
  });
  GeofencesCompanion.insert({
    this.id = const Value.absent(),
    required String geofenceId,
    required String placeDescription,
    required double latitude,
    required double longitude,
    required double radius,
  }) : geofenceId = Value(geofenceId),
       placeDescription = Value(placeDescription),
       latitude = Value(latitude),
       longitude = Value(longitude),
       radius = Value(radius);
  static Insertable<Geofence> custom({
    Expression<int>? id,
    Expression<String>? geofenceId,
    Expression<String>? placeDescription,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? radius,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (geofenceId != null) 'geofence_id': geofenceId,
      if (placeDescription != null) 'place_description': placeDescription,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (radius != null) 'radius': radius,
    });
  }

  GeofencesCompanion copyWith({
    Value<int>? id,
    Value<String>? geofenceId,
    Value<String>? placeDescription,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<double>? radius,
  }) {
    return GeofencesCompanion(
      id: id ?? this.id,
      geofenceId: geofenceId ?? this.geofenceId,
      placeDescription: placeDescription ?? this.placeDescription,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
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
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (radius.present) {
      map['radius'] = Variable<double>(radius.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GeofencesCompanion(')
          ..write('id: $id, ')
          ..write('geofenceId: $geofenceId, ')
          ..write('placeDescription: $placeDescription, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('radius: $radius')
          ..write(')'))
        .toString();
  }
}

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
  late final GeneratedColumn<int> geofenceId = GeneratedColumn<int>(
    'geofence_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES geofences (id)',
    ),
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
  static const VerificationMeta _onetimeMeta = const VerificationMeta(
    'onetime',
  );
  @override
  late final GeneratedColumn<bool> onetime = GeneratedColumn<bool>(
    'onetime',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onetime" IN (0, 1))',
    ),
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
  late final GeneratedColumnWithTypeConverter<ReminderState, String> state =
      GeneratedColumn<String>(
        'state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ReminderState>($RemindersTable.$converterstate);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    geofenceId,
    placeDescription,
    onetime,
    title,
    note,
    state,
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
    if (data.containsKey('onetime')) {
      context.handle(
        _onetimeMeta,
        onetime.isAcceptableOrUnknown(data['onetime']!, _onetimeMeta),
      );
    } else if (isInserting) {
      context.missing(_onetimeMeta);
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
        DriftSqlType.int,
        data['${effectivePrefix}geofence_id'],
      )!,
      placeDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_description'],
      )!,
      onetime: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onetime'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      state: $RemindersTable.$converterstate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}state'],
        )!,
      ),
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ReminderState, String, String> $converterstate =
      const EnumNameConverter<ReminderState>(ReminderState.values);
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final int id;
  final int geofenceId;
  final String placeDescription;
  final bool onetime;
  final String title;
  final String note;
  final ReminderState state;
  const Reminder({
    required this.id,
    required this.geofenceId,
    required this.placeDescription,
    required this.onetime,
    required this.title,
    required this.note,
    required this.state,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['geofence_id'] = Variable<int>(geofenceId);
    map['place_description'] = Variable<String>(placeDescription);
    map['onetime'] = Variable<bool>(onetime);
    map['title'] = Variable<String>(title);
    map['note'] = Variable<String>(note);
    {
      map['state'] = Variable<String>(
        $RemindersTable.$converterstate.toSql(state),
      );
    }
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      geofenceId: Value(geofenceId),
      placeDescription: Value(placeDescription),
      onetime: Value(onetime),
      title: Value(title),
      note: Value(note),
      state: Value(state),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<int>(json['id']),
      geofenceId: serializer.fromJson<int>(json['geofenceId']),
      placeDescription: serializer.fromJson<String>(json['placeDescription']),
      onetime: serializer.fromJson<bool>(json['onetime']),
      title: serializer.fromJson<String>(json['title']),
      note: serializer.fromJson<String>(json['note']),
      state: $RemindersTable.$converterstate.fromJson(
        serializer.fromJson<String>(json['state']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'geofenceId': serializer.toJson<int>(geofenceId),
      'placeDescription': serializer.toJson<String>(placeDescription),
      'onetime': serializer.toJson<bool>(onetime),
      'title': serializer.toJson<String>(title),
      'note': serializer.toJson<String>(note),
      'state': serializer.toJson<String>(
        $RemindersTable.$converterstate.toJson(state),
      ),
    };
  }

  Reminder copyWith({
    int? id,
    int? geofenceId,
    String? placeDescription,
    bool? onetime,
    String? title,
    String? note,
    ReminderState? state,
  }) => Reminder(
    id: id ?? this.id,
    geofenceId: geofenceId ?? this.geofenceId,
    placeDescription: placeDescription ?? this.placeDescription,
    onetime: onetime ?? this.onetime,
    title: title ?? this.title,
    note: note ?? this.note,
    state: state ?? this.state,
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
      onetime: data.onetime.present ? data.onetime.value : this.onetime,
      title: data.title.present ? data.title.value : this.title,
      note: data.note.present ? data.note.value : this.note,
      state: data.state.present ? data.state.value : this.state,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('geofenceId: $geofenceId, ')
          ..write('placeDescription: $placeDescription, ')
          ..write('onetime: $onetime, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    geofenceId,
    placeDescription,
    onetime,
    title,
    note,
    state,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.geofenceId == this.geofenceId &&
          other.placeDescription == this.placeDescription &&
          other.onetime == this.onetime &&
          other.title == this.title &&
          other.note == this.note &&
          other.state == this.state);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<int> id;
  final Value<int> geofenceId;
  final Value<String> placeDescription;
  final Value<bool> onetime;
  final Value<String> title;
  final Value<String> note;
  final Value<ReminderState> state;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.geofenceId = const Value.absent(),
    this.placeDescription = const Value.absent(),
    this.onetime = const Value.absent(),
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.state = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required int geofenceId,
    required String placeDescription,
    required bool onetime,
    required String title,
    required String note,
    required ReminderState state,
  }) : geofenceId = Value(geofenceId),
       placeDescription = Value(placeDescription),
       onetime = Value(onetime),
       title = Value(title),
       note = Value(note),
       state = Value(state);
  static Insertable<Reminder> custom({
    Expression<int>? id,
    Expression<int>? geofenceId,
    Expression<String>? placeDescription,
    Expression<bool>? onetime,
    Expression<String>? title,
    Expression<String>? note,
    Expression<String>? state,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (geofenceId != null) 'geofence_id': geofenceId,
      if (placeDescription != null) 'place_description': placeDescription,
      if (onetime != null) 'onetime': onetime,
      if (title != null) 'title': title,
      if (note != null) 'note': note,
      if (state != null) 'state': state,
    });
  }

  RemindersCompanion copyWith({
    Value<int>? id,
    Value<int>? geofenceId,
    Value<String>? placeDescription,
    Value<bool>? onetime,
    Value<String>? title,
    Value<String>? note,
    Value<ReminderState>? state,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      geofenceId: geofenceId ?? this.geofenceId,
      placeDescription: placeDescription ?? this.placeDescription,
      onetime: onetime ?? this.onetime,
      title: title ?? this.title,
      note: note ?? this.note,
      state: state ?? this.state,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (geofenceId.present) {
      map['geofence_id'] = Variable<int>(geofenceId.value);
    }
    if (placeDescription.present) {
      map['place_description'] = Variable<String>(placeDescription.value);
    }
    if (onetime.present) {
      map['onetime'] = Variable<bool>(onetime.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(
        $RemindersTable.$converterstate.toSql(state.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('geofenceId: $geofenceId, ')
          ..write('placeDescription: $placeDescription, ')
          ..write('onetime: $onetime, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GeofencesTable geofences = $GeofencesTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [geofences, reminders];
}

typedef $$GeofencesTableCreateCompanionBuilder =
    GeofencesCompanion Function({
      Value<int> id,
      required String geofenceId,
      required String placeDescription,
      required double latitude,
      required double longitude,
      required double radius,
    });
typedef $$GeofencesTableUpdateCompanionBuilder =
    GeofencesCompanion Function({
      Value<int> id,
      Value<String> geofenceId,
      Value<String> placeDescription,
      Value<double> latitude,
      Value<double> longitude,
      Value<double> radius,
    });

final class $$GeofencesTableReferences
    extends BaseReferences<_$AppDatabase, $GeofencesTable, Geofence> {
  $$GeofencesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RemindersTable, List<Reminder>>
  _remindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminders,
    aliasName: 'geofences__id__reminders__geofence_id',
  );

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager(
      $_db,
      $_db.reminders,
    ).filter((f) => f.geofenceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GeofencesTableFilterComposer
    extends Composer<_$AppDatabase, $GeofencesTable> {
  $$GeofencesTableFilterComposer({
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

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get radius => $composableBuilder(
    column: $table.radius,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> remindersRefs(
    Expression<bool> Function($$RemindersTableFilterComposer f) f,
  ) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.geofenceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GeofencesTableOrderingComposer
    extends Composer<_$AppDatabase, $GeofencesTable> {
  $$GeofencesTableOrderingComposer({
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

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get radius => $composableBuilder(
    column: $table.radius,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GeofencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GeofencesTable> {
  $$GeofencesTableAnnotationComposer({
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

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get radius =>
      $composableBuilder(column: $table.radius, builder: (column) => column);

  Expression<T> remindersRefs<T extends Object>(
    Expression<T> Function($$RemindersTableAnnotationComposer a) f,
  ) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.geofenceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GeofencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GeofencesTable,
          Geofence,
          $$GeofencesTableFilterComposer,
          $$GeofencesTableOrderingComposer,
          $$GeofencesTableAnnotationComposer,
          $$GeofencesTableCreateCompanionBuilder,
          $$GeofencesTableUpdateCompanionBuilder,
          (Geofence, $$GeofencesTableReferences),
          Geofence,
          PrefetchHooks Function({bool remindersRefs})
        > {
  $$GeofencesTableTableManager(_$AppDatabase db, $GeofencesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GeofencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GeofencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GeofencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> geofenceId = const Value.absent(),
                Value<String> placeDescription = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double> radius = const Value.absent(),
              }) => GeofencesCompanion(
                id: id,
                geofenceId: geofenceId,
                placeDescription: placeDescription,
                latitude: latitude,
                longitude: longitude,
                radius: radius,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String geofenceId,
                required String placeDescription,
                required double latitude,
                required double longitude,
                required double radius,
              }) => GeofencesCompanion.insert(
                id: id,
                geofenceId: geofenceId,
                placeDescription: placeDescription,
                latitude: latitude,
                longitude: longitude,
                radius: radius,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GeofencesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({remindersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (remindersRefs) db.reminders],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (remindersRefs)
                    await $_getPrefetchedData<
                      Geofence,
                      $GeofencesTable,
                      Reminder
                    >(
                      currentTable: table,
                      referencedTable: $$GeofencesTableReferences
                          ._remindersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$GeofencesTableReferences(
                            db,
                            table,
                            p0,
                          ).remindersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.geofenceId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GeofencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GeofencesTable,
      Geofence,
      $$GeofencesTableFilterComposer,
      $$GeofencesTableOrderingComposer,
      $$GeofencesTableAnnotationComposer,
      $$GeofencesTableCreateCompanionBuilder,
      $$GeofencesTableUpdateCompanionBuilder,
      (Geofence, $$GeofencesTableReferences),
      Geofence,
      PrefetchHooks Function({bool remindersRefs})
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      required int geofenceId,
      required String placeDescription,
      required bool onetime,
      required String title,
      required String note,
      required ReminderState state,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      Value<int> geofenceId,
      Value<String> placeDescription,
      Value<bool> onetime,
      Value<String> title,
      Value<String> note,
      Value<ReminderState> state,
    });

final class $$RemindersTableReferences
    extends BaseReferences<_$AppDatabase, $RemindersTable, Reminder> {
  $$RemindersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GeofencesTable _geofenceIdTable(_$AppDatabase db) =>
      db.geofences.createAlias('reminders__geofence_id__geofences__id');

  $$GeofencesTableProcessedTableManager get geofenceId {
    final $_column = $_itemColumn<int>('geofence_id')!;

    final manager = $$GeofencesTableTableManager(
      $_db,
      $_db.geofences,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_geofenceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

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

  ColumnFilters<String> get placeDescription => $composableBuilder(
    column: $table.placeDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onetime => $composableBuilder(
    column: $table.onetime,
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

  ColumnWithTypeConverterFilters<ReminderState, ReminderState, String>
  get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$GeofencesTableFilterComposer get geofenceId {
    final $$GeofencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.geofenceId,
      referencedTable: $db.geofences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GeofencesTableFilterComposer(
            $db: $db,
            $table: $db.geofences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  ColumnOrderings<String> get placeDescription => $composableBuilder(
    column: $table.placeDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onetime => $composableBuilder(
    column: $table.onetime,
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

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  $$GeofencesTableOrderingComposer get geofenceId {
    final $$GeofencesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.geofenceId,
      referencedTable: $db.geofences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GeofencesTableOrderingComposer(
            $db: $db,
            $table: $db.geofences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  GeneratedColumn<String> get placeDescription => $composableBuilder(
    column: $table.placeDescription,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onetime =>
      $composableBuilder(column: $table.onetime, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ReminderState, String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  $$GeofencesTableAnnotationComposer get geofenceId {
    final $$GeofencesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.geofenceId,
      referencedTable: $db.geofences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GeofencesTableAnnotationComposer(
            $db: $db,
            $table: $db.geofences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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
          (Reminder, $$RemindersTableReferences),
          Reminder,
          PrefetchHooks Function({bool geofenceId})
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
                Value<int> geofenceId = const Value.absent(),
                Value<String> placeDescription = const Value.absent(),
                Value<bool> onetime = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<ReminderState> state = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                geofenceId: geofenceId,
                placeDescription: placeDescription,
                onetime: onetime,
                title: title,
                note: note,
                state: state,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int geofenceId,
                required String placeDescription,
                required bool onetime,
                required String title,
                required String note,
                required ReminderState state,
              }) => RemindersCompanion.insert(
                id: id,
                geofenceId: geofenceId,
                placeDescription: placeDescription,
                onetime: onetime,
                title: title,
                note: note,
                state: state,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RemindersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({geofenceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (geofenceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.geofenceId,
                                referencedTable: $$RemindersTableReferences
                                    ._geofenceIdTable(db),
                                referencedColumn: $$RemindersTableReferences
                                    ._geofenceIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
      (Reminder, $$RemindersTableReferences),
      Reminder,
      PrefetchHooks Function({bool geofenceId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GeofencesTableTableManager get geofences =>
      $$GeofencesTableTableManager(_db, _db.geofences);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
}
