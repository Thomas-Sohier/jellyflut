import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:live_tv_repository/live_tv_repository.dart';

part 'live_tv_guide_state.dart';

class LiveTvGuideCubit extends Cubit<LiveTvGuideState> {
  LiveTvGuideCubit({required LiveTvRepository liveTvRepository})
      : _liveTvRepository = liveTvRepository,
        super(const LiveTvGuideState()) {
    loadLiveTvGuide();
  }

  final LiveTvRepository _liveTvRepository;

  void loadLiveTvGuide() async {
    emit(state.copyWith(status: LiveTvGuideStatus.loading));
    try {
      final guide = await _liveTvRepository.getGuide(startIndex: state.guide.length, limit: state.limit);
      emit(state.copyWith(guide: [...state.guide, ...guide], status: LiveTvGuideStatus.success));
    } catch (_) {
      emit(state.copyWith(status: LiveTvGuideStatus.failure));
    }
  }
}
