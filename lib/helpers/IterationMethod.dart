import 'dart:math';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:location_via_ble_app/helpers/GeneralHelper.dart';
import 'package:location_via_ble_app/models/BeaconLocationModel.dart';
import 'package:logger/logger.dart';
import 'package:vector_math/vector_math_64.dart';

class IterationMethod {
  //default values
  static double _x0 = 1.0;
  static double _y0 = 2.0;
  static double _z0 = 3.0;

  //error probability
  static const double errorRate = 1E-9;

  static Vector3 calculateLocation(List<Beacon> beacons) {
    List<BeaconLocationModel> beaconLocations = GeneralHelper.getBeaconCoordinates(beacons);
    return calculate(beaconLocations);
  }

  static Vector3 calculate(List<BeaconLocationModel> beaconLocations) {
    List<Vector3> xyzCoordinates = [];
    for (int i = 0; i < beaconLocations.length; i++) {
      for (int j = i + 1; j < beaconLocations.length; j++) {
        for (int k = j + 1; k < beaconLocations.length; k++) {
          Vector3 coordinate = _calculateCoordinates(beaconLocations[i], beaconLocations[j], beaconLocations[k]);
          Logger().w(coordinate);
          if (coordinate.x > 0 && coordinate.y > 0 && coordinate.z > 0) {
            xyzCoordinates.add(coordinate);
          }
        }
      }
    }
    return GeneralHelper.getAverageCoordinates(xyzCoordinates);
  }

  static Vector3 _calculateCoordinates(BeaconLocationModel beacon1, BeaconLocationModel beacon2, BeaconLocationModel beacon3) {
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
    return Vector3(_x0, _y0, _z0);
  }

  static double _delta(BeaconLocationModel beacon1, BeaconLocationModel beacon2, BeaconLocationModel beacon3) {
    Matrix3 delta = Matrix3(
      2 * (_x0 - beacon1.xCoordinate),
      2 * (_x0 - beacon2.xCoordinate),
      2 * (_x0 - beacon3.xCoordinate),
      2 * (_y0 - beacon1.yCoordinate),
      2 * (_y0 - beacon2.yCoordinate),
      2 * (_y0 - beacon3.yCoordinate),
      2 * (_z0 - beacon1.zCoordinate),
      2 * (_z0 - beacon2.zCoordinate),
      2 * (_z0 - beacon3.zCoordinate),
    );
    return delta.determinant();
  }

  static double _deltaX(BeaconLocationModel beacon1, BeaconLocationModel beacon2, BeaconLocationModel beacon3) {
    Matrix3 deltaX = Matrix3(
      (pow((_x0 - beacon1.xCoordinate), 2) +
              pow((_y0 - beacon1.yCoordinate), 2) +
              pow((_z0 - beacon1.zCoordinate), 2) -
              pow((beacon1.distance ?? 0.0), 2))
          .toDouble(),
      (pow((_x0 - beacon2.xCoordinate), 2) +
              pow((_y0 - beacon2.yCoordinate), 2) +
              pow((_z0 - beacon2.zCoordinate), 2) -
              pow((beacon2.distance ?? 0.0), 2))
          .toDouble(),
      (pow((_x0 - beacon3.xCoordinate), 2) +
              pow((_y0 - beacon3.yCoordinate), 2) +
              pow((_z0 - beacon3.zCoordinate), 2) -
              pow((beacon3.distance ?? 0.0), 2))
          .toDouble(),
      2 * (_y0 - beacon1.yCoordinate),
      2 * (_y0 - beacon2.yCoordinate),
      2 * (_y0 - beacon3.yCoordinate),
      2 * (_z0 - beacon1.zCoordinate),
      2 * (_z0 - beacon2.zCoordinate),
      2 * (_z0 - beacon3.zCoordinate),
    );

    return deltaX.determinant();
  }

  static double _deltaY(BeaconLocationModel beacon1, BeaconLocationModel beacon2, BeaconLocationModel beacon3) {
    Matrix3 deltaY = Matrix3(
      2 * (_x0 - beacon1.xCoordinate),
      2 * (_x0 - beacon2.xCoordinate),
      2 * (_x0 - beacon3.xCoordinate),
      (pow((_x0 - beacon1.xCoordinate), 2) +
              pow((_y0 - beacon1.yCoordinate), 2) +
              pow((_z0 - beacon1.zCoordinate), 2) -
              pow((beacon1.distance ?? 0.0), 2))
          .toDouble(),
      (pow((_x0 - beacon2.xCoordinate), 2) +
              pow((_y0 - beacon2.yCoordinate), 2) +
              pow((_z0 - beacon2.zCoordinate), 2) -
              pow((beacon2.distance ?? 0.0), 2))
          .toDouble(),
      (pow((_x0 - beacon3.xCoordinate), 2) +
              pow((_y0 - beacon3.yCoordinate), 2) +
              pow((_z0 - beacon3.zCoordinate), 2) -
              pow((beacon3.distance ?? 0.0), 2))
          .toDouble(),
      2 * (_z0 - beacon1.zCoordinate),
      2 * (_z0 - beacon2.zCoordinate),
      2 * (_z0 - beacon3.zCoordinate),
    );
    return deltaY.determinant();
  }

  static double _deltaZ(BeaconLocationModel beacon1, BeaconLocationModel beacon2, BeaconLocationModel beacon3) {
    Matrix3 deltaZ = Matrix3(
      2 * (_x0 - beacon1.xCoordinate),
      2 * (_x0 - beacon2.xCoordinate),
      2 * (_x0 - beacon3.xCoordinate),
      2 * (_y0 - beacon1.yCoordinate),
      2 * (_y0 - beacon2.yCoordinate),
      2 * (_y0 - beacon3.zCoordinate),
      (pow((_x0 - beacon1.xCoordinate), 2) +
              pow((_y0 - beacon1.yCoordinate), 2) +
              pow((_z0 - beacon1.zCoordinate), 2) -
              pow((beacon1.distance ?? 0.0), 2))
          .toDouble(),
      (pow((_x0 - beacon2.xCoordinate), 2) +
              pow((_y0 - beacon2.yCoordinate), 2) +
              pow((_z0 - beacon2.zCoordinate), 2) -
              pow((beacon2.distance ?? 0.0), 2))
          .toDouble(),
      (pow((_x0 - beacon3.xCoordinate), 2) +
              pow((_y0 - beacon3.yCoordinate), 2) +
              pow((_z0 - beacon3.zCoordinate), 2) -
              pow((beacon3.distance ?? 0.0), 2))
          .toDouble(),
    );
    return deltaZ.determinant();
  }
}
