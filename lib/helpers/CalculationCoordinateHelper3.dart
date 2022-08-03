import 'dart:math';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:location_via_ble_app/models/BeceonLocationModel.dart';
import 'package:logger/logger.dart';
import 'package:vector_math/vector_math_64.dart';

class CalculationCoordinateHelper3 {
  //default values
  static double _x0 = 1.0;
  static double _y0 = 2.0;
  static double _z0 = 3.0;

  //error probability
  static const double errorRate = 0.000001;

  static List<List<double>> calculateLocation(List<Beacon> beacons) {
    List<List<double>> xyzCoordinates = [];
    List<LocationModel> beaconLocations = [];
    for (var e in beacons) {
      LocationModel location = LocationModel.beaconsCoordinates[e.macAddress]!;
      beaconLocations.add(
        LocationModel(
          xCoordinate: location.xCoordinate,
          yCoordinate: location.yCoordinate,
          zCoordinate: location.zCoordinate,
          distance: e.accuracy,
        ),
      );
    }
    for (int i = 0; i < beaconLocations.length; i++) {
      for (int j = i + 1; j < beaconLocations.length; j++) {
        for (int k = j + 1; k < beaconLocations.length; k++) {
          xyzCoordinates.add(_calculateCoordinates(beaconLocations[i], beaconLocations[j], beaconLocations[k]));
          Logger().i(xyzCoordinates);
        }
      }
    }

    return xyzCoordinates;
  }

  static List<double> _calculateCoordinates(LocationModel beacon1, LocationModel beacon2, LocationModel beacon3) {
    double xCoordinate = _x0;
    double yCoordinate = _y0;
    double zCoordinate = _z0;

    double probability = pow((pow((_x0 - xCoordinate), 2) + pow((_y0 - yCoordinate), 2) + pow((_z0 - zCoordinate), 2)), 1 / 2).toDouble();
    while (probability < errorRate) {
      xCoordinate = _x0;
      _x0 = xCoordinate - _deltaX(beacon1, beacon2, beacon3) / _delta(beacon1, beacon2, beacon3);
      yCoordinate = _y0;
      _y0 = yCoordinate - _deltaY(beacon1, beacon2, beacon3) / _delta(beacon1, beacon2, beacon3);
      zCoordinate = _z0;
      _z0 = zCoordinate - _deltaZ(beacon1, beacon2, beacon3) / _delta(beacon1, beacon2, beacon3);
      probability = pow((pow((_x0 - xCoordinate), 2) + pow((_y0 - yCoordinate), 2) + pow((_z0 - zCoordinate), 2)), 1 / 2).toDouble();
    }
    return [_x0, _y0, _z0];
  }

  static double _delta(LocationModel beacon1, LocationModel beacon2, LocationModel beacon3) {
    Matrix3 delta = Matrix3(
      2 * (_x0 - beacon1.xCoordinate),
      2 * (_y0 - beacon1.yCoordinate),
      2 * (_z0 - beacon1.zCoordinate),
      2 * (_x0 - beacon2.xCoordinate),
      2 * (_y0 - beacon2.yCoordinate),
      2 * (_z0 - beacon2.zCoordinate),
      2 * (_x0 - beacon3.xCoordinate),
      2 * (_y0 - beacon3.yCoordinate),
      2 * (_z0 - beacon3.zCoordinate),
    );
    return delta.determinant();
  }

  static double _deltaX(LocationModel beacon1, LocationModel beacon2, LocationModel beacon3) {
    Matrix3 deltaX = Matrix3(
      (pow((_x0 - beacon1.xCoordinate), 2) +
          pow((_y0 - beacon1.yCoordinate), 2) +
          pow((_z0 - beacon1.zCoordinate), 2) -
          pow((beacon1.distance ?? 0.0), 2))
          .toDouble(),
      2 * (_y0 - beacon1.yCoordinate),
      2 * (_z0 - beacon1.zCoordinate),
      (pow((_x0 - beacon2.xCoordinate), 2) +
          pow((_y0 - beacon2.yCoordinate), 2) +
          pow((_z0 - beacon2.zCoordinate), 2) -
          pow((beacon2.distance ?? 0.0), 2))
          .toDouble(),
      2 * (_y0 - beacon2.yCoordinate),
      2 * (_z0 - beacon2.zCoordinate),
      (pow((_x0 - beacon3.xCoordinate), 2) +
          pow((_y0 - beacon3.yCoordinate), 2) +
          pow((_z0 - beacon3.zCoordinate), 2) -
          pow((beacon3.distance ?? 0.0), 2))
          .toDouble(),
      2 * (_y0 - beacon3.yCoordinate),
      2 * (_z0 - beacon3.zCoordinate),
    );

    return deltaX.determinant();
  }

  static double _deltaY(LocationModel beacon1, LocationModel beacon2, LocationModel beacon3) {
    Matrix3 deltaY = Matrix3(
      2 * (_x0 - beacon1.xCoordinate),
      (pow((_x0 - beacon1.xCoordinate), 2) +
          pow((_y0 - beacon1.yCoordinate), 2) +
          pow((_z0 - beacon1.zCoordinate), 2) -
          pow((beacon1.distance ?? 0.0), 2))
          .toDouble(),
      2 * (_z0 - beacon1.zCoordinate),
      2 * (_x0 - beacon2.xCoordinate),
      (pow((_x0 - beacon2.xCoordinate), 2) +
          pow((_y0 - beacon2.yCoordinate), 2) +
          pow((_z0 - beacon2.zCoordinate), 2) -
          pow((beacon2.distance ?? 0.0), 2))
          .toDouble(),
      2 * (_z0 - beacon2.zCoordinate),
      2 * (_x0 - beacon3.xCoordinate),
      (pow((_x0 - beacon3.xCoordinate), 2) +
          pow((_y0 - beacon3.yCoordinate), 2) +
          pow((_z0 - beacon3.zCoordinate), 2) -
          pow((beacon3.distance ?? 0.0), 2))
          .toDouble(),
      2 * (_z0 - beacon3.zCoordinate),
    );
    return deltaY.determinant();
  }

  static double _deltaZ(LocationModel beacon1, LocationModel beacon2, LocationModel beacon3) {
    Matrix3 deltaZ = Matrix3(
      2 * (_x0 - beacon1.xCoordinate),
      2 * (_y0 - beacon1.yCoordinate),
      (pow((_x0 - beacon1.xCoordinate), 2) +
          pow((_y0 - beacon1.yCoordinate), 2) +
          pow((_z0 - beacon1.zCoordinate), 2) -
          pow((beacon1.distance ?? 0.0), 2))
          .toDouble(),
      2 * (_x0 - beacon2.xCoordinate),
      2 * (_y0 - beacon2.yCoordinate),
      (pow((_x0 - beacon2.xCoordinate), 2) +
          pow((_y0 - beacon2.yCoordinate), 2) +
          pow((_z0 - beacon2.zCoordinate), 2) -
          pow((beacon2.distance ?? 0.0), 2))
          .toDouble(),
      2 * (_x0 - beacon3.xCoordinate),
      2 * (_z0 - beacon3.zCoordinate),
      (pow((_x0 - beacon3.xCoordinate), 2) +
          pow((_y0 - beacon3.yCoordinate), 2) +
          pow((_z0 - beacon3.zCoordinate), 2) -
          pow((beacon3.distance ?? 0.0), 2))
          .toDouble(),
    );
    return deltaZ.determinant();
  }
}
