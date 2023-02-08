import 'dart:convert';

import '../jellyfin/device_profile.dart';
import 'profiles/profile.dart';

class PlayersProfile {
  late final PlayerProfile webOs;
  late final PlayerProfile vlcComputer;
  late final PlayerProfile vlcPhone;

  PlayersProfile() {
    vlcComputer = vlcComputerPlayerProfile;
    vlcPhone = vlcPhonePlayerProfile;
    webOs = webOsPlayerProfile;
  }
}

class PlayerProfile {
  final String name;
  final DeviceProfile deviceProfile;

  const PlayerProfile({
    required this.name,
    required this.deviceProfile,
  });

  PlayerProfile copyWith({
    String? name,
    DeviceProfile? deviceProfile,
  }) {
    return PlayerProfile(
      name: name ?? this.name,
      deviceProfile: deviceProfile ?? this.deviceProfile,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'deviceProfile': deviceProfile.toMap(),
    };
  }

  factory PlayerProfile.fromMap(Map<String, dynamic> map) {
    return PlayerProfile(
      name: map['name'] ?? '',
      deviceProfile: DeviceProfile.fromMap(map['deviceProfile']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlayerProfile.fromJson(String source) => PlayerProfile.fromMap(json.decode(source));

  @override
  String toString() => 'PlayerProfile(name: $name, deviceProfile: $deviceProfile)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlayerProfile && other.name == name && other.deviceProfile == deviceProfile;
  }

  @override
  int get hashCode => name.hashCode ^ deviceProfile.hashCode;
}
