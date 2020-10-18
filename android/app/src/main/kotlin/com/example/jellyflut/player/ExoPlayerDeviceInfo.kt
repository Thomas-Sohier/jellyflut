// package com.example.jellyflut.player

// fun getDeviceProfile() : String {

//     val bitrateSetting = "120000000";

//     val profile = object {
//                 val Name = "Android ExoPlayer"
//         val MaxStreamingBitrate = bitrateSetting
//         val MaxStaticBitrate = 100000000
//         val MusicStreamingTranscodingBitrate = 192000
//         val SubtitleProfiles = []
//         val DirectPlayProfiles = []
//         val CodecProfiles = []
//             }

//             var videoProfiles = {
//                 '3gp': ['h263', 'h264', 'mpeg4', 'hevc'],
//                 'mp4': ['h263', 'h264', 'mpeg4', 'hevc', 'mpeg2video', 'av1', 'mpeg1video'],
//                 'ts': ['h264', 'mpeg4'],
//                 'webm': ['vp8', 'vp9'],
//                 'mkv': ['h264', 'mpeg4', 'hevc', 'vp8', 'vp9', 'mpeg2video', 'mpeg1video'],
//                 'flv': ['h264', 'mpeg4'],
//                 'asf': ['mpeg2video', 'mpeg4', 'h263', 'h264', 'hevc', 'vp8', 'vp9', 'mpeg1video'],
//                 'm2ts': ['mp2g2video', 'mpeg4', 'h264', 'mpeg1video'],
//                 'vob': ['mpeg1video', 'mpeg2video'],
//                 'mov': ['mpeg1video', 'mpeg2video', 'mpeg4', 'h263', 'h264', 'hevc']
//             };

//             var audioProfiles = {
//                 '3gp': ['aac', '3gpp', 'flac'],
//                 'mp4': ['mp3', 'aac', 'mp1', 'mp2'],
//                 'ts': ['mp3', 'aac', 'mp1', 'mp2', 'ac3', 'dts'],
//                 'flac': ['flac'],
//                 'aac': ['aac'],
//                 'mkv': ['mp3', 'aac', 'dts', 'flac', 'vorbis', 'opus', 'ac3', 'wma', 'mp1', 'mp2'],
//                 'mp3': ['mp3'],
//                 'ogg': ['ogg', 'opus', 'vorbis'],
//                 'webm': ['vorbis', 'opus'],
//                 'flv': ['mp3', 'aac'],
//                 'asf': ['aac', 'ac3', 'dts', 'wma', 'flac', 'pcm'],
//                 'm2ts': ['aac', 'ac3', 'dts', 'pcm'],
//                 'vob': ['mp1'],
//                 'mov': ['mp3', 'aac', 'ac3', 'dts-hd', 'pcm']
//             };

//             var subtitleProfiles = ['ass', 'idx', 'pgs', 'pgssub', 'smi', 'srt', 'ssa', 'subrip'];

//             subtitleProfiles.forEach(function (format) {
//                 profile.SubtitleProfiles.push({
//                     Format: format,
//                     Method: 'Embed'
//                 });
//             });

//             var externalSubtitleProfiles = ['srt', 'sub', 'subrip', 'vtt'];

//             externalSubtitleProfiles.forEach(function (format) {
//                 profile.SubtitleProfiles.push({
//                     Format: format,
//                     Method: 'External'
//                 });
//             });

//             profile.SubtitleProfiles.push({
//                 Format: 'dvdsub',
//                 Method: 'Encode'
//             });

//             var codecs = JSON.parse(window.NativePlayer.getSupportedFormats());
//             var videoCodecs = [];
//             var audioCodecs = [];

//             for (var index in codecs.audioCodecs) {
//                 if (codecs.audioCodecs.hasOwnProperty(index)) {
//                     var audioCodec = codecs.audioCodecs[index];
//                     audioCodecs.push(audioCodec.codec);

//                     var profiles = audioCodec.profiles.join('|');
//                     var maxChannels = audioCodec.maxChannels;
//                     var maxSampleRate = audioCodec.maxSampleRate;

//                     var conditions = [{
//                         Condition: 'LessThanEqual',
//                         Property: 'AudioBitrate',
//                         Value: audioCodec.maxBitrate
//                     }];

//                     if (profiles) {
//                         conditions.push({
//                             Condition: 'EqualsAny',
//                             Property: 'AudioProfile',
//                             Value: profiles
//                         });
//                     }

//                     if (maxChannels) {
//                         conditions.push({
//                             Condition: 'LessThanEqual',
//                             Property: 'AudioChannels',
//                             Value: maxChannels
//                         });
//                     }

//                     if (maxSampleRate) {
//                         conditions.push({
//                             Condition: 'LessThanEqual',
//                             Property: 'AudioSampleRate',
//                             Value: maxSampleRate
//                         });
//                     }

//                     profile.CodecProfiles.push({
//                         Type: 'Audio',
//                         Codec: audioCodec.codec,
//                         Conditions: conditions
//                     });
//                 }
//             }

//             for (var index in codecs.videoCodecs) {
//                 if (codecs.videoCodecs.hasOwnProperty(index)) {
//                     var videoCodec = codecs.videoCodecs[index];
//                     videoCodecs.push(videoCodec.codec);

//                     var profiles = videoCodec.profiles.join('|');
//                     var maxLevel = videoCodec.levels.length && Math.max.apply(null, videoCodec.levels);
//                     var conditions = [{
//                         Condition: 'LessThanEqual',
//                         Property: 'VideoBitrate',
//                         Value: videoCodec.maxBitrate
//                     }];

//                     if (profiles) {
//                         conditions.push({
//                             Condition: 'EqualsAny',
//                             Property: 'VideoProfile',
//                             Value: profiles
//                         });
//                     }

//                     if (maxLevel) {
//                         conditions.push({
//                             Condition: 'LessThanEqual',
//                             Property: 'VideoLevel',
//                             Value: maxLevel
//                         });
//                     }

//                     if (conditions.length) {
//                         profile.CodecProfiles.push({
//                             Type: 'Video',
//                             Codec: videoCodec.codec,
//                             Conditions: conditions
//                         });
//                     }
//                 }
//             }

//             for (var container in videoProfiles) {
//                 if (videoProfiles.hasOwnProperty(container)) {
//                     profile.DirectPlayProfiles.push({
//                         Container: container,
//                         Type: 'Video',
//                         VideoCodec: videoProfiles[container].filter(function (codec) {
//                         return videoCodecs.indexOf(codec) !== -1;
//                     }).join(','),
//                         AudioCodec: audioProfiles[container].filter(function (codec) {
//                         return audioCodecs.indexOf(codec) !== -1;
//                     }).join(',')
//                     });
//                 }
//             }

//             for (var container in audioProfiles) {
//                 if (audioProfiles.hasOwnProperty(container)) {
//                     profile.DirectPlayProfiles.push({
//                         Container: container,
//                         Type: 'Audio',
//                         AudioCodec: audioProfiles[container].filter(function (codec) {
//                         return audioCodecs.indexOf(codec) !== -1;
//                     }).join(',')
//                     });
//                 }
//             }

//             profile.TranscodingProfiles = [
//                 {
//                     Container: 'ts',
//                     Type: 'Video',
//                     AudioCodec: audioProfiles['ts'].filter(function (codec) {
//                     return audioCodecs.indexOf(codec) !== -1;
//                 }).join(','),
//                     VideoCodec: 'h264',
//                     Context: 'Streaming',
//                     Protocol: 'hls',
//                     MinSegments: 1
//                 },
//                 {
//                     Container: 'mkv',
//                     Type: 'Video',
//                     AudioCodec: audioProfiles['mkv'].filter(function (codec) {
//                     return audioCodecs.indexOf(codec) !== -1;
//                 }).join(','),
//                     VideoCodec: 'h264',
//                     Context: 'Streaming'
//                 },
//                 {
//                     Container: 'mp3',
//                     Type: 'Audio',
//                     AudioCodec: 'mp3',
//                     Context: 'Streaming',
//                     Protocol: 'http'
//                 },

//             ];

//             self.cachedDeviceProfile = profile;

//             resolve(profile);
//         };