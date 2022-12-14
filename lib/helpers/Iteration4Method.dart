import 'dart:math';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:location_via_ble_app/helpers/GeneralHelper.dart';
import 'package:location_via_ble_app/models/BeaconLocationModel.dart';
import 'package:logger/logger.dart';
import 'package:vector_math/vector_math_64.dart';

class Iteration4Method {
  static Vector3 calculateLocation(List<Beacon> beacons) {
    List<Vector3> xyzCoordinates = [];
    List<BeaconLocationModel> beaconLocations = GeneralHelper.getBeaconCoordinates(beacons);

    // for (int i = 0; i < beaconLocations.length; i++) {
    //   for (int j = i + 1; j < beaconLocations.length; j++) {
    //     for (int k = j + 1; k < beaconLocations.length; k++) {
    //       for (int q = k + 1; q < beaconLocations.length; q++) {
    //         Vector3 coordinate = _calculateCoordinates([beaconLocations[i], beaconLocations[j], beaconLocations[k], beaconLocations[q]]);
    //         if (coordinate.x > 0 && coordinate.y > 0 && coordinate.z > 0) {
    //           xyzCoordinates.add(coordinate);
    //         }
    //       }
    //     }
    //   }
    // }
    // return GeneralHelper.getAverageCoordinates(xyzCoordinates);
    return _calculateCoordinates(beaconLocations);
  }

  static Vector3 _calculateCoordinates(List<BeaconLocationModel> beacons) {
    return Vector3(_deltaX(beacons) / _delta(beacons), _deltaY(beacons) / _delta(beacons), _deltaZ(beacons) / _delta(beacons));
  }

  static double _delta(List<BeaconLocationModel> beacons) {
    Matrix3 delta = Matrix3(
      beacons[0].xCoordinate - beacons[1].xCoordinate,
      beacons[0].xCoordinate - beacons[2].xCoordinate,
      beacons[0].xCoordinate - beacons[3].xCoordinate,
      beacons[0].yCoordinate - beacons[1].yCoordinate,
      beacons[0].yCoordinate - beacons[2].yCoordinate,
      beacons[0].yCoordinate - beacons[3].yCoordinate,
      beacons[0].zCoordinate - beacons[1].zCoordinate,
      beacons[0].zCoordinate - beacons[2].zCoordinate,
      beacons[0].zCoordinate - beacons[3].zCoordinate,
    );
    // Logger().w("matrix: ${delta} delta: ${delta.determinant()}");
    return delta.determinant();
  }

  static double _deltaX(List<BeaconLocationModel> beacons) {
    Matrix3 deltaX = Matrix3(
      GeneralHelper.dArgument(beacons[1]) - GeneralHelper.dArgument(beacons[0]),
      GeneralHelper.dArgument(beacons[2]) - GeneralHelper.dArgument(beacons[0]),
      GeneralHelper.dArgument(beacons[3]) - GeneralHelper.dArgument(beacons[0]),
      beacons[0].yCoordinate - beacons[1].yCoordinate,
      beacons[0].yCoordinate - beacons[2].yCoordinate,
      beacons[0].yCoordinate - beacons[3].yCoordinate,
      beacons[0].zCoordinate - beacons[1].zCoordinate,
      beacons[0].zCoordinate - beacons[2].zCoordinate,
      beacons[0].zCoordinate - beacons[3].zCoordinate,
    );
    // Logger().w("matrix: $deltaX deltaX: ${deltaX.determinant()}");
    return deltaX.determinant();
  }

  static double _deltaY(List<BeaconLocationModel> beacons) {
    Matrix3 deltaY = Matrix3(
      beacons[0].xCoordinate - beacons[1].xCoordinate,
      beacons[0].xCoordinate - beacons[2].xCoordinate,
      beacons[0].xCoordinate - beacons[3].xCoordinate,
      GeneralHelper.dArgument(beacons[1]) - GeneralHelper.dArgument(beacons[0]),
      GeneralHelper.dArgument(beacons[2]) - GeneralHelper.dArgument(beacons[0]),
      GeneralHelper.dArgument(beacons[3]) - GeneralHelper.dArgument(beacons[0]),
      beacons[0].zCoordinate - beacons[1].zCoordinate,
      beacons[0].zCoordinate - beacons[2].zCoordinate,
      beacons[0].zCoordinate - beacons[3].zCoordinate,
    );
    // Logger().w("deltaY: ${deltaY.determinant()}");

    return deltaY.determinant();
  }

  static double _deltaZ(List<BeaconLocationModel> beacons) {
    Matrix3 deltaZ = Matrix3(
      beacons[0].xCoordinate - beacons[1].xCoordinate,
      beacons[0].xCoordinate - beacons[2].xCoordinate,
      beacons[0].xCoordinate - beacons[3].xCoordinate,
      beacons[0].yCoordinate - beacons[1].yCoordinate,
      beacons[0].yCoordinate - beacons[2].yCoordinate,
      beacons[0].yCoordinate - beacons[3].yCoordinate,
      GeneralHelper.dArgument(beacons[1]) - GeneralHelper.dArgument(beacons[0]),
      GeneralHelper.dArgument(beacons[2]) - GeneralHelper.dArgument(beacons[0]),
      GeneralHelper.dArgument(beacons[3]) - GeneralHelper.dArgument(beacons[0]),
    );
    // Logger().w("deltaZ: ${deltaZ.determinant()}");
    return deltaZ.determinant();
  }
}
