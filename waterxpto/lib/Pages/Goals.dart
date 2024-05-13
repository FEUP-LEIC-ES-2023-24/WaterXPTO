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
                  SingleChildScrollView(
                    child:FutureBuilder<bool>(
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
                          //TODO: Goals list not registered user
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
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
                  backgroundColor: Color(int.parse('0xFF027088')),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add new Goal',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
                        // TODO: Save the goal to the database
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

