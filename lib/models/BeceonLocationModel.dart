import 'dart:convert';
import 'dart:math';

class LocationModel {
  LocationModel({
    required this.xCoordinate,
    required this.yCoordinate,
    required this.zCoordinate,
    this.distance,
  });

  final double xCoordinate;
  final double yCoordinate;
  final double zCoordinate;
  final double? distance;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        xCoordinate: json["longitude"],
        yCoordinate: json["latitude"],
        zCoordinate: json["altitude"],
        distance: json["distance"],
      );

  Map<String, dynamic> toJson() => {
        "longitude": xCoordinate,
        "latitude": yCoordinate,
        "altitude": zCoordinate,
      };

  static Map<String, LocationModel> beaconsCoordinates = {
    "DC:0D:30:0F:AC:34": LocationModel(
      xCoordinate: 10,
      yCoordinate: 300,
      zCoordinate: 74,
    ),
    "DC:0D:30:0F:AC:25": LocationModel(
      xCoordinate: 133.0,
      yCoordinate: 601.0,
      zCoordinate: 72,
    ),
    "DC:0D:30:0F:AB:8B": LocationModel(
      xCoordinate: 324.0,
      yCoordinate: 401.0,
      zCoordinate: 71,
    ),
    "DC:0D:30:0F:AB:97": LocationModel(
      xCoordinate: 451,
      yCoordinate: 601,
      zCoordinate: 73,
    ),
  };

  static List<LocationModel> testList = [
    LocationModel(
        xCoordinate: 1,
        yCoordinate: 2,
        zCoordinate: 2,
        distance: pow(11, 1/2).toDouble()
    ),
    LocationModel(
      xCoordinate: 3,
      yCoordinate: 4,
      zCoordinate: 2,
      distance: pow(11, 1/2).toDouble()
    ),
    LocationModel(
      xCoordinate: 4,
      yCoordinate: 1,
      zCoordinate: 1,
      distance: pow(24, 1/2).toDouble()
    ),
    LocationModel(
      xCoordinate: 1,
      yCoordinate: 4,
      zCoordinate: 3,
      distance: pow(6, 1/2).toDouble()
    ),
    LocationModel(
      xCoordinate: 2,
      yCoordinate: 2,
      zCoordinate: 4,
      distance: pow(2, 1/2).toDouble(),
    ),
  ];
}
