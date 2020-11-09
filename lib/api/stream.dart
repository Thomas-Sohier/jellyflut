import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/streamModel.dart';

import '../globals.dart';
import 'items.dart';

BaseOptions options = BaseOptions(
  connectTimeout: 60000,
  receiveTimeout: 60000,
  contentType: 'JSON',
);
const platform = MethodChannel('com.example.jellyflut/videoPlayer');

Dio dio = Dio(options);

String createURL(Item item, {int startTick = 0}) {
  var codecs = item.container.split(',');
  return '${server.url}/Videos/${item.id}/stream.${codecs.first}?startTimeTicks=${startTick}';
}

Future<String> getItemURL(Item item) {
  if (item.type == 'Episode' || item.type == 'Movie') {
    StreamModel().setItem(item);
    return getStreamURL(item: item);
  }
  return getFirstUnplayedItemURL(item);
}

Future<String> getFirstUnplayedItemURL(Item item) async {
  var category =
      await getItems(item.id, filter: 'IsNotFolder', fields: 'MediaStreams');
  category.items.removeWhere((element) => element.indexNumber == null);
  category.items.sort((a, b) => a.indexNumber.compareTo(b.indexNumber));
  var itemToPlay = category.items.firstWhere(
      (element) => !element.userData.played,
      orElse: () => category.items.first);
  StreamModel().setItem(itemToPlay);
  return getStreamURL(item: itemToPlay);
}

Future<String> getStreamURL({Item item}) async {
  var data = await isCodecSupported(item, platform);
  var backInfos = await playbackInfos(data, item.id,
      startTimeTick: item.userData.playbackPositionTicks);
  var completeTranscodeUrl;
  if (backInfos.mediaSources.first.transcodingUrl != null) {
    completeTranscodeUrl =
        '${server.url}${backInfos.mediaSources.first.transcodingUrl}';
  }
  return completeTranscodeUrl ?? createURL(item, startTick: item.runTimeTicks);
}

Future<String> isCodecSupported(Item item, MethodChannel platform) async {
  var result;
  // TODO finish this method to know if video can be direct play
  if (Platform.isAndroid) {
    result = await platform.invokeMethod('getListOfCodec');
  } else if (Platform.isIOS) {
    // TODO make IOS
    result = '';
  }
  return _playbackInfos;
}

// TODO remove when function done
// Used meanwhile a correct implementation of device capabilities
String _playbackInfos =
    '{"DeviceProfile":{"MaxStreamingBitrate":120000000,"MaxStaticBitrate":100000000,"MusicStreamingTranscodingBitrate":192000,"DirectPlayProfiles":[{"Container":"webm","Type":"Video","VideoCodec":"vp8,vp9,av1","AudioCodec":"vorbis,opus"},{"Container":"mp4,m4v","Type":"Video","VideoCodec":"h264,vp8,vp9,av1","AudioCodec":"mp3,aac,opus,flac,vorbis"},{"Container":"opus","Type":"Audio"},{"Container":"mp3","Type":"Audio","AudioCodec":"mp3"},{"Container":"aac","Type":"Audio"},{"Container":"m4a,m4b","AudioCodec":"aac","Type":"Audio"},{"Container":"flac","Type":"Audio"},{"Container":"webma,webm","Type":"Audio"},{"Container":"wav","Type":"Audio"},{"Container":"ogg","Type":"Audio"}],"TranscodingProfiles":[{"Container":"ts","Type":"Audio","AudioCodec":"aac","Context":"Streaming","Protocol":"hls","MaxAudioChannels":"2","MinSegments":"1","BreakOnNonKeyFrames":true},{"Container":"aac","Type":"Audio","AudioCodec":"aac","Context":"Streaming","Protocol":"http","MaxAudioChannels":"2"},{"Container":"mp3","Type":"Audio","AudioCodec":"mp3","Context":"Streaming","Protocol":"http","MaxAudioChannels":"2"},{"Container":"opus","Type":"Audio","AudioCodec":"opus","Context":"Streaming","Protocol":"http","MaxAudioChannels":"2"},{"Container":"wav","Type":"Audio","AudioCodec":"wav","Context":"Streaming","Protocol":"http","MaxAudioChannels":"2"},{"Container":"opus","Type":"Audio","AudioCodec":"opus","Context":"Static","Protocol":"http","MaxAudioChannels":"2"},{"Container":"mp3","Type":"Audio","AudioCodec":"mp3","Context":"Static","Protocol":"http","MaxAudioChannels":"2"},{"Container":"aac","Type":"Audio","AudioCodec":"aac","Context":"Static","Protocol":"http","MaxAudioChannels":"2"},{"Container":"wav","Type":"Audio","AudioCodec":"wav","Context":"Static","Protocol":"http","MaxAudioChannels":"2"},{"Container":"ts","Type":"Video","AudioCodec":"mp3,aac","VideoCodec":"h264","Context":"Streaming","Protocol":"hls","MaxAudioChannels":"2","MinSegments":"1","BreakOnNonKeyFrames":true},{"Container":"webm","Type":"Video","AudioCodec":"vorbis","VideoCodec":"vpx","Context":"Streaming","Protocol":"http","MaxAudioChannels":"2"},{"Container":"mp4","Type":"Video","AudioCodec":"mp3,aac,opus,flac,vorbis","VideoCodec":"h264","Context":"Static","Protocol":"http"}],"ContainerProfiles":[],"CodecProfiles":[{"Type":"VideoAudio","Codec":"aac","Conditions":[{"Condition":"Equals","Property":"IsSecondaryAudio","Value":"false","IsRequired":false}]},{"Type":"VideoAudio","Conditions":[{"Condition":"Equals","Property":"IsSecondaryAudio","Value":"false","IsRequired":false}]},{"Type":"Video","Codec":"h264","Conditions":[{"Condition":"NotEquals","Property":"IsAnamorphic","Value":"true","IsRequired":false},{"Condition":"EqualsAny","Property":"VideoProfile","Value":"high|main|baseline|constrained baseline","IsRequired":false},{"Condition":"LessThanEqual","Property":"VideoLevel","Value":"51","IsRequired":false},{"Condition":"NotEquals","Property":"IsInterlaced","Value":"true","IsRequired":false}]}],"SubtitleProfiles":[{"Format":"vtt","Method":"External"},{"Format":"ass","Method":"External"},{"Format":"ssa","Method":"External"}],"ResponseProfiles":[{"Type":"Video","Container":"m4v","MimeType":"video/mp4"}]}}';
