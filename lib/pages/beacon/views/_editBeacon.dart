import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_via_ble_app/pages/beacon/controllers/controller.dart';
import 'package:location_via_ble_app/widgets/CustomInput.dart';

class EditBeacon extends StatelessWidget with PreferredSizeWidget {
  const EditBeacon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BeaconController>();
    return Form(
      key: controller.formKey,
      child: Container(
        color: Colors.grey.withOpacity(0.1),
        padding: const EdgeInsets.only(top: 45.0, right: 20, left: 20, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Adding New Beacon", style: TextStyle(fontWeight: FontWeight.bold)),
            CustomInput(
              labelText: "Beacon Name",
              controller: controller.beaconName,
              validator: controller.validate,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: CustomInput(
                  validator: controller.validate,
                  controller: controller.xCoordinate,
                  labelText: "x Coordinate",
                  keyboardType: TextInputType.number,
                )),
                const SizedBox(width: 15),
                Expanded(
                    child: CustomInput(
                  validator: controller.validate,
                  controller: controller.yCoordinate,
                  labelText: "y Coordinate",
                  keyboardType: TextInputType.number,
                )),
                const SizedBox(width: 15),
                Expanded(
                    child: CustomInput(
                  validator: controller.validate,
                  controller: controller.zCoordinate,
                  labelText: "z Coordinate",
                  keyboardType: TextInputType.number,
                )),
              ],
            ),
            CustomInput(
              labelText: "UUID",
              validator: controller.validateUUID,
              controller: controller.uuid,
              inputFormatters: [controller.uuidMask],
              textCapitalization: TextCapitalization.characters,
            ),
            CustomInput(
              labelText: "MAC Address",
              validator: controller.validateMAC,
              controller: controller.mac,
              inputFormatters: [controller.macAddressMask],
              textCapitalization: TextCapitalization.characters,
            ),
            ElevatedButton(
              onPressed: controller.addBeacon,
              child: const Text("Add new Beacon"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(380);
}
