import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:jellyflut/database/database.dart';

class ServersWithUsersDao {
  ServersWithUsersDao({required this.server, required this.user});

  final Server server;
  final User user;
}

class ServersWithUsers {
  ServersWithUsers({
    required this.server,
    required this.users,
  });

  final Server server;
  final List<User> users;

  ServersWithUsers copyWith({
    Server? server,
    List<User>? users,
  }) {
    return ServersWithUsers(
      server: server ?? this.server,
      users: users ?? this.users,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'server': server.toJson(),
      'users': users.map((x) => x.toJson()).toList(),
    };
  }

  factory ServersWithUsers.fromMap(Map<String, dynamic> map) {
    return ServersWithUsers(
      server: Server.fromJson(map['server']),
      users: List<User>.from(map['users']?.map((x) => User.fromJson(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ServersWithUsers.fromJson(String source) =>
      ServersWithUsers.fromMap(json.decode(source));

  @override
  String toString() => 'ServersWithUsers(server: $server, users: $users)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServersWithUsers &&
        other.server == server &&
        listEquals(other.users, users);
  }

  @override
  int get hashCode => server.hashCode ^ users.hashCode;
}
