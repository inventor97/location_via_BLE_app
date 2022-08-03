import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'AppBinding.dart';
import 'AppPages.dart';
import 'AppRoutes.dart';
import 'i18n/Messages.dart';
import 'themes/default.dart';

void main() async {
  await GetStorage.init();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AppName',
      translations: Messages(),
      locale: Messages.defaultLang,
      debugShowCheckedModeBanner: false,
      theme: kDefaultTheme,
      themeMode: ThemeMode.light,
      getPages: AppPages.routes,
      initialRoute: AppRoutes.BASE,
      initialBinding: AppBinding(),
    );
  }
}
