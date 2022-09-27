import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:location_via_ble_app/pages/beacon/views/_beaconListTile.dart';
import 'package:location_via_ble_app/pages/beacon/views/_editBeacon.dart';
import '../controllers/controller.dart';

class BeaconPage extends GetView<BeaconController> {
  const BeaconPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EditBeacon(),
      body: Obx(
        () => SingleChildScrollView(
          child: Container(
            color: Colors.grey.withOpacity(0.1),
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: controller.storage.beacons.map((element) => BeaconListTile(beacon: element)).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
