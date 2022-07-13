import 'package:freezed_annotation/freezed_annotation.dart';

enum SubtitleMode {
  @JsonKey(name: 'default') // default is a protected keyword so we replace it by initial
  initial,
  always,
  onlyforced,
  none,
  smart
}
