import 'dart:math';

import 'package:equations/equations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:location_via_ble_app/models/BeaconLocationModel.dart';
import 'package:logger/logger.dart';
import 'package:vector_math/vector_math_64.dart';

import 'GeneralHelper.dart';

class CustomMethod {
  final double pxMetersCoeffisent = 0.4706;
  static const platform = MethodChannel('BEACONS');

  static Future<Vector3> calculateLocation(List<Beacon> beacons, Beacon beacon) async {
    List<BeaconLocationModel> beaconLocations = GeneralHelper.getBeaconCoordinates(beacons);
    List<double> result = [];

    Logger().w(List.from(beaconLocations.map((e) => "${e.uuid} -> (${e.xCoordinate} : ${e.yCoordinate}) -> d:${e.distance}")));

    try {
      result = await platform.invokeMethod('BEACONS', {"coordinates": List.from(beaconLocations.map((e) => BeaconLocationModel.toDoubleArray(e)))});
    } on PlatformException catch (e) {
      Logger().e(e);
    }
    return calculateLeastNearing(Vector3(result[0], result[1], 0), beacon);
  }

  static Vector3 calculateLeastNearing(Vector3 location, Beacon beacon) {
    double solution = 0.0;
    BeaconLocationModel nearestBeacon = BeaconLocationModel(
        xCoordinate: BeaconLocationModel.beaconsCoordinates[beacon.macAddress]!.xCoordinate,
        yCoordinate: BeaconLocationModel.beaconsCoordinates[beacon.macAddress]!.yCoordinate,
        zCoordinate: 0,
        distance: beacon.accuracy);
    double alpha = atan(((location.y - nearestBeacon.yCoordinate).abs()) / (location.x - nearestBeacon.xCoordinate).abs());

    // if (nearestBeacon.distance! >= 1) {
    final equation =
    Quadratic.realEquation(a: (location.y - nearestBeacon.yCoordinate), b: (-1) * sin(alpha), c: (-1) * nearestBeacon.distance! * sin(alpha));

    for (final root in equation.solutions()) {
      if (root.real > 0) {
        solution = root.real;
      }
    }

    return Vector3(location.x - solution / sin(alpha), location.y - solution / sin(alpha), location.z);
    // } else {
    //   double x = (location.x - nearestBeacon.xCoordinate).abs()/cos(alpha) -
    //       nearestBeacon.distance!;
    //   //xLocation
    //   if (nearestBeacon.xCoordinate > location.x) {
    //     location.x += x * cos(alpha);
    //   } else {
    //     location.x -= x * cos(alpha);
    //   }
    //   //yLocation
    //   if (nearestBeacon.yCoordinate > location.y) {
    //     location.y += x * sin(alpha);
    //   } else {
    //     location.y -= x * sin(alpha);
    //   }
    //   return Vector3(location.x, location.y, location.z);
    // }
  }
}
