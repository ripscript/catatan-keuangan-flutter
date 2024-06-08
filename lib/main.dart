import 'dart:async';
import 'dart:ffi';

import 'package:catatan_keuangan/models/user.dart';
import 'package:catatan_keuangan/screens/create_recap_screen.dart';
import 'package:catatan_keuangan/screens/home_screen.dart';
import 'package:catatan_keuangan/screens/intro_screen.dart';
import 'package:catatan_keuangan/screens/loading_screen.dart';
import 'package:catatan_keuangan/services/database_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:catatan_keuangan/providers/user_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> _initDeviceType() async {
      var deviceInfo = DeviceInfoPlugin();
      String deviceName;
      bool isAndroid;

      if (Theme.of(context).platform == TargetPlatform.android) {
        var androidInfo = await deviceInfo.androidInfo;
        deviceName = androidInfo.model ?? "Unknown Android device";
        isAndroid = true;
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        var iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.name ?? "Unknown iOS device";
        isAndroid = false;
      } else {
        deviceName = "Unknown device";
        isAndroid = false;
      }

      return {'deviceName': deviceName, 'isAndroid': isAndroid};
    }

    Future<bool> _requestStoragePermission() async {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      return status.isGranted;
    }

    _requestStoragePermission().then((value) {});

    return FutureBuilder<Map<String, dynamic>>(
      future: _initDeviceType(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          var initialRoute = '/intro';
          var userProvider = UserProvider();
          return FutureBuilder<User?>(
            future: userProvider.getUserLogin(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.done) {
                if (userSnapshot.data == null) {
                  userProvider.addUser(snapshot.data!['isAndroid'], true,
                      snapshot.data!['deviceName']);
                } else if (!userSnapshot.data!.intro) {
                  initialRoute = '/home';
                }

                return FutureBuilder(
                  future: Future.delayed(Duration(seconds: 0)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return _buildApp(context, initialRoute);
                    } else {
                      return LoadingScreen();
                    }
                  },
                );
              }
              return LoadingScreen();
            },
          );
        }
        return LoadingScreen();
      },
    );
  }

  Widget _buildApp(BuildContext context, String initialRoute) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: initialRoute,
        routes: {
          '/intro': (context) => IntroScreen(),
          '/home': (context) => HomeScreen(),
          '/create_recap': (context) => CreateRecapScreen(),
        },
      ),
    );
  }
}
