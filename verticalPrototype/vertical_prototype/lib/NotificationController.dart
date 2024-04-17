import 'dart:math';

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

  static void randomTipNotification() {
    final List<String> tips = [
      "Tap off when you brush! Save 200 gallons/month. 💧",
      "Drip, drip, waste! Fix leaks, save gallons. 💦",
      "Reuse rinse water for plants. Double duty! 🌱",
      "Shorten showers to save water. 5 minutes is enough! 🚿",
      "Harvest rain, reduce strain. Nature's gift! 🌧️",
      "Full loads only! Save water and energy. 👕",
      "Water plants in the morning. Less evaporation! 🌞",
      "Sweep, don't spray! Save water outdoors. 🧹",
      "Upgrade to water-efficient appliances. Modernize, minimize! 🔄",
      "Water plants deeply, less often. Roots grow strong! 🌿",
      "Pool perfect! Cover up, cut evaporation. 🏊‍♂️",
      "Thirsty plants? Water early, save sweat. 🌿",
      "Water wisely, save water, save life. 🌍",
      "Drink up, don't drip! Fix that faucet, save a sip. 💧",
      "Water covers about 71% of the Earth's surface, but only 1% is available for human use! 🌍",
      "A five-minute shower uses about 10-25 gallons of water, while a bath can use 30-50 gallons! 🚿",
      "A running toilet can waste up to 200 gallons of water per day! 🚽",
      "The water footprint of a single hamburger is equivalent to over 600 gallons of water! 🍔",
    ];

    final Random random = Random();
    int randomIndex = random.nextInt(tips.length);

    AwesomeNotifications().createNotification(
        content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        actionType: ActionType.Default,
        title: 'Did you know? 🤔',
        body: tips[randomIndex],
        category: NotificationCategory.Reminder,
      )
    );
  }
}
