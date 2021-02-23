import 'codecProfile.dart';
import 'directPlayProfile.dart';
import 'responseProfile.dart';
import 'subtitleProfile.dart';
import 'transcodingProfile.dart';

class DeviceProfile {
  DeviceProfile({
    this.name,
    this.maxStreamingBitrate,
    this.maxStaticBitrate,
    this.musicStreamingTranscodingBitrate,
    this.directPlayProfiles,
    this.transcodingProfiles,
    this.containerProfiles,
    this.codecProfiles,
    this.subtitleProfiles,
    this.responseProfiles,
  });

  String name;
  int maxStreamingBitrate;
  int maxStaticBitrate;
  int musicStreamingTranscodingBitrate;
  List<DirectPlayProfile> directPlayProfiles;
  List<TranscodingProfile> transcodingProfiles;
  List<dynamic> containerProfiles;
  List<CodecProfile> codecProfiles;
  List<SubtitleProfile> subtitleProfiles;
  List<ResponseProfile> responseProfiles;

  factory DeviceProfile.fromMap(Map<String, dynamic> json) => DeviceProfile(
        name: json['Name'],
        maxStreamingBitrate: json['MaxStreamingBitrate'],
        maxStaticBitrate: json['MaxStaticBitrate'],
        musicStreamingTranscodingBitrate:
            json['MusicStreamingTranscodingBitrate'],
        directPlayProfiles: json['DirectPlayProfiles'] == null
            ? null
            : List<DirectPlayProfile>.from(json['DirectPlayProfiles']
                .map((x) => DirectPlayProfile.fromMap(x))),
        transcodingProfiles: json['TranscodingProfiles'] == null
            ? null
            : List<TranscodingProfile>.from(json['TranscodingProfiles']
                .map((x) => TranscodingProfile.fromMap(x))),
        containerProfiles: json['ContainerProfiles'] == null
            ? null
            : List<dynamic>.from(json['ContainerProfiles'].map((x) => x)),
        codecProfiles: json['CodecProfiles'] == null
            ? null
            : List<CodecProfile>.from(
                json['CodecProfiles'].map((x) => CodecProfile.fromMap(x))),
        subtitleProfiles: json['SubtitleProfiles'] == null
            ? null
            : List<SubtitleProfile>.from(json['SubtitleProfiles']
                .map((x) => SubtitleProfile.fromMap(x))),
        responseProfiles: json['ResponseProfiles'] == null
            ? null
            : List<ResponseProfile>.from(json['ResponseProfiles']
                .map((x) => ResponseProfile.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        if (name != null) 'Name': name,
        if (maxStreamingBitrate != null)
          'MaxStreamingBitrate': maxStreamingBitrate,
        if (maxStaticBitrate != null) 'MaxStaticBitrate': maxStaticBitrate,
        if (musicStreamingTranscodingBitrate != null)
          'MusicStreamingTranscodingBitrate': musicStreamingTranscodingBitrate,
        if (directPlayProfiles != null)
          'DirectPlayProfiles':
              List<dynamic>.from(directPlayProfiles.map((x) => x.toMap())),
        if (transcodingProfiles != null)
          'TranscodingProfiles':
              List<dynamic>.from(transcodingProfiles.map((x) => x.toMap())),
        if (containerProfiles != null)
          'ContainerProfiles':
              List<dynamic>.from(containerProfiles.map((x) => x)),
        if (codecProfiles != null)
          'CodecProfiles':
              List<dynamic>.from(codecProfiles.map((x) => x.toMap())),
        if (subtitleProfiles != null)
          'SubtitleProfiles':
              List<dynamic>.from(subtitleProfiles.map((x) => x.toMap())),
        if (responseProfiles != null)
          'ResponseProfiles': responseProfiles == null
              ? null
              : List<dynamic>.from(responseProfiles.map((x) => x.toMap())),
      };
}
