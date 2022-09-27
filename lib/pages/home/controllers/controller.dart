import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:get/get.dart';
import 'package:location_via_ble_app/helpers/CustomMethod.dart';
import 'package:location_via_ble_app/services/StorageService.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vector_math/vector_math_64.dart' as math;

import '../../BaseController.dart';

class HomeController extends BaseController with GetSingleTickerProviderStateMixin {
  final direction = 0.0.obs;
  final angleByNorth = 253;

  final double pxMetersCoefficient = 0.4706;
  final startXCoordinate = 50;
  final startYCoordinate = 200;

  final storage = Get.find<StorageService>();

  late AnimationController animationCtrl;

  final colorData = Colors.grey.obs;

  StreamSubscription<RangingResult>? _streamRanging;
  Map<String, List<Beacon>> regionBeacons = {
    "DC:0D:30:0F:AC:34": [],
    "DC:0D:30:0F:AC:25": [],
    "DC:0D:30:0F:AB:8B": [],
    "DC:0D:30:0F:AB:97": [],
  };
  final _beacons = <Beacon>[];
  final beaconData = <String, Beacon>{}.obs;
  final xCoordinate = 0.0.obs;
  final yCoordinate = 0.0.obs;
  final zCoordinate = 0.0.obs;

  final isScanning = false.obs;

  @override
  void onInit() {
    super.onInit();
    permission();
    animationCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      upperBound: 0.5,
    );

  }

  @override
  void onReady() {
    super.onReady();
    FlutterCompass.events?.listen((event) {
      direction.value = event.heading ?? 0.0;
    });
    for (var element in storage.beacons) {
      element.color = colorMap()[element.name];
    }
    Logger().i(storage.beacons);
  }


  initScanBeacon() async {
    await flutterBeacon.initializeScanning;
    final regions = List<Region>.from(
      storage.beacons.map((element) => Region(identifier: element.name!, proximityUUID: element.uuid!)),
    );
    isScanning.value = true;
    await flutterBeacon.setScanPeriod(100);

    _streamRanging = flutterBeacon.ranging(regions).listen((RangingResult result) async {
      if (result.beacons.isNotEmpty) {
        regionBeacons[result.beacons.first.macAddress!]!.add(result.beacons.first);

        if (regionBeacons.values.every((element) => element.length > 5)) {
          List<Beacon> averageCalculatedBeacons = [];
          for (var e in regionBeacons.values) {
            // int rssiDerivation = GeneralHelper.getDerivation(List.from(e.map((e) => e.accuracy.toDouble()))).toInt();
            // int rssiAverage = GeneralHelper.getAverage(List.from(e.map((e) => e.accuracy.toDouble()))).toInt();
            //
            // e.removeWhere((el) => el.accuracy <= (rssiAverage - 2 * rssiDerivation));
            // e.removeWhere((el) => el.accuracy >= (rssiAverage + 2 * rssiDerivation));
            double averageRSSI = List<double>.from(e.map((e) => e.accuracy.toDouble())).reduce((value, element) => value + element) / e.length;

            averageCalculatedBeacons.add(Beacon(
              proximityUUID: e.first.proximityUUID,
              major: e.first.major,
              minor: e.first.minor,
              accuracy: averageRSSI,
              macAddress: e.first.macAddress,
              txPower: e.first.txPower,
              rssi: e.first.rssi,
            ));
          }

          Beacon nearestBeacon = averageCalculatedBeacons.reduce((value, element) => value.accuracy < element.accuracy ? value : element);


          colorData.value = nearestBeacon.accuracy < 1 ? uuidColorMap()[nearestBeacon.macAddress] ?? Colors.grey : Colors.grey;

          math.Vector3 location = await CustomMethod.calculateLocation(averageCalculatedBeacons, nearestBeacon);
          xCoordinate.value = startXCoordinate + location.x * pxMetersCoefficient;
          yCoordinate.value = startYCoordinate + location.y * pxMetersCoefficient;

          Logger().i("${xCoordinate.value} - ${yCoordinate.value}");

          regionBeacons = {
            "DC:0D:30:0F:AC:34": [],
            "DC:0D:30:0F:AC:25": [],
            "DC:0D:30:0F:AB:8B": [],
            "DC:0D:30:0F:AB:97": [],
          };
        }
      }
    });
  }

  pauseScanBeacon() async {
    isScanning.value = false;
    _streamRanging?.pause();
    if (_beacons.isNotEmpty) {
      _beacons.clear();
    }
  }

  uuidColorMap() => {
  "DC:0D:30:0F:AC:34": Colors.green,
  "DC:0D:30:0F:AC:25": Colors.yellow,
  "DC:0D:30:0F:AB:8B": Colors.orange,
  "DC:0D:30:0F:AB:97": Colors.red,
  };

  colorMap() {
    return {
      "ORANGE": Colors.orange,
      "RED": Colors.red,
      "GREEN": Colors.green,
      "YELLOW": Colors.yellow,
    };
  }

  @override
  void dispose() {
    _streamRanging?.cancel();
    super.dispose();
  }

  void permission() async {
    await Permission.location
        .request()
        .isGranted;
    await Permission.bluetooth
        .request()
        .isGranted;
    await Permission.locationAlways
        .request()
        .isGranted;
    await Permission.bluetoothScan
        .request()
        .isGranted;
    await Permission.bluetoothAdvertise
        .request()
        .isGranted;
    await Permission.bluetoothConnect
        .request()
        .isGranted;
  }
}
