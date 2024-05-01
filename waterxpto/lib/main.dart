import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:waterxpto/LoginScreen.dart';
import 'package:waterxpto/models/WaterActivity.dart';
import 'MainMenu.dart';
import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'NotificationController.dart';
import 'BackgroundServiceController.dart';
import 'package:provider/provider.dart';
import 'WaterSpentNotifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BackgroundServiceController.initializeBackgroundService();
  await NotificationController.initializeNotifications();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );

  WaterActivityService waterActivityService = WaterActivityService();
  //waterActivityService.addWaterActivity(WaterActivity(name: "Shower", description: "Showering wastes a lot more water than it seems", waterFlow: 10.0));

  runApp(
    ChangeNotifierProvider(
      create: (context) => WaterSpentNotifier(waterSpent: 0.0),
      child: MyApp(),
    ),
  );

}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _AppState();

}

class _AppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    //Verifica se as notificações estao ativas
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {AwesomeNotifications().requestPermissionToSendNotifications();}
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WaterXPTO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
