part of 'profile.dart';

PlayerProfile get webOsPlayerProfile => PlayerProfile(
    name: PlayerProfileName.WEB_OS.value,
    deviceProfile: DeviceProfile(
        name: PlayerProfileName.WEB_OS.value,
        maxStreamingBitrate: 120000000,
        maxStaticBitrate: 100000000,
        musicStreamingTranscodingBitrate: 384000,
        transcodingProfiles: [
          TranscodingProfile(
              container: 'ts',
              audioCodec: 'aac',
              type: 'Audio',
              context: 'Streaming',
              protocol: 'hls',
              maxAudioChannels: '2'),
          TranscodingProfile(
              container: 'aac',
              audioCodec: 'aac',
              type: 'Audio',
              context: 'Streaming',
              protocol: 'http',
              maxAudioChannels: '2'),
          TranscodingProfile(
              container: 'mp3',
              audioCodec: 'mp3',
              type: 'Audio',
              context: 'Streaming',
              protocol: 'http',
              maxAudioChannels: '2'),
          TranscodingProfile(
              container: 'opus',
              audioCodec: 'opus',
              type: 'Audio',
              context: 'Streaming',
              protocol: 'http',
              maxAudioChannels: '2'),
          TranscodingProfile(
              container: 'wav',
              audioCodec: 'wav',
              type: 'Audio',
              context: 'Streaming',
              protocol: 'http',
              maxAudioChannels: '2'),
          TranscodingProfile(
              container: 'opus',
              audioCodec: 'opus',
              type: 'Audio',
              context: 'Static',
              protocol: 'http',
              maxAudioChannels: '2'),
          TranscodingProfile(
              container: 'mp3',
              audioCodec: 'mp3',
              type: 'Audio',
              context: 'Static',
              protocol: 'http',
              maxAudioChannels: '2'),
          TranscodingProfile(
              container: 'aac',
              audioCodec: 'aac',
              type: 'Audio',
              context: 'Static',
              protocol: 'http',
              maxAudioChannels: '2'),
          TranscodingProfile(
              container: 'wav',
              audioCodec: 'wav',
              type: 'Audio',
              context: 'Static',
              protocol: 'http',
              maxAudioChannels: '2'),
          TranscodingProfile(
              container: 'webm',
              type: 'Video',
              audioCodec: 'mp3,ogg,aac',
              videoCodec: 'vp8,vp9,av1,h264',
              context: 'Streaming',
              protocol: 'http',
              maxAudioChannels: '2'),
          TranscodingProfile(
              container: 'mp4',
              audioCodec: 'aac,mp3,opus,flac,vorbis',
              videoCodec: 'h264',
              context: 'Static',
              protocol: 'http'),
          TranscodingProfile(
              container: 'webm',
              audioCodec: 'vorbis,opus',
              videoCodec: 'vp8,vp9,av1,vpx',
              context: 'Streaming',
              type: 'Video',
              protocol: 'http',
              maxAudioChannels: '2',
              breakOnNonKeyFrames: true),
          TranscodingProfile(
              container: 'ts',
              audioCodec: 'aac,mp3',
              videoCodec: 'h264',
              context: 'Streaming',
              protocol: 'hls',
              type: 'Video',
              maxAudioChannels: '2',
              breakOnNonKeyFrames: true)
        ],
        codecProfiles: [
          CodecProfile(type: 'VideoAudio', container: 'webm,mpeg,mp4', codec: 'aac,mp2,mp3,aac', conditions: []),
          CodecProfile(type: 'Video', codec: 'h264,hevc', conditions: []),
        ],
        containerProfiles: [],
        directPlayProfiles: [
          DirectPlayProfile(container: 'webm', type: 'Video', videoCodec: 'vp8,vp9,av1', audioCodec: 'vorbis,opus'),
          DirectPlayProfile(
              container: 'mp4,m4v',
              type: 'Video',
              videoCodec: 'h264,vp8,vp9,av1',
              audioCodec: 'aac,mp3,opus,flac,vorbis'),
          DirectPlayProfile(container: 'opus', type: 'Audio'),
          DirectPlayProfile(container: 'webm', audioCodec: 'opus', type: 'Audio'),
          DirectPlayProfile(container: 'mp3', type: 'Audio'),
          DirectPlayProfile(container: 'aac', type: 'Audio'),
          DirectPlayProfile(container: 'm4a', audioCodec: 'aac', type: 'Audio'),
          DirectPlayProfile(container: 'm4b', audioCodec: 'aac', type: 'Audio'),
          DirectPlayProfile(container: 'flac', type: 'Audio'),
          DirectPlayProfile(container: 'webma', type: 'Audio'),
          DirectPlayProfile(container: 'webm', audioCodec: 'webma', type: 'Audio'),
          DirectPlayProfile(container: 'wav', type: 'Audio'),
          DirectPlayProfile(container: 'ogg', type: 'Audio')
        ],
        subtitleProfiles: [
          SubtitleProfile(format: 'vtt', method: 'External')
        ],
        responseProfiles: [
          ResponseProfile(type: 'Video', container: 'm4v', mimeType: 'video/mp4')
        ]));
