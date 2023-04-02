import 'package:ProFlow/navigation/my%20project/data/services/storage/services.dart';
import 'package:ProFlow/navigation/my%20project/modules/home/binding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'guest_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  //widgets??
  WidgetsFlutterBinding.ensureInitialized();
  //firebase
  await Firebase.initializeApp();
  //GetStorage
  await GetStorage.init();
  await Get.putAsync(() => StorageService().init());
  //technically portrait mode not wokring
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) => runApp(GetMaterialApp(
            title: 'ProFlow',
            home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (BuildContext context, snapshot) {
                  print('test');
                  if (snapshot.hasData) {
                    //logged in
                    return HomePage();
                  } else {
                    print('gp');
                    // not logged in
                    return GuestPage();
                  }
                }),
            initialBinding: HomeBinding(),
            builder: EasyLoading.init(),
          )));
}
