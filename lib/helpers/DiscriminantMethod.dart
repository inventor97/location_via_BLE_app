import 'dart:math';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:location_via_ble_app/helpers/GeneralHelper.dart';
import 'package:location_via_ble_app/models/BeaconLocationModel.dart';
import 'package:vector_math/vector_math_64.dart';

class DiscriminantMethod {
  static Vector3 calculateLocation(List<Beacon> beacons) {
    List<Vector3> xyzCoordinates = [];
    List<BeaconLocationModel> beaconLocations = GeneralHelper.getBeaconCoordinates(beacons);

    // for (int i = 0; i < beaconLocations.length; i++) {
    //   for (int j = i + 1; j < beaconLocations.length; j++) {
    //     for (int k = j + 1; k < beaconLocations.length; k++) {
    //       Vector3 coordinate = _calculateCoordinates(beaconLocations[i], beaconLocations[j], beaconLocations[k]);
    //       if (coordinate.x > 0 && coordinate.y > 0 && coordinate.z > 0) {
    //         xyzCoordinates.add(coordinate);
    //       }
    //     }
    //   }
    // }
    //
    // return GeneralHelper.getAverageCoordinates(xyzCoordinates);
    return _calculateCoordinates(beaconLocations[0], beaconLocations[1], beaconLocations[2]);
  }

  static Vector3 _calculateCoordinates(BeaconLocationModel beacon1, BeaconLocationModel beacon2, BeaconLocationModel beacon3) {
    double z = ((-1) * _calculateEArgument(beacon1, beacon2, beacon3) +
            pow(
                    (_calculateEArgument(beacon1, beacon2, beacon3) * _calculateEArgument(beacon1, beacon2, beacon3) -
                        4 * _calculateFArgument(beacon1, beacon2, beacon3) * _calculateGArgument(beacon1, beacon2, beacon3)),
                    1 / 2)
                .toDouble()) /
        (2 * _calculateFArgument(beacon1, beacon2, beacon3));
    return Vector3(_calculateAArgument(beacon1, beacon2, beacon3) + _calculateBArgument(beacon1, beacon2, beacon3) * z,
        _calculateCArgument(beacon1, beacon2, beacon3) + _calculateKArgument(beacon1, beacon2, beacon3) * z, z);
  }

  static double _calculateAArgument(BeaconLocationModel beacon1, BeaconLocationModel beacon2, BeaconLocationModel beacon3) {
    return (((GeneralHelper.dArgument(beacon2) - GeneralHelper.dArgument(beacon1)) / 2) * (beacon1.yCoordinate - beacon3.yCoordinate) -
            ((GeneralHelper.dArgument(beacon3) - GeneralHelper.dArgument(beacon1)) / 2) * (beacon1.yCoordinate - beacon2.yCoordinate)) /
        _argument(beacon1, beacon2, beacon3);
  }

  static double _calculateBArgument(BeaconLocationModel beacon1, BeaconLocationModel beacon2, BeaconLocationModel beacon3) {
    return ((beacon1.zCoordinate - beacon3.zCoordinate) * (beacon1.yCoordinate - beacon2.yCoordinate) -
            (beacon1.zCoordinate - beacon2.zCoordinate) * (beacon1.yCoordinate - beacon3.yCoordinate)) /
        _argument(beacon1, beacon2, beacon3);
  }

  static double _calculateCArgument(BeaconLocationModel beacon1, BeaconLocationModel beacon2, BeaconLocationModel beacon3) {
    return (((GeneralHelper.dArgument(beacon3) - GeneralHelper.dArgument(beacon1)) / 2) * (beacon1.xCoordinate - beacon2.xCoordinate) -
            ((GeneralHelper.dArgument(beacon2) - GeneralHelper.dArgument(beacon1)) / 2) * (beacon1.xCoordinate - beacon3.xCoordinate)) /
        _argument(beacon1, beacon2, beacon3);
  }

  static double _calculateKArgument(BeaconLocationModel beacon1, BeaconLocationModel beacon2, BeaconLocationModel beacon3) {
    return ((beacon1.xCoordinate - beacon3.xCoordinate) * (beacon1.xCoordinate - beacon2.zCoordinate) -
            (beacon1.xCoordinate - beacon2.xCoordinate) * (beacon1.zCoordinate - beacon3.zCoordinate)) /
        _argument(beacon1, beacon2, beacon3);
  }

  static double _calculateEArgument(BeaconLocationModel beacon1, BeaconLocationModel beacon2, BeaconLocationModel beacon3) {
    return 2 * _calculateAArgument(beacon1, beacon2, beacon3) * _calculateBArgument(beacon1, beacon2, beacon3) +
        2 * _calculateCArgument(beacon1, beacon2, beacon3) * _calculateKArgument(beacon1, beacon2, beacon3) -
        2 * _calculateBArgument(beacon1, beacon2, beacon3) -
        2 * _calculateKArgument(beacon1, beacon2, beacon3) * beacon1.yCoordinate -
        2 * beacon1.zCoordinate;
  }

  static double _calculateFArgument(BeaconLocationModel beacon1, BeaconLocationModel beacon2, BeaconLocationModel beacon3) {
    return _calculateBArgument(beacon1, beacon2, beacon3) * _calculateBArgument(beacon1, beacon2, beacon3) +
        _calculateKArgument(beacon1, beacon2, beacon3) * _calculateKArgument(beacon1, beacon2, beacon3) +
        1;
  }

  static double _calculateGArgument(BeaconLocationModel beacon1, BeaconLocationModel beacon2, BeaconLocationModel beacon3) {
    return _calculateAArgument(beacon1, beacon2, beacon3) * _calculateAArgument(beacon1, beacon2, beacon3) +
        _calculateCArgument(beacon1, beacon2, beacon3) * _calculateCArgument(beacon1, beacon2, beacon3) -
        2 * _calculateAArgument(beacon1, beacon2, beacon3) * beacon1.xCoordinate -
        2 * _calculateCArgument(beacon1, beacon2, beacon3) * beacon1.yCoordinate -
        GeneralHelper.dArgument(beacon1);
  }

  static double _argument(BeaconLocationModel beacon1, BeaconLocationModel beacon2, BeaconLocationModel beacon3) {
    return ((beacon1.xCoordinate - beacon2.xCoordinate) * (beacon1.yCoordinate - beacon3.yCoordinate) -
        (beacon1.xCoordinate - beacon3.xCoordinate) * (beacon1.yCoordinate - beacon2.yCoordinate));
  }
}
