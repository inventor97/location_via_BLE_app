import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';
import 'package:location_via_ble_app/models/BeaconLocationModel.dart';
import 'package:location_via_ble_app/services/StorageService.dart';
import 'package:vector_math/vector_math_64.dart';

class GeneralHelper {

  static const platform = MethodChannel('BEACONS');

  static final storage  = Get.find<StorageService>();

  static List<BeaconLocationModel> getBeaconCoordinates(List<Beacon> scannedBeacons) {
    List<BeaconLocationModel> beaconLocations = [];
    for (var e in scannedBeacons) {
      BeaconLocationModel location = storage.beacons.firstWhere((element) => element.macAddress == e.macAddress);
      beaconLocations.add(
        BeaconLocationModel(
          xCoordinate: location.xCoordinate,
          yCoordinate: location.yCoordinate,
          zCoordinate: location.zCoordinate,
          distance: e.accuracy * 100,
        ),
      );
    }
    return beaconLocations;
  }

  static Vector3 getAverageCoordinates(List<Vector3> xyCoordinates) {
    Vector3 location = Vector3(0, 0, 0);
    for (var el in xyCoordinates) {
      if (!el.x.isNaN && !el.y.isNaN) {
        location.x += el.x;
        location.y += el.y;
        location.z += el.z;
      }
    }

    return Vector3(location.x / xyCoordinates.length, location.y / xyCoordinates.length, location.z / xyCoordinates.length);
  }

  static double dArgument(BeaconLocationModel beacon) {
    return ((beacon.distance! * beacon.distance! -
                beacon.xCoordinate * beacon.xCoordinate -
                beacon.yCoordinate * beacon.yCoordinate -
                beacon.zCoordinate * beacon.zCoordinate) /
            2)
        .toDouble();
  }

  static double getDerivation(List<double> numbers) {
    double derivation = 0.0;
    for (double e in numbers) {
      derivation += pow((e - getAverage(numbers)), 2);
    }
    return pow(derivation / numbers.length, 1 / 2).toDouble();
  }

  static double getAverage(List<double> numbers) {
    return numbers.reduce((value, element) => value + element) / numbers.length;
  }

  static double calculateDistanceMethod(int? txPower, double rssi) {
    double ratio = 207 / (256 + rssi);
    if (ratio > 1.0) {
      return pow(ratio, 10).toDouble();
    } else {
      return ((0.89976) * pow(ratio, 7.7095) + 0.111);
    }
  }

  static double calculateDistanceMethod2(Beacon beacon) {
    return pow(10, (beacon.txPower! - beacon.rssi) / 23).toDouble();
  }

  // static Future<Vector3> findCoordinates(Map<String, ScanResult> beacons) async {
  //   double averageRSSI = 0.0;
  //   List<LocationModel> filteredBeacons = [];
  //   List<double> result = [];
  //
  //   for (ScanResult beacon in beacons.values) {
  //     ///filtering RSSI
  //     // int rssiDerivation = getDerivation(List.from(beacon.map((e) => e.rssi.toDouble()))).toInt();
  //     // int rssiAverage = getAverage(List.from(beacon.map((e) => e.rssi.toDouble()))).toInt();
  //     //
  //     // beacon.removeWhere((el) => el.rssi <= (rssiAverage - rssiDerivation));
  //     // beacon.removeWhere((el) => el.rssi >= (rssiAverage + rssiDerivation));
  //     //
  //
  //     LocationModel locationBeacon = LocationModel.beaconsCoordinates[beacon.device.id.toString()]!;
  //
  //     filteredBeacons.add(LocationModel(
  //         xCoordinate: locationBeacon.xCoordinate,
  //         yCoordinate: locationBeacon.yCoordinate,
  //         zCoordinate: locationBeacon.zCoordinate,
  //         distance: calculateDistanceMethod(-49, beacon.rssi.toDouble())));
  //
  //     Logger().i("${beacon.device.id.toString()} -> ${calculateDistanceMethod(-49, averageRSSI)} rssi: ${beacon.rssi}");
  //   }
  //
  //   List<List<double>> data = List.from(filteredBeacons.map((e) => LocationModel.toDoubleArray(e)));
  //
  //   try {
  //     result = await platform.invokeMethod('BEACONS', {"coordinates": data});
  //   } on PlatformException catch (e) {
  //     Logger().e(e);
  //   }
  //   return  Vector3(result[0], result[1], 0);
  // }
}
