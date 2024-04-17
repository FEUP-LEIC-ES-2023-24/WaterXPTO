import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'Statistics/StatisticsContent.dart';
import 'NotificationController.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  int _selectedIndex = 0;

  static  List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    StatisticsContent(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WaterXPTO', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: _widgetOptions[_selectedIndex],


      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: 'Statistics',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),

    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final List<String> messages = [
    "Turn off faucets tightly after use, fix leaks promptly, and opt for shorter showers. Small actions can yield big water savings over time.",
    "Reuse water from washing fruits/veggies to water plants. Every drop counts!",
    "Choose drought-resistant plants for your garden to minimize water usage. Sustainable landscaping saves resources.",
    "Use a broom instead of a hose to clean driveways and sidewalks. It saves water and energy. Small changes make a big impact!",
    "Collect rainwater in barrels for outdoor use. It's eco-friendly and reduces reliance on municipal water sources.",
    "Use a pool cover to reduce evaporation and keep your pool clean. It's an easy way to save water and energy.",
    "Use a dishwasher instead of hand-washing dishes to save water. It's a convenient way to conserve resources.",
    "Install a dual-flush toilet to reduce water usage. It's an eco-friendly way to save water and money.",
  ];

  @override
  Widget build(BuildContext context) {
    final Random random = Random();
    final String message = messages[random.nextInt(messages.length)];

    return Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 0.0),
              child: Container(
                width: 353.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: Color(int.parse('0xFF027088')),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    message,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Color(int.parse('0xFFFFFFFF')),
                      fontSize: calculateFontSize(message),
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
            ),
            Image.asset('assets/img/WaterDrop2.png', width: 350.0, height: 350.0),
            Text('20L today', style: TextStyle(fontSize: 40.0, fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 10.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 1.3,   //Tamanho
                  mainAxisSpacing: 10,     //Espaçamento vertical
                  crossAxisSpacing: 10,    //Espaçamento horizontal
                  children: <Widget>[
                    customButton(Icons.bathtub_outlined, 'Shower'),
                    customButton(Icons.clean_hands_outlined, 'Hands'),
                    customButton(Icons.bakery_dining_rounded, 'Dishes'),
                    customButton(Icons.local_florist_outlined, 'Plants'),
                    customButton(Icons.local_laundry_service_outlined, 'Clothes'),
                    customButton(Icons.access_alarms_rounded, 'Timer'),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}

Widget customButton(IconData icon, String label) {
  return ElevatedButton(
    //Nada por agora
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Color(int.parse('0xFF027088')),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 18),
        Text(label),
      ],
    ),
  );
}


double calculateFontSize(String message) {
  if (message.length > 125) {return 13.0;}
  if (message.length >= 100) {return 14.5;}
  if (message.length >= 75) {return 16.0;}
  return 20.0;
}