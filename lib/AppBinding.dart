import 'package:get/get.dart';
import 'package:location_via_ble_app/services/StorageService.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StorageService());
  }
}
