import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_via_ble_app/models/BeaconLocationModel.dart';
import 'package:location_via_ble_app/pages/beacon/controllers/controller.dart';

class BeaconListTile extends StatelessWidget {
  const BeaconListTile({
    Key? key,
    required this.beacon,
  }) : super(key: key);

  final BeaconLocationModel beacon;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BeaconController>();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        controller.editBeacon(beacon);
      },
      onLongPress: () {
        Get.defaultDialog(
          title: "Delete Beacon",
          content: const Text("Are you sure to delete beacon"),
          cancel: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Cancel"),
          ),
          confirm: TextButton(
            onPressed: () {
              Get.back();
              controller.storage.beacons.removeWhere((element) => element.uuid == beacon.uuid);
            },
            child: const Text("Delete"),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              offset: Offset(5, 5),
              blurRadius: 7,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Beacon Identifier:", style: TextStyle(fontSize: 13, color: Colors.lightBlueAccent)),
            const SizedBox(height: 3),
            Text(
              beacon.name ?? "Beacon Name",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Beacon UUID:", style: TextStyle(fontSize: 13, color: Colors.lightBlueAccent)),
            const SizedBox(height: 3),
            Text(beacon.uuid ?? "", style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 10),
            const Text("Beacon Cordinates:", style: TextStyle(fontSize: 13, color: Colors.lightBlueAccent)),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("x: ${beacon.xCoordinate}", style: const TextStyle(fontSize: 15)),
                const SizedBox(width: 10.0),
                Text("y: ${beacon.yCoordinate}", style: const TextStyle(fontSize: 15)),
                const SizedBox(width: 10.0),
                Text("z: ${beacon.zCoordinate}", style: const TextStyle(fontSize: 15)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
