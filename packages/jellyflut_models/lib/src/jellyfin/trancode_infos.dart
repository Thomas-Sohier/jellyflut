// To parse this JSON data, do
//
//     final transcodeInfos = transcodeInfosFromMap(jsonString);

import 'dart:convert';

import 'device_profile.dart';

TranscodeInfos transcodeInfosFromMap(String str) => TranscodeInfos.fromMap(json.decode(str));

String transcodeInfosToMap(TranscodeInfos data) => json.encode(data.toMap());

class TranscodeInfos {
  TranscodeInfos({
    required this.deviceProfile,
  });

  DeviceProfile deviceProfile;

  factory TranscodeInfos.fromMap(Map<String, dynamic> json) => TranscodeInfos(
        deviceProfile: DeviceProfile.fromMap(json['DeviceProfile']),
      );

  Map<String, dynamic> toMap() => {
        'DeviceProfile': deviceProfile.toMap(),
      };
}
