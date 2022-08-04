import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:location_via_ble_app/models/BeceonLocationModel.dart';
import 'package:vector_math/vector_math_64.dart';

class GeneralHelper  {

  static List<LocationModel> getBeaconCoordinates(List<Beacon> beacons) {
    List<LocationModel> beaconLocations = [];
    for (var e in beacons) {
      LocationModel location = LocationModel.beaconsCoordinates[e.macAddress]!;
      beaconLocations.add(
        LocationModel(
          xCoordinate: location.xCoordinate,
          yCoordinate: location.yCoordinate,
          zCoordinate: location.zCoordinate,
          distance: e.accuracy * 100,
        ),
      );
    }
    return beaconLocations;
  }

  static Vector2 getAverageCoordinates(List<List<double>> xyCoordinates) {
    Vector2 location = Vector2(0, 0);
    for (var el in xyCoordinates) {
      location.x+=el[0];
      location.y+=el[1];
    }
    
    return Vector2(location.x/xyCoordinates.length, location.y/xyCoordinates.length);
  }

  static double dArgument(LocationModel beacon) {
    return ((beacon.distance! * beacon.distance! -
        beacon.xCoordinate * beacon.xCoordinate -
        beacon.yCoordinate * beacon.yCoordinate -
        beacon.zCoordinate * beacon.zCoordinate) /
        2)
        .toDouble();
  }
}