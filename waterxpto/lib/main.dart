import 'package:flutter/material.dart';
import 'MainMenu.dart';
import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'NotificationController.dart';
import 'BackgroundServiceController.dart';
import 'package:provider/provider.dart';
import 'WaterSpentNotifier.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeBackgroundService();
  await NotificationController.initializeNotifications();
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
      home: const MainMenu(),
    );
  }
}
