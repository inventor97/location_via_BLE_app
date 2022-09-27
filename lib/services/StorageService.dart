import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location_via_ble_app/models/BeaconLocationModel.dart';
import 'package:logger/logger.dart';

class StorageService extends GetxService {
  final beacons = <BeaconLocationModel>[].obs;
  final box = GetStorage();

  void saveBeacons() {
    _saveToDevice(_fieldBeacons, List.from(beacons.map((item) => item.toStorageJson())));
  }

  @override
  void onReady() {
    super.onReady();
    try {
      beacons.value = List<BeaconLocationModel>.from(_loadFromDevice(_fieldBeacons).map((e) => BeaconLocationModel.fromStorageJson(e)));
    } catch(e) {
      beacons.value = List<BeaconLocationModel>.from(BeaconLocationModel.beaconsCoordinates.values.map((e) => e));
      saveBeacons();
    }
  }

  void _saveToDevice(String key, dynamic value) {
    try {
      box.write(key, jsonEncode(value));
      Logger().w("$key $value");
    } catch (e) {
      Logger().e(e);
    }
  }

  dynamic _loadFromDevice(String key) {
    try {
      return jsonDecode(box.read(key));
    } catch (e) {
      Logger().e(e);
    }
  }

  final String _fieldBeacons = "_b";
}
