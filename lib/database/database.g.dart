// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Server extends DataClass implements Insertable<Server> {
  final int id;
  final String url;
  final String name;
  Server({@required this.id, @required this.url, @required this.name});
  factory Server.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Server(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      url: stringType.mapFromDatabaseResponse(data['${effectivePrefix}url']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    return map;
  }

  ServersCompanion toCompanion(bool nullToAbsent) {
    return ServersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory Server.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Server(
      id: serializer.fromJson<int>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'url': serializer.toJson<String>(url),
      'name': serializer.toJson<String>(name),
    };
  }

  Server copyWith({int id, String url, String name}) => Server(
        id: id ?? this.id,
        url: url ?? this.url,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Server(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(url.hashCode, name.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Server &&
          other.id == this.id &&
          other.url == this.url &&
          other.name == this.name);
}

class ServersCompanion extends UpdateCompanion<Server> {
  final Value<int> id;
  final Value<String> url;
  final Value<String> name;
  const ServersCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.name = const Value.absent(),
  });
  ServersCompanion.insert({
    this.id = const Value.absent(),
    @required String url,
    @required String name,
  })  : url = Value(url),
        name = Value(name);
  static Insertable<Server> custom({
    Expression<int> id,
    Expression<String> url,
    Expression<String> name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (name != null) 'name': name,
    });
  }

  ServersCompanion copyWith(
      {Value<int> id, Value<String> url, Value<String> name}) {
    return ServersCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServersCompanion(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ServersTable extends Servers with TableInfo<$ServersTable, Server> {
  final GeneratedDatabase _db;
  final String _alias;
  $ServersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _urlMeta = const VerificationMeta('url');
  GeneratedTextColumn _url;
  @override
  GeneratedTextColumn get url => _url ??= _constructUrl();
  GeneratedTextColumn _constructUrl() {
    return GeneratedTextColumn(
      'url',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, url, name];
  @override
  $ServersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'servers';
  @override
  final String actualTableName = 'servers';
  @override
  VerificationContext validateIntegrity(Insertable<Server> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url'], _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Server map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Server.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ServersTable createAlias(String alias) {
    return $ServersTable(_db, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String name;
  final String apiKey;
  final int settingsId;
  final int serverId;
  User(
      {@required this.id,
      @required this.name,
      @required this.apiKey,
      @required this.settingsId,
      @required this.serverId});
  factory User.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return User(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      apiKey:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}api_key']),
      settingsId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}settings_id']),
      serverId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}server_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || apiKey != null) {
      map['api_key'] = Variable<String>(apiKey);
    }
    if (!nullToAbsent || settingsId != null) {
      map['settings_id'] = Variable<int>(settingsId);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      apiKey:
          apiKey == null && nullToAbsent ? const Value.absent() : Value(apiKey),
      settingsId: settingsId == null && nullToAbsent
          ? const Value.absent()
          : Value(settingsId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      apiKey: serializer.fromJson<String>(json['apiKey']),
      settingsId: serializer.fromJson<int>(json['settingsId']),
      serverId: serializer.fromJson<int>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'apiKey': serializer.toJson<String>(apiKey),
      'settingsId': serializer.toJson<int>(settingsId),
      'serverId': serializer.toJson<int>(serverId),
    };
  }

  User copyWith(
          {int id, String name, String apiKey, int settingsId, int serverId}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        apiKey: apiKey ?? this.apiKey,
        settingsId: settingsId ?? this.settingsId,
        serverId: serverId ?? this.serverId,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('apiKey: $apiKey, ')
          ..write('settingsId: $settingsId, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(apiKey.hashCode,
              $mrjc(settingsId.hashCode, serverId.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.apiKey == this.apiKey &&
          other.settingsId == this.settingsId &&
          other.serverId == this.serverId);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> apiKey;
  final Value<int> settingsId;
  final Value<int> serverId;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.apiKey = const Value.absent(),
    this.settingsId = const Value.absent(),
    this.serverId = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required String apiKey,
    @required int settingsId,
    @required int serverId,
  })  : name = Value(name),
        apiKey = Value(apiKey),
        settingsId = Value(settingsId),
        serverId = Value(serverId);
  static Insertable<User> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<String> apiKey,
    Expression<int> settingsId,
    Expression<int> serverId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (apiKey != null) 'api_key': apiKey,
      if (settingsId != null) 'settings_id': settingsId,
      if (serverId != null) 'server_id': serverId,
    });
  }

  UsersCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<String> apiKey,
      Value<int> settingsId,
      Value<int> serverId}) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      apiKey: apiKey ?? this.apiKey,
      settingsId: settingsId ?? this.settingsId,
      serverId: serverId ?? this.serverId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (apiKey.present) {
      map['api_key'] = Variable<String>(apiKey.value);
    }
    if (settingsId.present) {
      map['settings_id'] = Variable<int>(settingsId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('apiKey: $apiKey, ')
          ..write('settingsId: $settingsId, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  final GeneratedDatabase _db;
  final String _alias;
  $UsersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _apiKeyMeta = const VerificationMeta('apiKey');
  GeneratedTextColumn _apiKey;
  @override
  GeneratedTextColumn get apiKey => _apiKey ??= _constructApiKey();
  GeneratedTextColumn _constructApiKey() {
    return GeneratedTextColumn(
      'api_key',
      $tableName,
      false,
    );
  }

  final VerificationMeta _settingsIdMeta = const VerificationMeta('settingsId');
  GeneratedIntColumn _settingsId;
  @override
  GeneratedIntColumn get settingsId => _settingsId ??= _constructSettingsId();
  GeneratedIntColumn _constructSettingsId() {
    return GeneratedIntColumn(
      'settings_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _serverIdMeta = const VerificationMeta('serverId');
  GeneratedIntColumn _serverId;
  @override
  GeneratedIntColumn get serverId => _serverId ??= _constructServerId();
  GeneratedIntColumn _constructServerId() {
    return GeneratedIntColumn(
      'server_id',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, name, apiKey, settingsId, serverId];
  @override
  $UsersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'users';
  @override
  final String actualTableName = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('api_key')) {
      context.handle(_apiKeyMeta,
          apiKey.isAcceptableOrUnknown(data['api_key'], _apiKeyMeta));
    } else if (isInserting) {
      context.missing(_apiKeyMeta);
    }
    if (data.containsKey('settings_id')) {
      context.handle(
          _settingsIdMeta,
          settingsId.isAcceptableOrUnknown(
              data['settings_id'], _settingsIdMeta));
    } else if (isInserting) {
      context.missing(_settingsIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id'], _serverIdMeta));
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return User.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(_db, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final String preferredPlayer;
  final String preferredTranscodeAudioCodec;
  final int maxVideoBitrate;
  final int maxAudioBitrate;
  Setting(
      {@required this.id,
      @required this.preferredPlayer,
      @required this.preferredTranscodeAudioCodec,
      @required this.maxVideoBitrate,
      @required this.maxAudioBitrate});
  factory Setting.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Setting(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      preferredPlayer: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}preferred_player']),
      preferredTranscodeAudioCodec: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}preferred_transcode_audio_codec']),
      maxVideoBitrate: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}max_video_bitrate']),
      maxAudioBitrate: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}max_audio_bitrate']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || preferredPlayer != null) {
      map['preferred_player'] = Variable<String>(preferredPlayer);
    }
    if (!nullToAbsent || preferredTranscodeAudioCodec != null) {
      map['preferred_transcode_audio_codec'] =
          Variable<String>(preferredTranscodeAudioCodec);
    }
    if (!nullToAbsent || maxVideoBitrate != null) {
      map['max_video_bitrate'] = Variable<int>(maxVideoBitrate);
    }
    if (!nullToAbsent || maxAudioBitrate != null) {
      map['max_audio_bitrate'] = Variable<int>(maxAudioBitrate);
    }
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      preferredPlayer: preferredPlayer == null && nullToAbsent
          ? const Value.absent()
          : Value(preferredPlayer),
      preferredTranscodeAudioCodec:
          preferredTranscodeAudioCodec == null && nullToAbsent
              ? const Value.absent()
              : Value(preferredTranscodeAudioCodec),
      maxVideoBitrate: maxVideoBitrate == null && nullToAbsent
          ? const Value.absent()
          : Value(maxVideoBitrate),
      maxAudioBitrate: maxAudioBitrate == null && nullToAbsent
          ? const Value.absent()
          : Value(maxAudioBitrate),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      preferredPlayer: serializer.fromJson<String>(json['preferredPlayer']),
      preferredTranscodeAudioCodec:
          serializer.fromJson<String>(json['preferredTranscodeAudioCodec']),
      maxVideoBitrate: serializer.fromJson<int>(json['maxVideoBitrate']),
      maxAudioBitrate: serializer.fromJson<int>(json['maxAudioBitrate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'preferredPlayer': serializer.toJson<String>(preferredPlayer),
      'preferredTranscodeAudioCodec':
          serializer.toJson<String>(preferredTranscodeAudioCodec),
      'maxVideoBitrate': serializer.toJson<int>(maxVideoBitrate),
      'maxAudioBitrate': serializer.toJson<int>(maxAudioBitrate),
    };
  }

  Setting copyWith(
          {int id,
          String preferredPlayer,
          String preferredTranscodeAudioCodec,
          int maxVideoBitrate,
          int maxAudioBitrate}) =>
      Setting(
        id: id ?? this.id,
        preferredPlayer: preferredPlayer ?? this.preferredPlayer,
        preferredTranscodeAudioCodec:
            preferredTranscodeAudioCodec ?? this.preferredTranscodeAudioCodec,
        maxVideoBitrate: maxVideoBitrate ?? this.maxVideoBitrate,
        maxAudioBitrate: maxAudioBitrate ?? this.maxAudioBitrate,
      );
  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('preferredPlayer: $preferredPlayer, ')
          ..write(
              'preferredTranscodeAudioCodec: $preferredTranscodeAudioCodec, ')
          ..write('maxVideoBitrate: $maxVideoBitrate, ')
          ..write('maxAudioBitrate: $maxAudioBitrate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          preferredPlayer.hashCode,
          $mrjc(preferredTranscodeAudioCodec.hashCode,
              $mrjc(maxVideoBitrate.hashCode, maxAudioBitrate.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.preferredPlayer == this.preferredPlayer &&
          other.preferredTranscodeAudioCodec ==
              this.preferredTranscodeAudioCodec &&
          other.maxVideoBitrate == this.maxVideoBitrate &&
          other.maxAudioBitrate == this.maxAudioBitrate);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<String> preferredPlayer;
  final Value<String> preferredTranscodeAudioCodec;
  final Value<int> maxVideoBitrate;
  final Value<int> maxAudioBitrate;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.preferredPlayer = const Value.absent(),
    this.preferredTranscodeAudioCodec = const Value.absent(),
    this.maxVideoBitrate = const Value.absent(),
    this.maxAudioBitrate = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.preferredPlayer = const Value.absent(),
    this.preferredTranscodeAudioCodec = const Value.absent(),
    this.maxVideoBitrate = const Value.absent(),
    this.maxAudioBitrate = const Value.absent(),
  });
  static Insertable<Setting> custom({
    Expression<int> id,
    Expression<String> preferredPlayer,
    Expression<String> preferredTranscodeAudioCodec,
    Expression<int> maxVideoBitrate,
    Expression<int> maxAudioBitrate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (preferredPlayer != null) 'preferred_player': preferredPlayer,
      if (preferredTranscodeAudioCodec != null)
        'preferred_transcode_audio_codec': preferredTranscodeAudioCodec,
      if (maxVideoBitrate != null) 'max_video_bitrate': maxVideoBitrate,
      if (maxAudioBitrate != null) 'max_audio_bitrate': maxAudioBitrate,
    });
  }

  SettingsCompanion copyWith(
      {Value<int> id,
      Value<String> preferredPlayer,
      Value<String> preferredTranscodeAudioCodec,
      Value<int> maxVideoBitrate,
      Value<int> maxAudioBitrate}) {
    return SettingsCompanion(
      id: id ?? this.id,
      preferredPlayer: preferredPlayer ?? this.preferredPlayer,
      preferredTranscodeAudioCodec:
          preferredTranscodeAudioCodec ?? this.preferredTranscodeAudioCodec,
      maxVideoBitrate: maxVideoBitrate ?? this.maxVideoBitrate,
      maxAudioBitrate: maxAudioBitrate ?? this.maxAudioBitrate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (preferredPlayer.present) {
      map['preferred_player'] = Variable<String>(preferredPlayer.value);
    }
    if (preferredTranscodeAudioCodec.present) {
      map['preferred_transcode_audio_codec'] =
          Variable<String>(preferredTranscodeAudioCodec.value);
    }
    if (maxVideoBitrate.present) {
      map['max_video_bitrate'] = Variable<int>(maxVideoBitrate.value);
    }
    if (maxAudioBitrate.present) {
      map['max_audio_bitrate'] = Variable<int>(maxAudioBitrate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('preferredPlayer: $preferredPlayer, ')
          ..write(
              'preferredTranscodeAudioCodec: $preferredTranscodeAudioCodec, ')
          ..write('maxVideoBitrate: $maxVideoBitrate, ')
          ..write('maxAudioBitrate: $maxAudioBitrate')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  final GeneratedDatabase _db;
  final String _alias;
  $SettingsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _preferredPlayerMeta =
      const VerificationMeta('preferredPlayer');
  GeneratedTextColumn _preferredPlayer;
  @override
  GeneratedTextColumn get preferredPlayer =>
      _preferredPlayer ??= _constructPreferredPlayer();
  GeneratedTextColumn _constructPreferredPlayer() {
    return GeneratedTextColumn('preferred_player', $tableName, false,
        defaultValue: const Constant('exoplayer'));
  }

  final VerificationMeta _preferredTranscodeAudioCodecMeta =
      const VerificationMeta('preferredTranscodeAudioCodec');
  GeneratedTextColumn _preferredTranscodeAudioCodec;
  @override
  GeneratedTextColumn get preferredTranscodeAudioCodec =>
      _preferredTranscodeAudioCodec ??=
          _constructPreferredTranscodeAudioCodec();
  GeneratedTextColumn _constructPreferredTranscodeAudioCodec() {
    return GeneratedTextColumn(
        'preferred_transcode_audio_codec', $tableName, false,
        defaultValue: const Constant('auto'));
  }

  final VerificationMeta _maxVideoBitrateMeta =
      const VerificationMeta('maxVideoBitrate');
  GeneratedIntColumn _maxVideoBitrate;
  @override
  GeneratedIntColumn get maxVideoBitrate =>
      _maxVideoBitrate ??= _constructMaxVideoBitrate();
  GeneratedIntColumn _constructMaxVideoBitrate() {
    return GeneratedIntColumn('max_video_bitrate', $tableName, false,
        defaultValue: const Constant(140000000));
  }

  final VerificationMeta _maxAudioBitrateMeta =
      const VerificationMeta('maxAudioBitrate');
  GeneratedIntColumn _maxAudioBitrate;
  @override
  GeneratedIntColumn get maxAudioBitrate =>
      _maxAudioBitrate ??= _constructMaxAudioBitrate();
  GeneratedIntColumn _constructMaxAudioBitrate() {
    return GeneratedIntColumn('max_audio_bitrate', $tableName, false,
        defaultValue: const Constant(320000));
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        preferredPlayer,
        preferredTranscodeAudioCodec,
        maxVideoBitrate,
        maxAudioBitrate
      ];
  @override
  $SettingsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'settings';
  @override
  final String actualTableName = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('preferred_player')) {
      context.handle(
          _preferredPlayerMeta,
          preferredPlayer.isAcceptableOrUnknown(
              data['preferred_player'], _preferredPlayerMeta));
    }
    if (data.containsKey('preferred_transcode_audio_codec')) {
      context.handle(
          _preferredTranscodeAudioCodecMeta,
          preferredTranscodeAudioCodec.isAcceptableOrUnknown(
              data['preferred_transcode_audio_codec'],
              _preferredTranscodeAudioCodecMeta));
    }
    if (data.containsKey('max_video_bitrate')) {
      context.handle(
          _maxVideoBitrateMeta,
          maxVideoBitrate.isAcceptableOrUnknown(
              data['max_video_bitrate'], _maxVideoBitrateMeta));
    }
    if (data.containsKey('max_audio_bitrate')) {
      context.handle(
          _maxAudioBitrateMeta,
          maxAudioBitrate.isAcceptableOrUnknown(
              data['max_audio_bitrate'], _maxAudioBitrateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Setting.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $ServersTable _servers;
  $ServersTable get servers => _servers ??= $ServersTable(this);
  $UsersTable _users;
  $UsersTable get users => _users ??= $UsersTable(this);
  $SettingsTable _settings;
  $SettingsTable get settings => _settings ??= $SettingsTable(this);
  ServersDao _serversDao;
  ServersDao get serversDao => _serversDao ??= ServersDao(this as Database);
  UsersDao _usersDao;
  UsersDao get usersDao => _usersDao ??= UsersDao(this as Database);
  SettingsDao _settingsDao;
  SettingsDao get settingsDao => _settingsDao ??= SettingsDao(this as Database);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [servers, users, settings];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$ServersDaoMixin on DatabaseAccessor<Database> {
  $ServersTable get servers => attachedDatabase.servers;
}
mixin _$UsersDaoMixin on DatabaseAccessor<Database> {
  $UsersTable get users => attachedDatabase.users;
}
mixin _$SettingsDaoMixin on DatabaseAccessor<Database> {
  $SettingsTable get settings => attachedDatabase.settings;
}
