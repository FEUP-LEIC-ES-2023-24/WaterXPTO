import 'package:flutter/material.dart';
import 'MainMenu.dart';
import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'NotificationController.dart';
import 'BackgroundServiceController.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BackgroundServiceController.initializeBackgroundService();
  runApp(const MyApp());
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
      if (!isAllowed) {NotificationController.requestNotificationPermission(context);}
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WaterXPTO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainMenu(),
    );
  }
}
