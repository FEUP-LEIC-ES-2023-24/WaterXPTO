import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:vertical_prototype/NotificationController.dart';


class BackgroundServiceController {

  //Inicia o servico em background
  static Future<void> initializeBackgroundService() async {
    final service = FlutterBackgroundService();

    //Necessario para android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'notification_channel_id',
      'notification_channel_name',
      description: 'Channel used for custom notifications',
      importance: Importance.low,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    //Configura o servico -> chama a funcao onStart
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: 'notification_channel_id',
        foregroundServiceNotificationId: 15,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
      ),
    );
    service.startService();
  }

  //Funcao chamada quando o servico inicia
  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

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

    //Inicia o timer para notificacoes diarias
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      NotificationController.randomTipNotification();
    });
  }

  //Recebe a acao da notificacao
  static Future<void> listenToNotificationEvent() async {
    AwesomeNotifications().setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  //Funcao chamada quando a notificacao e clicada
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    Get.toNamed('/main');
  }

}