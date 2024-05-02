import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database.dart';
import 'Challenge.dart';
import 'Goals.dart';
import 'Settings.dart';
import '../Statistics/StatisticsContent.dart';
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
    Challenge(),
    Goals(),
    Settings(),
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
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle_sharp),
            label: 'Challenges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_sharp),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
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
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  Stream<double>? _waterSpentStream;
  final List<String> messages = [
    "Turn off faucets tightly after use, fix leaks promptly and opt for shorter showers. Small actions yield big savings over time.",
    "Reuse water from washing fruits/veggies to water plants. Every drop counts!",
    "Choose drought-resistant plants for your garden to minimize water usage. Sustainable landscaping saves resources.",
    "Use a broom instead of a hose to clean driveways and sidewalks. It saves water and energy. Small changes make a big impact!",
    "Collect rainwater in barrels for outdoor use. It's eco-friendly and reduces reliance on municipal water sources.",
    "Use a pool cover to reduce evaporation and keep your pool clean. It's an easy way to save water and energy.",
    "Use a dishwasher instead of hand-washing dishes to save water. It's a convenient way to conserve resources.",
    "Install a dual-flush toilet to reduce water usage. It's an eco-friendly way to save water and money.",
  ];

  @override
  void initState() {
    super.initState();
    _waterSpentStream = _dbHelper.waterSpentStream;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double factor = screenHeight < 800 ? 0.25 : 0.4;
    final Random random = Random();
    final String message = messages[random.nextInt(messages.length)];

    return Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 0.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.115,
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
                      fontSize: screenHeight < 800 ? calculateFontSize(message) / 1.25 : calculateFontSize(message) * 1.06,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight < 800 ? 0.05 : 0.025),
            Image.asset('assets/img/WaterDrop2.png', width: screenHeight * factor, height: screenHeight * factor),
            SizedBox(height: screenHeight < 800 ? 0.05 : 0.025),
            StreamBuilder<double>(
              stream: _waterSpentStream,
              builder: (BuildContext context, AsyncSnapshot<double> streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return ElevatedButton(
                    onPressed: () async {
                      int id = await _dbHelper.insertWaterConsumption({'waterSpent': 0.0});
                      await _dbHelper.deleteWaterConsumption(id);
                    },
                    child: Text('Load Water Spent', style: TextStyle(fontSize: 15, fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(int.parse('0xFF027088')), // Set the button color to teal
                    ),
                  );
                } else if (streamSnapshot.hasError) {
                  return Text('Error: ${streamSnapshot.error}');
                } else {
                  return Text('${streamSnapshot.data?.toStringAsFixed(2)} L today', style: TextStyle(fontSize: 25.0 * screenHeight / 600, fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.black));
                }
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 1.3,   //Tamanho
                  mainAxisSpacing: 10,     //Espaçamento vertical
                  crossAxisSpacing: 10,    //Espaçamento horizontal
                  children: <Widget>[
                    customButton(Icons.bathtub_outlined, 'Shower',context),
                    customButton(Icons.clean_hands_outlined, 'Hands',context),
                    customButton(Icons.bakery_dining_rounded, 'Dishes',context),
                    customButton(Icons.local_florist_outlined, 'Plants',context),
                    customButton(Icons.local_laundry_service_outlined, 'Clothes',context),
                    customButton(Icons.access_alarms_rounded, 'Timer',context),
                  ],
                ),
              ),
            ),
          ],
        )
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
              'Water Spent: ${_waterSpent.toStringAsFixed(1)} liters',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Timer? _timer;

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
        } else {
          _timer!.cancel();
        }
      }
    });
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (!_timerPaused) {
          _timerCount++;
          _waterSpent = (_usageRates[_selectedUsageType] ?? 0.0) * _timerCount / 60.0;
        }
      });
    });
  }

  void _stopTimer() {
    setState(() {
      _timerRunning = false;
      _timerPaused = true;
      _updateDatabaseWithWaterSpent(_waterSpent);
      _timerCount = 0;
      _waterSpent = 0.0;
      _timer?.cancel();
    });
  }
}

Future<void> _updateDatabaseWithWaterSpent(double waterSpent) async {
  var db = DatabaseHelper.instance;
  await db.insertWaterConsumption({'waterSpent': waterSpent});
}
//---------------------------------------------------------


Widget customButton(IconData icon, String label, BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  double factor = screenHeight < 800 ? 0.08 : 0.3;
  return Container(
    height: screenHeight * factor,
    width: screenHeight * factor,
    child: ElevatedButton(
      onPressed: () {
        if (label == 'Timer') {
          // Show timer dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return TimerDialog();
            },
          );
        }
      },
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
    ),
  );
}



double calculateFontSize(String message) {
  if (message.length > 125) {return 13.0;}
  if (message.length >= 100) {return 14.5;}
  if (message.length >= 75) {return 16.0;}
  return 20.0;
}
