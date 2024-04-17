import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'Statistics/StatisticsContent.dart';
import 'NotificationController.dart';
import 'dart:async';

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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img/WaterDrop2.png',
            width: 200,
            height: 200,
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
        if (text == 'Timer') {
          _showTimerDialog(context);
        } else {
          // Handle other button clicks here
          AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
            if (!isAllowed) {
              AwesomeNotifications().requestPermissionToSendNotifications();
            }
          });
        }
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

  void _showTimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TimerDialog();
      },
    );
  }
}



//------------ Timer Dialog ---------------------

class TimerDialog extends StatefulWidget {
  @override
  _TimerDialogState createState() => _TimerDialogState();
}

class _TimerDialogState extends State<TimerDialog> {
  bool _timerRunning = false;
  bool _timerPaused = false;
  int _timerCount = 0; // in seconds
  double _waterSpent = 0.0; // in liters

  String _selectedUsageType = 'Shower';
  List<String> _usageTypes = ['Shower', 'Washing Dishes', 'Hands', 'Plants', 'Clothes'];
  Map<String, double> _usageRates = {
    'Shower': 9.5, // Liters per minute
    'Washing Dishes': 5.0,
    'Hands': 2.0,
    'Plants': 0.5,
    'Clothes': 15.0,
  };

  @override
  Widget build(BuildContext context) {
    //format time to be like 1m30s
    String formattedTime;
    if (_timerCount >= 60) {
      int minutes = _timerCount ~/ 60;
      int seconds = _timerCount % 60;
      formattedTime = '$minutes minutes $seconds seconds';
    } else {
      formattedTime = '$_timerCount seconds';
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: EdgeInsets.all(20.0),
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Timer: $formattedTime',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedUsageType,
              items: _usageTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedUsageType = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Usage Type',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _startOrResumeTimer();
                  },
                  child: Text(_timerRunning && !_timerPaused ? 'Pause' : 'Start'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _stopTimer();
                  },
                  child: Text('Stop'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Water Spent: ${_waterSpent.toStringAsFixed(1)} liters', // Round to 1 decimal unit
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Bigger and bold font
            ),
          ],
        ),
      ),
    );
  }

  void _startOrResumeTimer() {
    setState(() {
      if (!_timerRunning) {
        _timerRunning = true;
        _timerPaused = false;
        _startTimer();
      } else {
        _timerPaused = !_timerPaused;
        if (!_timerPaused) {
          _startTimer();
        }
      }
    });
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (!_timerPaused) {
          _timerCount++;
          _waterSpent = (_usageRates[_selectedUsageType] ?? 0.0) * _timerCount / 60.0; // Conversion from seconds to minutes
        }
      });
    });
  }

  void _stopTimer() {
    setState(() {
      _timerRunning = false;
      _timerPaused = true;
      _timerCount = 0;
      _waterSpent = 0.0;
    });
  }
}


