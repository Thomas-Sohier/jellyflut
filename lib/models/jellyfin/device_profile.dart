import 'codec_profile.dart';
import 'direct_play_profile.dart';
import 'response_profile.dart';
import 'subtitle_profile.dart';
import 'transcoding_profile.dart';

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

  String? name;
  int? maxStreamingBitrate;
  int? maxStaticBitrate;
  int? musicStreamingTranscodingBitrate;
  List<DirectPlayProfile>? directPlayProfiles;
  List<TranscodingProfile>? transcodingProfiles;
  List<dynamic>? containerProfiles;
  List<CodecProfile>? codecProfiles;
  List<SubtitleProfile>? subtitleProfiles;
  List<ResponseProfile>? responseProfiles;

  factory DeviceProfile.fromMap(Map<String, dynamic> json) => DeviceProfile(
        name: json['Name'],
        maxStreamingBitrate: json['MaxStreamingBitrate'],
        maxStaticBitrate: json['MaxStaticBitrate'],
        musicStreamingTranscodingBitrate:
            json['MusicStreamingTranscodingBitrate'],
        directPlayProfiles: json['DirectPlayProfiles'] == null
            ? []
            : List<DirectPlayProfile>.from(json['DirectPlayProfiles']
                .map((x) => DirectPlayProfile.fromMap(x))),
        transcodingProfiles: json['TranscodingProfiles'] == null
            ? []
            : List<TranscodingProfile>.from(json['TranscodingProfiles']
                .map((x) => TranscodingProfile.fromMap(x))),
        containerProfiles: json['ContainerProfiles'] == null
            ? []
            : List<dynamic>.from(json['ContainerProfiles'].map((x) => x)),
        codecProfiles: json['CodecProfiles'] == null
            ? []
            : List<CodecProfile>.from(
                json['CodecProfiles'].map((x) => CodecProfile.fromMap(x))),
        subtitleProfiles: json['SubtitleProfiles'] == null
            ? []
            : List<SubtitleProfile>.from(json['SubtitleProfiles']
                .map((x) => SubtitleProfile.fromMap(x))),
        responseProfiles: json['ResponseProfiles'] == null
            ? []
            : List<ResponseProfile>.from(json['ResponseProfiles']
                .map((x) => ResponseProfile.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'Name': name,
        'MaxStreamingBitrate': maxStreamingBitrate,
        'MaxStaticBitrate': maxStaticBitrate,
        'MusicStreamingTranscodingBitrate': musicStreamingTranscodingBitrate,
        'DirectPlayProfiles': directPlayProfiles != null
            ? List<dynamic>.from(directPlayProfiles!.map((x) => x.toMap()))
            : [],
        'TranscodingProfiles': transcodingProfiles != null
            ? List<dynamic>.from(transcodingProfiles!.map((x) => x.toMap()))
            : [],
        'ContainerProfiles': containerProfiles != null
            ? List<dynamic>.from(containerProfiles!.map((x) => x))
            : [],
        'CodecProfiles': codecProfiles != null
            ? List<dynamic>.from(codecProfiles!.map((x) => x.toMap()))
            : [],
        'SubtitleProfiles': subtitleProfiles != null
            ? List<dynamic>.from(subtitleProfiles!.map((x) => x.toMap()))
            : [],
        'ResponseProfiles': responseProfiles != null
            ? List<dynamic>.from(responseProfiles!.map((x) => x.toMap()))
            : [],
      };
}
