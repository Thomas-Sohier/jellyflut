part of 'profile.dart';

PlayerProfile get vlcPhonePlayerProfile => PlayerProfile(
    name: PlayerProfileName.VLC_COMPUTER.value,
    deviceProfile: DeviceProfile(
        name: PlayerProfileName.VLC_COMPUTER.value,
        maxStreamingBitrate: 120000000,
        maxStaticBitrate: 100000000,
        musicStreamingTranscodingBitrate: 384000,
        transcodingProfiles: [
          TranscodingProfile(
              container: 'mkv',
              audioCodec: 'aac,mp3',
              videoCodec: 'h264',
              type: 'Video',
              context: 'Streaming',
              protocol: 'hls',
              breakOnNonKeyFrames: false),
          TranscodingProfile(
              container: 'aac', audioCodec: 'aac', type: 'Audio', context: 'Streaming', maxAudioChannels: '5'),
          TranscodingProfile(
              container: 'mp3', audioCodec: 'mp3', type: 'Audio', context: 'Streaming', maxAudioChannels: '5')
        ],
        codecProfiles: [],
        containerProfiles: [],
        directPlayProfiles: [
          DirectPlayProfile(
              container: 'm4v,3gp,ts,mpegts,mov,xvid,vob,mkv,wmv,asf,ogm,ogv,m2v,avi,mpg,mpeg,mp4,webm,wtv',
              audioCodec: 'aac,mp3,mp2,ac3,eac3,wma,wmav2,dca,dts,pcm,pcm_s16le,pcm_s24le,opus,flac,truehd',
              type: 'Video'),
          DirectPlayProfile(container: 'flac,aac,mp3,mpa,wav,wma,mp2,ogg,oga,webma,ape', type: 'Audio'),
          DirectPlayProfile(container: 'jpg,jpeg,png,gif,webp', type: 'Photo'),
        ],
        subtitleProfiles: [
          SubtitleProfile(format: 'dvdsub', method: 'External'),
          SubtitleProfile(format: 'srt', method: 'External'),
          SubtitleProfile(format: 'vtt', method: 'External'),
          SubtitleProfile(format: 'subrip', method: 'External'),
          SubtitleProfile(format: 'sub', method: 'External'),
          SubtitleProfile(format: 'smi', method: 'External'),
          SubtitleProfile(format: 'pgsub', method: 'External'),
          SubtitleProfile(format: 'pgs', method: 'External'),
          SubtitleProfile(format: 'idx', method: 'External'),
          SubtitleProfile(format: 'ass', method: 'External'),
          SubtitleProfile(format: 'ssa', method: 'External')
        ],
        responseProfiles: []));
