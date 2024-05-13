import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Controller/database.dart';
import '../models/User.dart';

class Goals extends StatefulWidget {


  @override
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  final AuthService authService = AuthService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
        children: [
          Center(
              child:  Column(
                children: <Widget>[
                    FutureBuilder<bool>(
                      future: authService.isUserLoggedIn(),
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.data == true) {
                          //TODO: Goals list registered user
                          return const CircularProgressIndicator();
                        } else {
                          // Goals list not registered user
                          return Column(
                            children: [
                              Container(
                                height: screenHeight * 0.7,
                                child: FutureBuilder<List<Map<String, dynamic>>>(
                                  future: _dbHelper.queryAllGoals(),
                                  builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      return ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          Map<String, dynamic> goal = snapshot.data![index];
                                          return GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Theme(
                                                    data: Theme.of(context).copyWith(dialogBackgroundColor: Color(0xFF029cbd)),
                                                    child: AlertDialog(
                                                      title: Text(goal['name'], style: const TextStyle(color: Colors.white)),
                                                      content: SingleChildScrollView(
                                                        child: ListBody(
                                                          children: <Widget>[
                                                            Text('Goal: ${goal['type']}', style: const TextStyle(color: Colors.white)),
                                                            Text('Value: ${goal['value']}', style: const TextStyle(color: Colors.white)),
                                                            Text('From: ${goal['creationDate']}', style: const TextStyle(color: Colors.white)),
                                                            Text('Until: ${goal['deadline']}', style: const TextStyle(color: Colors.white)),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: const Text('Close', style: TextStyle(color: Colors.white)),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              width: screenWidth * 0.14,
                                              margin: const EdgeInsets.all(10.0),
                                              padding: const EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                color: Color(int.parse('0xFF027088')),
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Text(goal['name'], style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white)),
                                                      Text('Deadline: ${goal['deadline']}', style: const TextStyle(color: Colors.white)),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Text('${goal['value']}', style: const TextStyle(color: Colors.white)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                )
                              ),
                            ],
                          );
                        }
                      },
                    ),
                ],
              ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: screenHeight * 0.03),
              height: screenHeight * 0.09,
              width: screenWidth * 0.5,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const GoalsDialog();
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(int.parse('0xff81d6e9')),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Add new Goal',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(int.parse('0xFF027088')),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
}

class GoalsDialog extends StatefulWidget {
  const GoalsDialog({super.key});

  @override
  _GoalsDialogState createState() => _GoalsDialogState();

}

class _GoalsDialogState extends State<GoalsDialog> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();
  String _goalName = '';
  DateTime _deadline = DateTime.now();
  String _goalType = 'Use less daily water';
  double _goalValue = 0.0;

  final List<String> _goalTypes = [
    'Use less daily water',
    'Spend at most X liters',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add new Goal'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Goal name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _goalName = value!;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Goal value',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal value';
                  }
                  return null;
                },
                onSaved: (value) {
                  _goalValue = double.parse(value!);
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _goalType.isEmpty ? null : _goalType,
                items: _goalTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _goalType = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Goal Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _deadline,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _deadline) {
                    setState(() {
                      _deadline = picked;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(int.parse('0xFF027088')),
                ),
                child: Text('Select deadline date', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 10),
              Text(
                'Selected deadline: ${_deadline.toIso8601String().substring(0, 10)}',
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _dbHelper.insertGoal({
                          'name': _goalName,
                          'value': _goalValue,
                          'type': _goalType,
                          'deadline': _deadline.toIso8601String().substring(0, 10),
                          'creationDate': DateTime.now().toIso8601String().substring(0, 10),
                          'value': 0.0,
                        });
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                    ),
                    child: const Text('Create', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

