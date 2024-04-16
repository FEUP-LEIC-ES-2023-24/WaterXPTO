import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'NotificationController.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WaterXPTO', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/WaterDrop2.png', // Assuming the image file is in the assets folder
              width: 200, // Adjust width as needed
              height: 200, // Adjust height as needed
            ),
            SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              padding: EdgeInsets.all(10.0),
              children: [
                CustomButton(text: 'Shower'),
                CustomButton(text: 'Hands'),
                CustomButton(text: 'Dishes'),
                CustomButton(text: 'Plants'),
                CustomButton(text: 'Clothes'),
                CustomButton(text: 'Timer'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



class CustomButton extends StatelessWidget {
  final String text;

  const CustomButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
          //Apenas para teste
          AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
            if (!isAllowed) {NotificationController.requestNotificationPermission(context);}
          });
        },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
