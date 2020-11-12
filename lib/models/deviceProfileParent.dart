import 'dart:convert';

import 'deviceProfile.dart';

DeviceProfileParent deviceCodecsFromMap(String str) =>
    DeviceProfileParent.fromMap(json.decode(str));

String deviceCodecsToMap(DeviceProfileParent data) => json.encode(data.toMap());

class DeviceProfileParent {
  DeviceProfileParent({
    this.deviceProfile,
  });

  DeviceProfile deviceProfile;

  factory DeviceProfileParent.fromMap(Map<String, dynamic> json) =>
      DeviceProfileParent(
        deviceProfile: json["DeviceProfile"] == null
            ? null
            : DeviceProfile.fromMap(json["DeviceProfile"]),
      );

  Map<String, dynamic> toMap() => {
        "DeviceProfile": deviceProfile == null ? null : deviceProfile.toMap(),
      };
}
