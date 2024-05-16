import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'NotificationController.dart';
import 'database.dart';


class BackgroundServiceController {
  static bool _notifications = true;

  static bool get notifications => _notifications;

  BackgroundServiceController._internal();
  static final BackgroundServiceController _instance = BackgroundServiceController._internal();

  factory BackgroundServiceController() {
    return _instance;
  }

  void updateStatus(bool status) {
    _notifications = status;
    restartBackgroundService();
  }

  void restartBackgroundService() async {
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (notifications) {
        await service.startService();
    } else {
        service.invoke("stopService");
    }
  }
}

//Inicia o servico em background
Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidNotificationChannel channelDaily = AndroidNotificationChannel(
    'daily_tips',
    'Daily Tips',
    description: 'Channel used for random daily tips',
    importance: Importance.max,
  );


  //Inicializa as notificacoes
  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  //Cria o canal de notificacao
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channelDaily);

  //Configura o servico -> chama a funcao onStart
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: false,
      notificationChannelId: 'daily_tips',
      foregroundServiceNotificationId: 15,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
    ),
  );
  service.startService();
}

//Recebe a acao da notificacao
Future<void> listenToNotificationEvent() async {
  AwesomeNotifications().setListeners(onActionReceivedMethod: onActionReceivedMethod);
}

//Funcao chamada quando a notificacao e clicada
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  Get.toNamed('/main');
}

//Funcao chamada quando o servico inicia
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  DatabaseHelper _dbHelper = DatabaseHelper.instance;

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

    //Inicia o timer para notificacoes
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      NotificationController.randomTipNotification();

      Future<List<Map<String, dynamic>>> goals = _dbHelper.queryAllGoals();
      for (var goal in await goals) {
        if (goal['deadline'] == DateTime.now().toIso8601String().substring(0, 10)) {
          Future<bool> completedSuccessfully = _dbHelper.verifyGoal(goal);
          NotificationController.goalCompletedNotification(goal, completedSuccessfully);
          _dbHelper.deleteGoal(goal['id']);
        }
      }
    });
}