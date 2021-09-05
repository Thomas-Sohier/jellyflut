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
  Server({required this.id, required this.url, required this.name});
  factory Server.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Server(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      url: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}url'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['url'] = Variable<String>(url);
    map['name'] = Variable<String>(name);
    return map;
  }

  ServersCompanion toCompanion(bool nullToAbsent) {
    return ServersCompanion(
      id: Value(id),
      url: Value(url),
      name: Value(name),
    );
  }

  factory Server.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Server(
      id: serializer.fromJson<int>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'url': serializer.toJson<String>(url),
      'name': serializer.toJson<String>(name),
    };
  }

  Server copyWith({int? id, String? url, String? name}) => Server(
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
  bool operator ==(Object other) =>
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
    required String url,
    required String name,
  })  : url = Value(url),
        name = Value(name);
  static Insertable<Server> custom({
    Expression<int>? id,
    Expression<String>? url,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (name != null) 'name': name,
    });
  }

  ServersCompanion copyWith(
      {Value<int>? id, Value<String>? url, Value<String>? name}) {
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
  final String? _alias;
  $ServersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _urlMeta = const VerificationMeta('url');
  late final GeneratedColumn<String?> url = GeneratedColumn<String?>(
      'url', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, url, name];
  @override
  String get aliasedName => _alias ?? 'servers';
  @override
  String get actualTableName => 'servers';
  @override
  VerificationContext validateIntegrity(Insertable<Server> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Server map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Server.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ServersTable createAlias(String alias) {
    return $ServersTable(_db, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String name;
  final String? password;
  final String apiKey;
  final int settingsId;
  final int serverId;
  User(
      {required this.id,
      required this.name,
      this.password,
      required this.apiKey,
      required this.settingsId,
      required this.serverId});
  factory User.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return User(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      password: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}password']),
      apiKey: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}api_key'])!,
      settingsId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}settings_id'])!,
      serverId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}server_id'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String?>(password);
    }
    map['api_key'] = Variable<String>(apiKey);
    map['settings_id'] = Variable<int>(settingsId);
    map['server_id'] = Variable<int>(serverId);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      apiKey: Value(apiKey),
      settingsId: Value(settingsId),
      serverId: Value(serverId),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      password: serializer.fromJson<String?>(json['password']),
      apiKey: serializer.fromJson<String>(json['apiKey']),
      settingsId: serializer.fromJson<int>(json['settingsId']),
      serverId: serializer.fromJson<int>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'password': serializer.toJson<String?>(password),
      'apiKey': serializer.toJson<String>(apiKey),
      'settingsId': serializer.toJson<int>(settingsId),
      'serverId': serializer.toJson<int>(serverId),
    };
  }

  User copyWith(
          {int? id,
          String? name,
          String? password,
          String? apiKey,
          int? settingsId,
          int? serverId}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        password: password ?? this.password,
        apiKey: apiKey ?? this.apiKey,
        settingsId: settingsId ?? this.settingsId,
        serverId: serverId ?? this.serverId,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('password: $password, ')
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
          $mrjc(
              password.hashCode,
              $mrjc(apiKey.hashCode,
                  $mrjc(settingsId.hashCode, serverId.hashCode))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.password == this.password &&
          other.apiKey == this.apiKey &&
          other.settingsId == this.settingsId &&
          other.serverId == this.serverId);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> password;
  final Value<String> apiKey;
  final Value<int> settingsId;
  final Value<int> serverId;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.password = const Value.absent(),
    this.apiKey = const Value.absent(),
    this.settingsId = const Value.absent(),
    this.serverId = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.password = const Value.absent(),
    required String apiKey,
    this.settingsId = const Value.absent(),
    this.serverId = const Value.absent(),
  })  : name = Value(name),
        apiKey = Value(apiKey);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String?>? password,
    Expression<String>? apiKey,
    Expression<int>? settingsId,
    Expression<int>? serverId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (password != null) 'password': password,
      if (apiKey != null) 'api_key': apiKey,
      if (settingsId != null) 'settings_id': settingsId,
      if (serverId != null) 'server_id': serverId,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? password,
      Value<String>? apiKey,
      Value<int>? settingsId,
      Value<int>? serverId}) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
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
    if (password.present) {
      map['password'] = Variable<String?>(password.value);
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
          ..write('password: $password, ')
          ..write('apiKey: $apiKey, ')
          ..write('settingsId: $settingsId, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  final GeneratedDatabase _db;
  final String? _alias;
  $UsersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _passwordMeta = const VerificationMeta('password');
  late final GeneratedColumn<String?> password = GeneratedColumn<String?>(
      'password', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _apiKeyMeta = const VerificationMeta('apiKey');
  late final GeneratedColumn<String?> apiKey = GeneratedColumn<String?>(
      'api_key', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _settingsIdMeta = const VerificationMeta('settingsId');
  late final GeneratedColumn<int?> settingsId = GeneratedColumn<int?>(
      'settings_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _serverIdMeta = const VerificationMeta('serverId');
  late final GeneratedColumn<int?> serverId = GeneratedColumn<int?>(
      'server_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, password, apiKey, settingsId, serverId];
  @override
  String get aliasedName => _alias ?? 'users';
  @override
  String get actualTableName => 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    }
    if (data.containsKey('api_key')) {
      context.handle(_apiKeyMeta,
          apiKey.isAcceptableOrUnknown(data['api_key']!, _apiKeyMeta));
    } else if (isInserting) {
      context.missing(_apiKeyMeta);
    }
    if (data.containsKey('settings_id')) {
      context.handle(
          _settingsIdMeta,
          settingsId.isAcceptableOrUnknown(
              data['settings_id']!, _settingsIdMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    return User.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
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
      {required this.id,
      required this.preferredPlayer,
      required this.preferredTranscodeAudioCodec,
      required this.maxVideoBitrate,
      required this.maxAudioBitrate});
  factory Setting.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Setting(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      preferredPlayer: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}preferred_player'])!,
      preferredTranscodeAudioCodec: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}preferred_transcode_audio_codec'])!,
      maxVideoBitrate: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}max_video_bitrate'])!,
      maxAudioBitrate: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}max_audio_bitrate'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['preferred_player'] = Variable<String>(preferredPlayer);
    map['preferred_transcode_audio_codec'] =
        Variable<String>(preferredTranscodeAudioCodec);
    map['max_video_bitrate'] = Variable<int>(maxVideoBitrate);
    map['max_audio_bitrate'] = Variable<int>(maxAudioBitrate);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      preferredPlayer: Value(preferredPlayer),
      preferredTranscodeAudioCodec: Value(preferredTranscodeAudioCodec),
      maxVideoBitrate: Value(maxVideoBitrate),
      maxAudioBitrate: Value(maxAudioBitrate),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
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
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
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
          {int? id,
          String? preferredPlayer,
          String? preferredTranscodeAudioCodec,
          int? maxVideoBitrate,
          int? maxAudioBitrate}) =>
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
  bool operator ==(Object other) =>
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
    Expression<int>? id,
    Expression<String>? preferredPlayer,
    Expression<String>? preferredTranscodeAudioCodec,
    Expression<int>? maxVideoBitrate,
    Expression<int>? maxAudioBitrate,
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
      {Value<int>? id,
      Value<String>? preferredPlayer,
      Value<String>? preferredTranscodeAudioCodec,
      Value<int>? maxVideoBitrate,
      Value<int>? maxAudioBitrate}) {
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
  final String? _alias;
  $SettingsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _preferredPlayerMeta =
      const VerificationMeta('preferredPlayer');
  late final GeneratedColumn<String?> preferredPlayer =
      GeneratedColumn<String?>('preferred_player', aliasedName, false,
          typeName: 'TEXT',
          requiredDuringInsert: false,
          defaultValue: const Constant('exoplayer'));
  final VerificationMeta _preferredTranscodeAudioCodecMeta =
      const VerificationMeta('preferredTranscodeAudioCodec');
  late final GeneratedColumn<String?> preferredTranscodeAudioCodec =
      GeneratedColumn<String?>(
          'preferred_transcode_audio_codec', aliasedName, false,
          typeName: 'TEXT',
          requiredDuringInsert: false,
          defaultValue: const Constant('auto'));
  final VerificationMeta _maxVideoBitrateMeta =
      const VerificationMeta('maxVideoBitrate');
  late final GeneratedColumn<int?> maxVideoBitrate = GeneratedColumn<int?>(
      'max_video_bitrate', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: const Constant(140000000));
  final VerificationMeta _maxAudioBitrateMeta =
      const VerificationMeta('maxAudioBitrate');
  late final GeneratedColumn<int?> maxAudioBitrate = GeneratedColumn<int?>(
      'max_audio_bitrate', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: const Constant(320000));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        preferredPlayer,
        preferredTranscodeAudioCodec,
        maxVideoBitrate,
        maxAudioBitrate
      ];
  @override
  String get aliasedName => _alias ?? 'settings';
  @override
  String get actualTableName => 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('preferred_player')) {
      context.handle(
          _preferredPlayerMeta,
          preferredPlayer.isAcceptableOrUnknown(
              data['preferred_player']!, _preferredPlayerMeta));
    }
    if (data.containsKey('preferred_transcode_audio_codec')) {
      context.handle(
          _preferredTranscodeAudioCodecMeta,
          preferredTranscodeAudioCodec.isAcceptableOrUnknown(
              data['preferred_transcode_audio_codec']!,
              _preferredTranscodeAudioCodecMeta));
    }
    if (data.containsKey('max_video_bitrate')) {
      context.handle(
          _maxVideoBitrateMeta,
          maxVideoBitrate.isAcceptableOrUnknown(
              data['max_video_bitrate']!, _maxVideoBitrateMeta));
    }
    if (data.containsKey('max_audio_bitrate')) {
      context.handle(
          _maxAudioBitrateMeta,
          maxAudioBitrate.isAcceptableOrUnknown(
              data['max_audio_bitrate']!, _maxAudioBitrateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Setting.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $ServersTable servers = $ServersTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final ServersDao serversDao = ServersDao(this as Database);
  late final UsersDao usersDao = UsersDao(this as Database);
  late final SettingsDao settingsDao = SettingsDao(this as Database);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [servers, users, settings];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$UsersDaoMixin on DatabaseAccessor<Database> {
  $UsersTable get users => attachedDatabase.users;
}
mixin _$SettingsDaoMixin on DatabaseAccessor<Database> {
  $SettingsTable get settings => attachedDatabase.settings;
}
mixin _$ServersDaoMixin on DatabaseAccessor<Database> {
  $ServersTable get servers => attachedDatabase.servers;
}
