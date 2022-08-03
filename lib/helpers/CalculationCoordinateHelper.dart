import 'dart:math';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:location_via_ble_app/models/BeceonLocationModel.dart';
import 'package:logger/logger.dart';
import 'package:vector_math/vector_math_64.dart';

class CalculationCoordinateHelper {


  static List<List<double>> calculateLocation(List<Beacon> beacons) {
    List<List<double>> xyzCoordinates = [];
    List<LocationModel> beaconLocations  = [];
    for (var e in beacons) {
      LocationModel location = LocationModel.beaconsCoordinates[e.macAddress]!;
      beaconLocations.add(
        LocationModel(
          xCoordinate: location.xCoordinate,
          yCoordinate: location.yCoordinate,
          zCoordinate: location.zCoordinate,
          distance: e.accuracy*100,
        ),
      );
    }
    Logger().e("${beaconLocations[0].xCoordinate};${beaconLocations[0].yCoordinate} -> ${beaconLocations[0].distance}\n"
        "${beaconLocations[1].xCoordinate};${beaconLocations[1].yCoordinate} -> ${beaconLocations[1].distance}\n"
        "${beaconLocations[2].xCoordinate};${beaconLocations[2].yCoordinate} -> ${beaconLocations[2].distance}\n"
        "${beaconLocations[3].xCoordinate};${beaconLocations[3].yCoordinate} -> ${beaconLocations[3].distance}");

    for (int i = 0; i < beaconLocations.length; i++) {
      for (int j = i + 1; j < beaconLocations.length; j++) {
        for (int k = j + 1; k < beaconLocations.length; k++) {
          for(int q = k + 1;q < beaconLocations.length; q++) {
            xyzCoordinates.add(_calculateCoordinates([beaconLocations[i], beaconLocations[j], beaconLocations[k], beaconLocations[q]]));
          }
        }
      }
    }
    Logger().i(xyzCoordinates);
    return xyzCoordinates;
  }

  static _calculateCoordinates(List<LocationModel> beacons) {
    return [_deltaX(beacons) / _delta(beacons), _deltaY(beacons) / _delta(beacons), _deltaZ(beacons) / _delta(beacons)];
  }

  static double _delta(List<LocationModel> beacons) {
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
    Logger().w("matrix: ${delta} delta: ${delta.determinant()}");
    return delta.determinant();
  }

  static double _deltaX(List<LocationModel> beacons) {
    Matrix3 deltaX = Matrix3(
      _dArgument(beacons[1]) - _dArgument(beacons[0]),
      _dArgument(beacons[2]) - _dArgument(beacons[0]),
      _dArgument(beacons[3]) - _dArgument(beacons[0]),
      beacons[1].yCoordinate - beacons[0].yCoordinate,
      beacons[2].yCoordinate - beacons[0].yCoordinate,
      beacons[3].yCoordinate - beacons[0].yCoordinate,
      beacons[1].zCoordinate - beacons[0].zCoordinate,
      beacons[2].zCoordinate - beacons[0].zCoordinate,
      beacons[3].zCoordinate - beacons[0].zCoordinate,
    );
    Logger().w("matrix: ${deltaX} deltaX: ${deltaX.determinant()}");
    return deltaX.determinant();
  }

  static double _deltaY(List<LocationModel> beacons) {
    Matrix3 deltaY = Matrix3(
      beacons[0].xCoordinate - beacons[1].xCoordinate,
      beacons[0].xCoordinate - beacons[2].xCoordinate,
      beacons[0].xCoordinate - beacons[3].xCoordinate,
      _dArgument(beacons[1]) - _dArgument(beacons[0]),
      _dArgument(beacons[2]) - _dArgument(beacons[0]),
      _dArgument(beacons[3]) - _dArgument(beacons[0]),
      beacons[0].zCoordinate - beacons[1].zCoordinate,
      beacons[0].zCoordinate - beacons[2].zCoordinate,
      beacons[0].zCoordinate - beacons[3].zCoordinate,
    );
    Logger().w("deltaY: ${deltaY.determinant()}");

    return deltaY.determinant();
  }

  static double _deltaZ(List<LocationModel> beacons) {
    Matrix3 deltaZ = Matrix3(
      beacons[0].xCoordinate - beacons[1].xCoordinate,
      beacons[0].xCoordinate - beacons[2].xCoordinate,
      beacons[0].xCoordinate - beacons[3].xCoordinate,
      beacons[0].yCoordinate - beacons[1].yCoordinate,
      beacons[0].yCoordinate - beacons[2].yCoordinate,
      beacons[0].yCoordinate - beacons[3].yCoordinate,
      _dArgument(beacons[1]) - _dArgument(beacons[0]),
      _dArgument(beacons[2]) - _dArgument(beacons[0]),
      _dArgument(beacons[3]) - _dArgument(beacons[0]),
    );
    // Logger().w("deltaZ: ${deltaZ.determinant()}");
    return deltaZ.determinant();
  }

  static double _dArgument(LocationModel beacon) {
    return ((beacon.distance! * beacon.distance! -
                beacon.xCoordinate * beacon.xCoordinate -
                beacon.yCoordinate * beacon.yCoordinate -
                beacon.zCoordinate * beacon.zCoordinate) /
            2)
        .toDouble();
  }
}
