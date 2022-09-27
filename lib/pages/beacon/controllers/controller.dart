import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:location_via_ble_app/models/BeaconLocationModel.dart';
import 'package:location_via_ble_app/services/StorageService.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../BaseController.dart';

class BeaconController extends BaseController {
  final storage = Get.find<StorageService>();

  final TextEditingController beaconName = TextEditingController();
  final TextEditingController xCoordinate = TextEditingController();
  final TextEditingController yCoordinate = TextEditingController();
  final TextEditingController zCoordinate = TextEditingController();
  final TextEditingController uuid = TextEditingController();
  var uuidMask = MaskTextInputFormatter(mask: '########-####-####-####-############', filter: {"#": RegExp(r'[0-9a-fA-F]')});

  final formKey = GlobalKey<FormState>();

  void addBeacon() {
    if(formKey.currentState!.validate()) {
      if(storage.beacons.every((p0) => p0.uuid != uuid.text)) {
        try {
          storage.beacons.add(BeaconLocationModel(
            name: beaconName.text,
            xCoordinate: double.parse(xCoordinate.text),
            yCoordinate: double.parse(yCoordinate.text),
            zCoordinate: double.parse(zCoordinate.text),
            uuid: uuid.text,
          ));
        } catch (e) {
          Get.snackbar("Error", e.toString());
        } finally {
          beaconName.text = "";
          xCoordinate.text = "";
          yCoordinate.text = "";
          zCoordinate.text = "";
          uuid.text = "";
          storage.saveBeacons();
        }
      } else {
        Get.snackbar("Error", "This UUID Beacon already exist");
      }
    }
  }

  void editBeacon(BeaconLocationModel beacon) {
    storage.beacons.removeWhere((element) => element.uuid == beacon.uuid);
    beaconName.text = beacon.name ?? "";
    xCoordinate.text = beacon.xCoordinate.toString();
    yCoordinate.text = beacon.yCoordinate.toString();
    zCoordinate.text = beacon.zCoordinate.toString();
    uuid.text = beacon.uuid ?? "";
  }

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'required field';
    } else {
      return null;
    }
  }

  String? validateUUID(String? value) {
    if (value == null || value.isEmpty) {
      return 'required field';
    } else if (RegExp(r'^(([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12})$').hasMatch(value)) {
      return null;
    } else {
      return 'invalid uuid';
    }
  }
}
