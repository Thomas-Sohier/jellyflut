import 'codecProfile.dart';
import 'directPlayProfile.dart';
import 'responseProfile.dart';
import 'subtitleProfile.dart';
import 'transcodingProfile.dart';

class DeviceProfile {
  DeviceProfile({
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
        maxStreamingBitrate: json["MaxStreamingBitrate"] == null
            ? null
            : json["MaxStreamingBitrate"],
        maxStaticBitrate:
            json["MaxStaticBitrate"] == null ? null : json["MaxStaticBitrate"],
        musicStreamingTranscodingBitrate:
            json["MusicStreamingTranscodingBitrate"] == null
                ? null
                : json["MusicStreamingTranscodingBitrate"],
        directPlayProfiles: json["DirectPlayProfiles"] == null
            ? null
            : List<DirectPlayProfile>.from(json["DirectPlayProfiles"]
                .map((x) => DirectPlayProfile.fromMap(x))),
        transcodingProfiles: json["TranscodingProfiles"] == null
            ? null
            : List<TranscodingProfile>.from(json["TranscodingProfiles"]
                .map((x) => TranscodingProfile.fromMap(x))),
        containerProfiles: json["ContainerProfiles"] == null
            ? null
            : List<dynamic>.from(json["ContainerProfiles"].map((x) => x)),
        codecProfiles: json["CodecProfiles"] == null
            ? null
            : List<CodecProfile>.from(
                json["CodecProfiles"].map((x) => CodecProfile.fromMap(x))),
        subtitleProfiles: json["SubtitleProfiles"] == null
            ? null
            : List<SubtitleProfile>.from(json["SubtitleProfiles"]
                .map((x) => SubtitleProfile.fromMap(x))),
        responseProfiles: json["ResponseProfiles"] == null
            ? null
            : List<ResponseProfile>.from(json["ResponseProfiles"]
                .map((x) => ResponseProfile.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "MaxStreamingBitrate":
            maxStreamingBitrate == null ? null : maxStreamingBitrate,
        "MaxStaticBitrate": maxStaticBitrate == null ? null : maxStaticBitrate,
        "MusicStreamingTranscodingBitrate":
            musicStreamingTranscodingBitrate == null
                ? null
                : musicStreamingTranscodingBitrate,
        "DirectPlayProfiles": directPlayProfiles == null
            ? null
            : List<dynamic>.from(directPlayProfiles.map((x) => x.toMap())),
        "TranscodingProfiles": transcodingProfiles == null
            ? null
            : List<dynamic>.from(transcodingProfiles.map((x) => x.toMap())),
        "ContainerProfiles": containerProfiles == null
            ? null
            : List<dynamic>.from(containerProfiles.map((x) => x)),
        "CodecProfiles": codecProfiles == null
            ? null
            : List<dynamic>.from(codecProfiles.map((x) => x.toMap())),
        "SubtitleProfiles": subtitleProfiles == null
            ? null
            : List<dynamic>.from(subtitleProfiles.map((x) => x.toMap())),
        "ResponseProfiles": responseProfiles == null
            ? null
            : List<dynamic>.from(responseProfiles.map((x) => x.toMap())),
      };
}
