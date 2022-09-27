import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:location_via_ble_app/AppRoutes.dart';
import 'package:location_via_ble_app/widgets/AnimationRotation.dart';
import 'package:location_via_ble_app/widgets/BeaconItem.dart';
import '../controllers/controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey,
            ),

            Positioned(
              right: MediaQuery.of(context).size.width * 0.20,
              bottom: 100,
              child: Container(
                width: 250,
                height: 135,
                color: controller.colorData.value,
              ),
            ),
            AnimatedRotatableContainer(
              // angle: 180 - (controller.direction.value - controller.angleByNorth),
              angle: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Positioned(
                      // duration: const Duration(milliseconds: 500),
                      bottom: 0,
                      left: 0,
                      // bottom: controller.yCoordinate > 0 ? (MediaQuery.of(context).size.height * 0.48) - controller.yCoordinate.value : 0,
                      // left: controller.xCoordinate > 0 ? (MediaQuery.of(context).size.width * 0.48) - controller.xCoordinate.value : 0,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Stack(
                          children: [
                            ...controller.storage.beacons
                                .map(
                                  (e) => Positioned(
                                    bottom: controller.startYCoordinate + (e.yCoordinate * controller.pxMetersCoeffisent),
                                    left: controller.startXCoordinate + (e.xCoordinate * controller.pxMetersCoeffisent),
                                    child: BeaconItem(
                                      color: e.color ?? Colors.lightBlueAccent,
                                      distance: e.distance ?? 0.0,
                                    ),
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              // bottom: MediaQuery.of(context).size.height * 0.48,
              // left: MediaQuery.of(context).size.width * 0.48,
              bottom: controller.yCoordinate.value ,
              left:  controller.xCoordinate.value,
              child: const BeaconItem(
                color: Colors.black,
                radius: 28,
                distance: 0.0,
              ),
            ),
            Positioned(
                top: 45.0,
                left: 20.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: IconButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.BEACON);
                      },
                      icon: const Icon(Icons.layers_outlined)),
                )),
            Positioned(
              top: 45.0,
              right: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        BeaconItem(
                          color: Colors.black,
                          radius: 20,
                          distance: 0.0,
                        ),
                        SizedBox(width: 10.0),
                        Text("You"),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: const [
                        BeaconItem(
                          color: Colors.orange,
                          radius: 20,
                          distance: 0.0,
                        ),
                        SizedBox(width: 10.0),
                        Text("Beacons"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: MediaQuery.of(context).size.width * 0.35,
              bottom: 25,
              child: ElevatedButton(
                onPressed: () {
                  controller.isScanning.value ? controller.pauseScanBeacon() : controller.initScanBeacon();
                  // controller.initSensors();
                  // controller.initBlueScanning();
                  // Logger().w("${MediaQuery.of(context).size.height * 0.48} ${MediaQuery.of(context).size.width * 0.48}");
                  // CustomMethod.calculateLeastNearing(math.Vector3(9, 1, 0), BeaconLocationModel(xCoordinate: 4, yCoordinate: 5, zCoordinate: 0, distance: 3));
                },
                child: controller.isScanning.value ? const Text("Stop Scanning") : const Text("Start Scanning"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
