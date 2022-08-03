import '../controllers/controller.dart';
import 'package:get/get.dart';

class BeaconBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeaconController());
  }
}
