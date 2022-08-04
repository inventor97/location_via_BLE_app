import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:location_via_ble_app/models/BeceonLocationModel.dart';
import '../controllers/controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 260,
                  height: 400,
                  color: Colors.grey,
                  child: Stack(
                    children: [
                      Positioned(top: 65, left: 5, child: Container(width: 113, height: 56.5, color: Colors.white)),
                      Positioned(top: 65, right: 5, child: Container(width: 113, height: 56.5, color: Colors.white)),
                      Positioned(bottom: 140, left: 5, child: Container(width: 113, height: 56.5, color: Colors.white)),
                      Positioned(bottom: 140, right: 5, child: Container(width: 113, height: 56.5, color: Colors.white)),
                      Positioned(bottom: 5, right: 20, child: Container(width: 82.35, height: 28, color: Colors.white)),
                      Positioned(bottom: 5, right: 105, child: Container(width: 55, height: 25, color: Colors.white)),
                      Positioned(bottom: 5, left: 45, child: Container(width: 45, height: 100, color: Colors.white)),
                      Positioned(bottom: 5, left: 5, child: Container(width: 38, height: 30, color: Colors.white)),
                      //beacons_coordinates
                      ...LocationModel.beaconsCoordinates.values
                          .map((e) => Positioned(
                              bottom: e.yCoordinate * 0.4706, left: e.xCoordinate * 0.4706, child: Container(width: 10, height: 10, color: e.color)))
                          .toList(),
                      //you location
                      Positioned(
                        bottom: controller.yCoordinate.value * 0.4706,
                        left: controller.xCoordinate.value * 0.4706,
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () {
                  controller.initScanBeacon();
                  // CalculationCoordinateHelper.calculateLocation([]);
                },
                child: const Text("Start Scanning"),
              ),
              ...controller.regionBeacons.keys
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "${controller.regionBeacons[e]!.macAddress} -> ${controller.regionBeacons[e]!.accuracy}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: LocationModel.beaconsCoordinates[controller.regionBeacons[e]!.macAddress]!.color,
                          ),
                        ),
                      ))
                  .toList(),
              Text("${controller.xCoordinate.value} : ${controller.yCoordinate.value}", style: const TextStyle(fontWeight: FontWeight.bold),),
            ],
          ),
        ));
  }
}
