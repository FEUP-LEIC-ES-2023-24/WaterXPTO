import 'package:flutter/material.dart';
import '../BackgroundServiceController.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationSettings extends StatefulWidget {
  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool notifications = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  void _checkNotificationPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (isAllowed) {
      setState(() {
        notifications = BackgroundServiceController.notifications;
      });
    } else {
      setState(() {
        notifications = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Notifications:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height < 800 ? 12 : 15,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'By pressing the button below, you will enable or disable all notifications. That includes daily notifications, goals notifications and challenges notifications.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height < 800 ? 12 : 15,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Color(int.parse('0xFF027088')),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: SwitchListTile(
                title: Text('Notifications', style: TextStyle(color: Colors.white)),
                activeColor: Colors.white,
                value: notifications,
                onChanged: (bool value) {
                  setState(() {
                    notifications = value;
                    BackgroundServiceController().updateStatus(value);
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}