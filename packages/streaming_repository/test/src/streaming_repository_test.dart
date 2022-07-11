// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:streaming_repository/streaming_repository.dart';

void main() {
  group('StreamingRepository', () {
    test('can be instantiated', () {
      expect(StreamingRepository(), isNotNull);
    });
  });
}
