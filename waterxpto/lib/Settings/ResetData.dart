import 'package:flutter/material.dart';
import 'package:waterxpto/Controller/database.dart';

class ResetData extends StatefulWidget {
  @override
  _ResetDataState createState() => _ResetDataState();
}

class _ResetDataState extends State<ResetData> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Data'),
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
                      'Reset Data:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height < 800 ? 12 : 15,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'By pressing the button below, all your data will be erased and you will have to start over. Are you sure you want to proceed?',
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
          Center(
              child: TextButton(
                onPressed: () {
                  DatabaseHelper.instance.resetDatabase();
                  DatabaseHelper.instance.insertUser({
                    'name': '',
                    'birthDate': '',
                    'email': '',
                  });
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                child: Text(
                  'Reset Data',
                  style: TextStyle(color: Colors.white),
                ),
              )
          ),
        ],
      ),
    );
  }
}