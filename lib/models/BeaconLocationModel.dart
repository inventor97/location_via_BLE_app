import 'dart:math';

import 'package:flutter/material.dart';

class BeaconLocationModel {
  BeaconLocationModel({
    required this.xCoordinate,
    required this.yCoordinate,
    required this.zCoordinate,
    this.distance,
    this.uuid,
    this.name,
    this.color,
    this.macAddress,
  });

  final String? name;
  final String? uuid;
  final String? macAddress;
  final double xCoordinate;
  final double yCoordinate;
  final double zCoordinate;
  final double? distance;
  Color? color;

  factory BeaconLocationModel.fromJson(Map<String, dynamic> json) => BeaconLocationModel(
        xCoordinate: json["longitude"],
        yCoordinate: json["latitude"],
        zCoordinate: json["altitude"],
        distance: json["distance"],
      );

  factory BeaconLocationModel.fromStorageJson(Map<String, dynamic> json) => BeaconLocationModel(
        name: json['name'],
        uuid: json['uuid'],
        xCoordinate: json["longitude"],
        yCoordinate: json["latitude"],
        zCoordinate: json["altitude"],
        distance: json["distance"],
        macAddress: json['mac_address'],
      );

  Map<String, dynamic> toStorageJson() => {
        "name": name,
        "uuid": uuid,
        "longitude": xCoordinate,
        "latitude": yCoordinate,
        "altitude": zCoordinate,
        "distance": distance,
        "mac_address": macAddress,
      };

  Map<String, dynamic> toJson() => {
        "longitude": xCoordinate,
        "latitude": yCoordinate,
        "altitude": zCoordinate,
      };

  static List<double> toDoubleArray(BeaconLocationModel beacon) {
    return [beacon.xCoordinate, beacon.yCoordinate, beacon.distance!];
  }

static Map<String, BeaconLocationModel> beaconsCoordinates = {
  "DC:0D:30:0F:AC:34": BeaconLocationModel(
    name: "GREEN",
    uuid: "edbddddd-dbde-dcfc-bfbc-dddddbffbcbd",
    xCoordinate: 15,
    yCoordinate: 331,
    zCoordinate: 78,
  ),
  "DC:0D:30:0F:AC:25": BeaconLocationModel(
    name: "YELLOW",
    uuid: "00000000-0000-0000-0000-000000000002",
    xCoordinate: 245,
    yCoordinate: 423,
    zCoordinate: 78,
  ),
  "DC:0D:30:0F:AB:8B": BeaconLocationModel(
    name: "ORANGE",
    uuid: "00000000-0000-0000-0000-000000000001",
    xCoordinate: 332,
    yCoordinate: 601,
    zCoordinate: 78,
  ),
  "DC:0D:30:0F:AB:97": BeaconLocationModel(
    name: "RED",
    uuid: "00000000-0000-0000-0000-000000000003",
    xCoordinate: 540,
    yCoordinate: 346,
    zCoordinate: 78,
  ),
};
}
