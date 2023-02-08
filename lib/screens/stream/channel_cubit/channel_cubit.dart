import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:live_tv_repository/live_tv_repository.dart';
import 'package:streaming_api/streaming_api.dart';

part 'channel_state.dart';

class ChannelCubit extends Cubit<ChannelState> {
  ChannelCubit({required LiveTvRepository liveTvRepository})
      : _liveTvRepository = liveTvRepository,
        super(ChannelState());

  final LiveTvRepository _liveTvRepository;

  Future<void> init() async {
    emit(state.copyWith(status: Status.loading));
    try {
      final channels = await _liveTvRepository.getChannels();
      emit(state.copyWith(channels: channels, status: Status.success));
    } on StreamingException catch (e, _) {
      emit(state.copyWith(failureMessage: e.message, status: Status.failure));
    } on DioError catch (e, _) {
      emit(state.copyWith(failureMessage: e.message, status: Status.failure));
    } catch (e, s) {
      print(s);
      emit(state.copyWith(failureMessage: (e as dynamic)?.message.toString() ?? e.toString(), status: Status.failure));
    }
  }

  void toggleChannelsPanel() {
    emit(state.copyWith(showPanel: !state.showPanel));
  }
}
