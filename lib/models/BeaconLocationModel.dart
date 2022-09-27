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
  });

  final String? name;
  final String? uuid;
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
  );


  Map<String, dynamic> toStorageJson() => {
    "name" : name,
    "uuid" : uuid,
    "longitude": xCoordinate,
    "latitude": yCoordinate,
    "altitude": zCoordinate,
    "distance" : distance,
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
    // "D6:3A:3D:19:BE:DD": BeaconLocationModel(
    //   name: "NEW_1",
    //   uuid: "00000000-0000-0000-0000-000000000000",
    //   xCoordinate: 5,
    //   yCoordinate: 723,
    //   zCoordinate: 78,
    // ),
    // "CF:E1:37:E3:F9:BF": BeaconLocationModel(
    //   name: "NEW_2",
    //   uuid: "01020304-0506-0708-090A-0B0C0D0EOF11",
    //   xCoordinate: 421,
    //   yCoordinate: 738,
    //   zCoordinate: 78,
    // ),
    // "ED:90:C1:6E:7F:22": BeaconLocationModel(
    //   name: "NEW_3",
    //   uuid: "01020304-0506-0708-090A-0B0C0D0EOF09",
    //   xCoordinate: 421,
    //   yCoordinate: 434,
    //   zCoordinate: 78,
    // ),
  };

  static List<BeaconLocationModel> testList = [
    BeaconLocationModel(xCoordinate: 1, yCoordinate: 2, zCoordinate: 2, distance: pow(11, 1 / 2).toDouble()),
    BeaconLocationModel(xCoordinate: 3, yCoordinate: 4, zCoordinate: 2, distance: pow(11, 1 / 2).toDouble()),
    BeaconLocationModel(xCoordinate: 4, yCoordinate: 1, zCoordinate: 1, distance: pow(24, 1 / 2).toDouble()),
    BeaconLocationModel(xCoordinate: 1, yCoordinate: 4, zCoordinate: 3, distance: pow(6, 1 / 2).toDouble()),
    BeaconLocationModel(
      xCoordinate: 2,
      yCoordinate: 2,
      zCoordinate: 4,
      distance: pow(2, 1 / 2).toDouble(),
    ),
  ];

  static List<BeaconLocationModel> test2 = [
    BeaconLocationModel(
      xCoordinate: 4,
      yCoordinate: 4,
      zCoordinate: 1,
      distance: 3,
    ),
    BeaconLocationModel(
      xCoordinate: 6,
      yCoordinate: 11,
      zCoordinate: 1,
      distance: 5,
    ),
    BeaconLocationModel(
      xCoordinate: 10,
      yCoordinate: 14,
      zCoordinate: 1,
      distance: 7,
    ),
    BeaconLocationModel(
      xCoordinate: 13,
      yCoordinate: 9,
      zCoordinate: 1,
      distance: 6,
    ),
    BeaconLocationModel(
      xCoordinate: 14,
      yCoordinate: 5,
      zCoordinate: 1,
      distance: 6,
    ),
    BeaconLocationModel(
      xCoordinate: 10,
      yCoordinate: 2,
      zCoordinate: 1,
      distance: 3,
    ),
  ];
}
