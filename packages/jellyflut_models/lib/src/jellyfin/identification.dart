import 'dart:convert';

import 'package:flutter/foundation.dart';

class Identification {
  String? friendlyName;
  String? modelNumber;
  String? serialNumber;
  String? modelName;
  String? modelDescription;
  String? modelUrl;
  String? manufacturer;
  String? manufacturerUrl;
  List<dynamic>? headers;

  Identification({
    this.friendlyName,
    this.modelNumber,
    this.serialNumber,
    this.modelName,
    this.modelDescription,
    this.modelUrl,
    this.manufacturer,
    this.manufacturerUrl,
    this.headers,
  });

  Identification copyWith({
    String? friendlyName,
    String? modelNumber,
    String? serialNumber,
    String? modelName,
    String? modelDescription,
    String? modelUrl,
    String? manufacturer,
    String? manufacturerUrl,
    List<dynamic>? headers,
  }) {
    return Identification(
      friendlyName: friendlyName ?? this.friendlyName,
      modelNumber: modelNumber ?? this.modelNumber,
      serialNumber: serialNumber ?? this.serialNumber,
      modelName: modelName ?? this.modelName,
      modelDescription: modelDescription ?? this.modelDescription,
      modelUrl: modelUrl ?? this.modelUrl,
      manufacturer: manufacturer ?? this.manufacturer,
      manufacturerUrl: manufacturerUrl ?? this.manufacturerUrl,
      headers: headers ?? this.headers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'friendlyName': friendlyName,
      'modelNumber': modelNumber,
      'serialNumber': serialNumber,
      'modelName': modelName,
      'modelDescription': modelDescription,
      'modelUrl': modelUrl,
      'manufacturer': manufacturer,
      'manufacturerUrl': manufacturerUrl,
      'headers': headers,
    }..removeWhere((dynamic key, dynamic value) => key == null || value == null);
  }

  factory Identification.fromMap(Map<String, dynamic> map) {
    return Identification(
      friendlyName: map['friendlyName'],
      modelNumber: map['modelNumber'],
      serialNumber: map['serialNumber'],
      modelName: map['modelName'],
      modelDescription: map['modelDescription'],
      modelUrl: map['modelUrl'],
      manufacturer: map['manufacturer'],
      manufacturerUrl: map['manufacturerUrl'],
      headers: List<dynamic>.from(map['headers']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Identification.fromJson(String source) => Identification.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Identification(friendlyName: $friendlyName, modelNumber: $modelNumber, serialNumber: $serialNumber, modelName: $modelName, modelDescription: $modelDescription, modelUrl: $modelUrl, manufacturer: $manufacturer, manufacturerUrl: $manufacturerUrl, headers: $headers)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Identification &&
        other.friendlyName == friendlyName &&
        other.modelNumber == modelNumber &&
        other.serialNumber == serialNumber &&
        other.modelName == modelName &&
        other.modelDescription == modelDescription &&
        other.modelUrl == modelUrl &&
        other.manufacturer == manufacturer &&
        other.manufacturerUrl == manufacturerUrl &&
        listEquals(other.headers, headers);
  }

  @override
  int get hashCode {
    return friendlyName.hashCode ^
        modelNumber.hashCode ^
        serialNumber.hashCode ^
        modelName.hashCode ^
        modelDescription.hashCode ^
        modelUrl.hashCode ^
        manufacturer.hashCode ^
        manufacturerUrl.hashCode ^
        headers.hashCode;
  }
}
