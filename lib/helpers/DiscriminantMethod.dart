import 'dart:math';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:location_via_ble_app/helpers/GeneralHelper.dart';
import 'package:location_via_ble_app/models/BeceonLocationModel.dart';
import 'package:logger/logger.dart';
import 'package:vector_math/vector_math_64.dart';

class DiscriminantMethod {
  static Vector2 calculationLocation(List<Beacon> beacons) {
    List<List<double>> xyzCoordinates = [];
    List<LocationModel> beaconLocations = GeneralHelper.getBeaconCoordinates(beacons);

    for (int i = 0; i < beaconLocations.length; i++) {
      for (int j = i + 1; j < beaconLocations.length; j++) {
        for (int k = j + 1; k < beaconLocations.length; k++) {
          xyzCoordinates.add(_calculateCoordinates(beaconLocations[i], beaconLocations[j], beaconLocations[k]));
          Logger().i(xyzCoordinates);
        }
      }
    }

    return GeneralHelper.getAverageCoordinates(xyzCoordinates);
  }

  static List<double> _calculateCoordinates(LocationModel beacon1, LocationModel beacon2, LocationModel beacon3) {
    double z = ((-1) * _calculateEArgument(beacon1, beacon2, beacon3) +
            pow(
                    (_calculateEArgument(beacon1, beacon2, beacon3) * _calculateEArgument(beacon1, beacon2, beacon3) -
                        4 * _calculateFArgument(beacon1, beacon2, beacon3) * _calculateGArgument(beacon1, beacon2, beacon3)),
                    1 / 2)
                .toDouble()) /
        (2 * _calculateFArgument(beacon1, beacon2, beacon3));
    return [
      _calculateAArgument(beacon1, beacon2, beacon3) + _calculateBArgument(beacon1, beacon2, beacon3) * z,
      _calculateCArgument(beacon1, beacon2, beacon3) + _calculateKArgument(beacon1, beacon2, beacon3) * z
    ];
  }

  static double _calculateAArgument(LocationModel beacon1, LocationModel beacon2, LocationModel beacon3) {
    return (((GeneralHelper.dArgument(beacon2) - GeneralHelper.dArgument(beacon1)) / 2) * (beacon1.yCoordinate - beacon3.yCoordinate) -
            ((GeneralHelper.dArgument(beacon3) - GeneralHelper.dArgument(beacon1)) / 2) * (beacon1.yCoordinate - beacon2.yCoordinate)) /
        _argument(beacon1, beacon2, beacon3);
  }

  static double _calculateBArgument(LocationModel beacon1, LocationModel beacon2, LocationModel beacon3) {
    return ((beacon1.zCoordinate - beacon3.zCoordinate) * (beacon1.yCoordinate - beacon2.yCoordinate) -
            (beacon1.zCoordinate - beacon2.zCoordinate) * (beacon1.yCoordinate - beacon3.yCoordinate)) /
        _argument(beacon1, beacon2, beacon3);
  }

  static double _calculateCArgument(LocationModel beacon1, LocationModel beacon2, LocationModel beacon3) {
    return (((GeneralHelper.dArgument(beacon3) - GeneralHelper.dArgument(beacon1)) / 2) * (beacon1.xCoordinate - beacon2.xCoordinate) -
            ((GeneralHelper.dArgument(beacon2) - GeneralHelper.dArgument(beacon1)) / 2) * (beacon1.xCoordinate - beacon3.xCoordinate)) /
        _argument(beacon1, beacon2, beacon3);
  }

  static double _calculateKArgument(LocationModel beacon1, LocationModel beacon2, LocationModel beacon3) {
    return ((beacon1.xCoordinate - beacon3.xCoordinate) * (beacon1.xCoordinate - beacon2.zCoordinate) -
            (beacon1.xCoordinate - beacon2.xCoordinate) * (beacon1.zCoordinate - beacon3.zCoordinate)) /
        _argument(beacon1, beacon2, beacon3);
  }

  static double _calculateEArgument(LocationModel beacon1, LocationModel beacon2, LocationModel beacon3) {
    return 2 * _calculateAArgument(beacon1, beacon2, beacon3) * _calculateBArgument(beacon1, beacon2, beacon3) +
        2 * _calculateCArgument(beacon1, beacon2, beacon3) * _calculateKArgument(beacon1, beacon2, beacon3) -
        2 * _calculateBArgument(beacon1, beacon2, beacon3) -
        2 * _calculateKArgument(beacon1, beacon2, beacon3) * beacon1.yCoordinate -
        2 * beacon1.zCoordinate;
  }

  static double _calculateFArgument(LocationModel beacon1, LocationModel beacon2, LocationModel beacon3) {
    return _calculateBArgument(beacon1, beacon2, beacon3) * _calculateBArgument(beacon1, beacon2, beacon3) +
        _calculateKArgument(beacon1, beacon2, beacon3) * _calculateKArgument(beacon1, beacon2, beacon3) +
        1;
  }

  static double _calculateGArgument(LocationModel beacon1, LocationModel beacon2, LocationModel beacon3) {
    return _calculateAArgument(beacon1, beacon2, beacon3) * _calculateAArgument(beacon1, beacon2, beacon3) +
        _calculateCArgument(beacon1, beacon2, beacon3) * _calculateCArgument(beacon1, beacon2, beacon3) -
        2 * _calculateAArgument(beacon1, beacon2, beacon3) * beacon1.xCoordinate -
        2 * _calculateCArgument(beacon1, beacon2, beacon3) * beacon1.yCoordinate -
        GeneralHelper.dArgument(beacon1);
  }

  static double _argument(LocationModel beacon1, LocationModel beacon2, LocationModel beacon3) {
    return ((beacon1.xCoordinate - beacon2.xCoordinate) * (beacon1.yCoordinate - beacon3.yCoordinate) -
        (beacon1.xCoordinate - beacon3.xCoordinate) * (beacon1.yCoordinate - beacon2.yCoordinate));
  }
}
