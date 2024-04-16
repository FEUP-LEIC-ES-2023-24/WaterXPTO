import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationController {

  //Faz pedido de permissao
  static Future<bool> requestNotificationPermission(BuildContext context) async {
    bool userAuthorized = false;
    //Pop up para pedir permissao
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Get Notified!',
                style: Theme.of(context).textTheme.titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/img/animated-bell.gif',
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                    'Allow Notifications!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Deny',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    userAuthorized = true;
                    Navigator.of(ctx).pop(); //Remove o pop up
                  },
                  child: Text(
                    'Allow',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.deepPurple),
                  )),
            ],
          );
        });
    return userAuthorized && await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  static void randomTipNotification() {}
}
