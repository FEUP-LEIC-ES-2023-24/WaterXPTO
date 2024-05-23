import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waterxpto/models/User.dart';
import 'package:waterxpto/models/WaterActivity.dart';
import 'package:waterxpto/models/WaterConsumption.dart';
import '../Statistics/StatisticsContent.dart';
import '../Controller/database.dart';
import '../models/Goal.dart';
import 'Goals.dart';
import 'Settings.dart';
import '../Controller/WaterSpentNotifier.dart';
import 'dart:async';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  int _selectedIndex = 0;

  static  final List<Widget> _widgetOptions = <Widget>[
    const HomeContent(),
    StatisticsContent(),
    Goals(),
    SettingsPage(),
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
        title: const Text('WaterXPTO', style: TextStyle(color: Colors.black)),
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

  final AuthService authService = AuthService();
  final WaterConsumptionService waterConsumptionService = WaterConsumptionService();
  final WaterActivityService waterActivityService = WaterActivityService();

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

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
  String message = "";

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  Future<void> _initializeState() async {
    message = messages[Random().nextInt(messages.length)];
    await updateTodayLitersSpent();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double factor = screenHeight < 800 ? 0.25 : 0.4;

    return Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(top: 0.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.115,
                decoration: BoxDecoration(
                  color: Color(int.parse('0xFF027088')),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
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

            FutureBuilder<bool>(
              future: authService.isUserLoggedIn(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data == true) {
                  return Consumer<WaterSpentNotifier>(
                    builder: (context, waterSpentNotifier, child) {
                      return Text('${waterSpentNotifier.todayLitersSpent.toStringAsFixed(2)} L today', style: TextStyle(fontSize: 25.0 * screenHeight / 600, fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.black));
                    },
                  );
                } else {
                  return StreamBuilder<double>(
                    stream: _dbHelper.waterSpentStream,
                    initialData: 0.0,
                    builder: (BuildContext context, AsyncSnapshot<double> streamSnapshot) {
                      if (streamSnapshot.connectionState == ConnectionState.waiting) {
                        return ElevatedButton(
                          onPressed: () async {
                            int id = await _dbHelper.insertWaterConsumption({'waterSpent': 0.0});
                            await _dbHelper.deleteWaterConsumption(id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white60,
                            side: const BorderSide(color: Colors.white10, width: 3),
                          ),
                          child: const Text('Load Water Spent', style: TextStyle(fontSize: 15, fontFamily: 'Montserrat', color: Colors.black)),
                        );
                      } else if (streamSnapshot.hasError) {
                        return Text('Error: ${streamSnapshot.error}');
                      } else {
                        return Text('${streamSnapshot.data?.toStringAsFixed(2)} L today', style: TextStyle(fontSize: 25.0 * screenHeight / 600, fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.black));
                      }
                    },
                  );}
                },
              ),
            Flexible(
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

  Future<void> updateTodayLitersSpent() async {
    if (await AuthService().isUserLoggedIn()) {
      List<WaterConsumption> todayValues = await waterConsumptionService.getUserWaterConsumptionsInADay(authService.getCurrentUser()!.userID, DateUtils.dateOnly(DateTime.now()));
      double sum = 0;

      // Perform asynchronous work outside of setState()
      await Future.forEach(todayValues, (val) async {
        WaterActivity? w = await waterActivityService.getWaterActivityByID(val.waterActivityID);
        sum += (w!.waterFlow * (val.duration.toDouble() / 60));
      });

      WaterSpentNotifier.of(context, listen: false).setTodayLitersSpent(sum);
    }
  }
}

//------------ Timer Dialog ---------------------

class TimerDialog extends StatefulWidget {
  const TimerDialog({super.key});

  @override
  _TimerDialogState createState() => _TimerDialogState();
}

class _TimerDialogState extends State<TimerDialog> {

  final WaterConsumptionService waterService = WaterConsumptionService();
  final AuthService authService = AuthService();
  final WaterActivityService waterActivityService = WaterActivityService();

  bool _timerRunning = false;
  bool _timerPaused = false;
  int _timerCount = 0; // in seconds
  double _waterSpent = 0.0; // in liters


  late String _selectedUsageType = "";
  List<String> _usageTypes = [];

  @override
  void initState() {
    super.initState();
    _loadUsageTypes(); // Call the async method inside initState
  }

  Future<void> _loadUsageTypes() async {
    await waterActivityService.getAllWaterActivityNames().then((
        List<String> types) {
      setState(() {
        _usageTypes = types;
        _selectedUsageType = types.first;
      });
    }).catchError((error) {
      print('Error loading usage types: $error');
    });
  }


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
    setState(() {

    });

    return Dialog(
      backgroundColor: Color(0xffe6f4f1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        height: MediaQuery.of(context).size.height * 0.35,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Timer: $formattedTime',
              style: TextStyle(fontSize: 18, color: Color(0xFF003d3e)),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedUsageType,
              items: _usageTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type, style: TextStyle(color: Color(0xFF003d3e))),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedUsageType = newValue!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Usage Type',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _startOrResumeTimer();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _timerRunning && !_timerPaused ? Colors.yellow : Colors.green,
                  ),
                  child: Text(
                      _timerRunning && !_timerPaused ? 'Pause' : 'Start', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    _stopTimer();
                  },
                  child: const Text('Stop', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Water Spent: ${_waterSpent.toStringAsFixed(1)} liters',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF003d3e)),
            ),
          ],
        ),
      ),
    );
  }

  Timer? _timer;
  double currentWaterFlow = 0;

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

  void _startTimer() async {
    const oneSecond = Duration(seconds: 1);
    WaterActivity? waterActivity = await waterActivityService.getWaterActivity(
        _selectedUsageType);
    currentWaterFlow = waterActivity!.waterFlow;
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (!_timerPaused) {
          _timerCount++;
          _waterSpent = (currentWaterFlow) * _timerCount / 60.0;
        }
      });
    });
  }

  void _stopTimer() async {
    setState(() {
      _timer?.cancel();
      _timerRunning = false;
      _timerPaused = true;
    });

    if (_waterSpent != 0) {
      bool isLoggedIn = await authService.isUserLoggedIn();
      if (isLoggedIn) {
        WaterActivity? waterActivity = await waterActivityService.getWaterActivity(_selectedUsageType);
        WaterConsumption waterConsumption = WaterConsumption(
            waterActivityID: waterActivity!.id,
            userID: authService.getCurrentUser()!.userID,
            finishDate: DateTime.now(),
            duration: _timerCount);
        await waterService.addWaterConsumption(waterConsumption);
        await WaterSpentNotifier.of(context, listen: false).updateTodayLitersSpent();
        Future<List<Goal>> goals = GoalService().getAllGoals();
        for (var goal in await goals) {
          goal.value += _waterSpent;
          await GoalService().updateGoal(goal);
        }
      } else {
        await _updateDatabaseWithWaterSpent(_waterSpent);
      }
    }

    setState(() {
      _timerCount = 0;
      _waterSpent = 0.0;
    });
  }
}
//---------------------------------------------------------

Future<void> _updateDatabaseWithWaterSpent(double waterSpent) async {
  var db = DatabaseHelper.instance;
  int id = await db.insertWaterConsumption({'waterSpent': waterSpent});
  print('Water spent updated in database with id: $id');

  List<Map<String, dynamic>> goals = await db.queryAllGoals();
  print('Updating goals with water spent: $waterSpent\n');
  for (var goal in goals) {
    double new_value = goal['value'] + waterSpent;

    Map<String, dynamic> newGoal = Map.from(goal);
    newGoal['value'] = new_value;

    await db.updateGoal(newGoal);
  }
}

Widget customButton(IconData icon, String label, BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  double factor = screenHeight < 800 ? 0.08 : 0.3;
  return Container(
    height: screenHeight * factor,
    width: screenHeight * factor,
    child: ElevatedButton(
      onPressed: () {
        if (label == 'Timer') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const TimerDialog();
            },
          );
        } else {
          showCustomDialog(context, label, icon);
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

void showCustomDialog(BuildContext context, String title, IconData icon) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(title: title, icon: icon);
    },
  );
}

class CustomDialog extends StatefulWidget {
  final String title;
  final IconData icon;

  CustomDialog({required this.title, required this.icon});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  int minutes = 0;
  int seconds = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xffe6f4f1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF003d3e)),
              ),
              Icon(
                widget.icon,
                size: 100,
                color: Color(0xFF003d3e),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        minutes = int.tryParse(value) ?? 0;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Minutes',
                        labelStyle: const TextStyle(color: Color(0xFF003d3e)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        seconds = int.tryParse(value) ?? 0;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Seconds',
                        labelStyle: const TextStyle(color: Color(0xFF003d3e)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (await AuthService().isUserLoggedIn()) {
                    WaterActivity? waterActivity = await WaterActivityService().getWaterActivity(widget.title);
                    double waterSpent = (waterActivity!.waterFlow * (minutes + seconds / 60));
                    WaterConsumption waterConsumption = WaterConsumption(
                        waterActivityID: waterActivity.id,
                        userID: AuthService().getCurrentUser()!.userID,
                        finishDate: DateTime.now(),
                        duration: minutes * 60 + seconds);
                    await WaterConsumptionService().addWaterConsumption(waterConsumption);
                    await WaterSpentNotifier.of(context, listen: false).updateTodayLitersSpent();
                    List<Goal> goals = await GoalService().getAllGoals();
                    for (var goal in goals) {
                      goal.value += waterSpent;
                      await GoalService().updateGoal(goal);
                    }
                  } else {
                    WaterActivityService waterActivityService = WaterActivityService();
                    WaterActivity? waterActivity = await waterActivityService.getWaterActivity(widget.title);
                    double waterSpent = (waterActivity!.waterFlow * (minutes + seconds / 60));
                    _updateDatabaseWithWaterSpent(waterSpent);
                  }

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Insert', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
