import 'dart:async';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';
import 'package:location_via_ble_app/helpers/CalculationCoordinateHelper.dart';
import 'package:location_via_ble_app/models/BeceonLocationModel.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../BaseController.dart';

class HomeController extends BaseController {
  final beacons = <LocationModel>[].obs;

  StreamSubscription<RangingResult>? _streamRanging;
  final _regionBeacons = <Region, Beacon>{};
  final _beacons = <Beacon>[];
  final _beaconRSSIs = <int>[].obs;
  final xCoordinate = 0.0.obs;
  final yCoordinate = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    permission();
  }

  initScanBeacon() async {
    await flutterBeacon.initializeScanning;
    final regions = <Region>[
      Region(
        identifier: 'RED',
        proximityUUID: 'd546df97-4757-47ef-be09-3e2dcbdd0c98',
      ),
      Region(
        identifier: 'GREEN',
        proximityUUID: 'edbddddd-dbde-dcfc-bfbc-dddddbffbcbd',
      ),
      Region(
        identifier: 'YELLOW',
        proximityUUID: 'd546df97-4757-47ef-be09-3e2dcbdd0c77',
      ),
      Region(
        identifier: 'ORANGE',
        proximityUUID: 'fda50693-a4e2-4fb1-afcf-c6eb07647825',
      ),
    ];

    await flutterBeacon.setScanPeriod(100);

    _streamRanging = flutterBeacon.ranging(regions).listen((RangingResult result) {
      if (result.beacons.isNotEmpty) {
        _regionBeacons[result.region] = result.beacons.first;
        Logger().w("${result.beacons.first.macAddress} -> ${result.beacons.first.accuracy}");
        // _regionBeacons.values.forEach((list) {
        //   _beacons.addAll(list);
        //
        // });

        if (_regionBeacons.length >= 4) {
          // xCoordinate.value = CalculationCoordinateHelper.calculateLocation(List<Beacon>.from(_regionBeacons.values.map((e) => e)))[0][0];
          // yCoordinate.value = CalculationCoordinateHelper.calculateLocation(List<Beacon>.from(_regionBeacons.values.map((e) => e)))[1][1];
        }
        _beacons.clear();
        // _beaconRSSIs.add(result.beacons.)
        // _beacons.sort(_compareParameters);
      }
    });
  }

  pauseScanBeacon() async {
    _streamRanging?.pause();
    if (_beacons.isNotEmpty) {
      _beacons.clear();
    }
  }

  @override
  void dispose() {
    _streamRanging?.cancel();
    super.dispose();
  }

  void permission() async {
    await Permission.location.request().isGranted;
    await Permission.bluetooth.request().isGranted;
    await Permission.locationAlways.request().isGranted;
    await Permission.bluetoothScan.request().isGranted;
    await Permission.bluetoothAdvertise.request().isGranted;
    await Permission.bluetoothConnect.request().isGranted;
  }
}
