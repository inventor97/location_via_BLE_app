import 'package:get/get.dart';
import 'package:location_via_ble_app/AppRoutes.dart';
import 'package:location_via_ble_app/pages/beacon/bindings/binding.dart';
import 'package:location_via_ble_app/pages/beacon/views/view.dart';
import 'package:location_via_ble_app/pages/home/bindings/binding.dart';
import 'package:location_via_ble_app/pages/home/views/view.dart';

class AppPages {
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.BASE,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.BEACON,
      page: () => const BeaconPage(),
      binding: BeaconBinding(),
    ),
  ];
}
