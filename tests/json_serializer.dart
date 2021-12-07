import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:jellyflut/models/enum/person_type.dart';
import 'package:jellyflut/models/jellyfin/image_blur_hashes.dart';
import 'package:jellyflut/models/jellyfin/person.dart';
import 'package:jellyflut/shared/json_serializer.dart';

void main() {
  test('Person should be serialized', () {
    final jsonExpected = json.encode([
      {
        'Name': 'Daniel Craig',
        'Id': '7756ef19211166d2d5290b3eb1d354b9',
        'Role': 'James Bond',
        'Type': 'Actor',
        'PrimaryImageTag': 'dba3a1df8a3bb20ff538d8d3ce616d05',
        'ImageBlurHashes': {
          'Primary': {
            r'dba3a1df8a3bb20ff538d8d3ce616d05':
                r'dXEn@joe0zWX$%oLX9fl57bH-VoLT0ayjEjsM{aexaoe'
          }
        }
      }
    ]);

    final person = Person(
        id: 'dznfo844dv4e8r4v4ez64',
        name: 'Daniel Craig',
        role: 'James Bond',
        type: PersonType.ACTOR,
        primaryImageTag: 'dba3a1df8a3bb20ff538d8d3ce616d05',
        imageBlurHashes: ImageBlurHashes(
            art: null,
            backdrop: null,
            banner: null,
            logo: null,
            thumb: null,
            primary: {
              r'dba3a1df8a3bb20ff538d8d3ce616d05':
                  r'dXEn@joe0zWX$%oLX9fl57bH-VoLT0ayjEjsM{aexaoe'
            }));

    final personJson =
        json.encode(person, toEncodable: JsonSerializer.jellyfinSerializer);

    expect(personJson, jsonExpected);
  });
}
