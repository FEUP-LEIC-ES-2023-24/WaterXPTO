import 'package:flutter/material.dart';
import 'Pages/MainMenu.dart';
import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'Controller/NotificationController.dart';
import 'Controller/BackgroundServiceController.dart';
import 'package:provider/provider.dart';
import 'database.dart';

Future<void> addUser() async {
  var db = DatabaseHelper.instance;
  List<Map<String, dynamic>> users = await db.queryAllUsers();
  if (users.isEmpty) {
    await db.insertUser({
      'name': '',
      'birthDate': '',
      'email': '',
      'nationality': '',
    });
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeBackgroundService();
  await NotificationController.initializeNotifications();
  await addUser();
  runApp(MyApp());
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
