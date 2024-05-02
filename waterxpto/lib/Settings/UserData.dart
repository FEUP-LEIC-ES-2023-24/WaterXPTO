import 'package:country_list_pick/support/code_country.dart';
import 'package:flutter/material.dart';
import 'package:waterxpto/Settings/CountrySelection.dart';
import '../database.dart';

class UserData extends StatefulWidget {
  @override
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  final _formKey = GlobalKey<FormState>();
  String? name, birthDate, email;
  CountryCode? nationality;
  Future<Map<String, dynamic>>? userData;

  @override
  void initState() {
    super.initState();
    userData = fetchUserData();
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    var db = DatabaseHelper.instance;
    List<Map<String, dynamic>> users = await db.queryAllUsers();
    if (users.isNotEmpty) {
      return users.first;
    }
    return {
      'name': null,
      'birthDate': null,
      'email': null,
      'nationality': null,
    };
  }

  Future<void> updateUserData() async {
    var db = DatabaseHelper.instance;
    await db.updateUser({
      'name': name,
      'birthDate': birthDate,
      'email': email,
      'nationality': nationality?.name,
    });
    setState(() {
      userData = fetchUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder<Map<String, dynamic>>(
      future: userData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          Map<String, dynamic> user = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('User Data'),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          color: Color(int.parse('0xFF027088')),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          initialValue: user['name'] ?? '',
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Name',
                            filled: true,
                            labelStyle: TextStyle(color: Colors.white),
                            fillColor: Color(int.parse('0xFF027088')),
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSaved: (value) {
                            name = value;
                          },
                        ),
                      ),
                      SizedBox(height: 10),

                      Container(
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          color: Color(int.parse('0xFF027088')),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          initialValue: user['birthDate'] ?? '',
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Birth Date',
                            labelStyle: TextStyle(color: Colors.white),
                            fillColor: Color(int.parse('0xFF027088')),
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSaved: (value) {
                            birthDate = value;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          color: Color(int.parse('0xFF027088')),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          initialValue: user['email'] ?? '',
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.white),
                            fillColor: Color(int.parse('0xFF027088')),
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSaved: (value) {
                            email = value;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          color: Color(int.parse('0xFF027088')),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text('Country', style: TextStyle(color: Colors.white)),
                          subtitle: Text(nationality != null ? nationality!.name! : 'Select your country', style: TextStyle(color: Colors.white)),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => CountrySelection(
                                onCountrySelected: (country) {
                                  setState(() {
                                    nationality = country;
                                  });
                                },
                                initialSelection: nationality != null ? nationality!.code! : '',
                              ),
                            );
                          },
                        ),
                      ),


                      ElevatedButton(
                        child: Text('Submit', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            updateUserData();
                            Navigator.pop(context);
                          }
                        },
                      ),
                      ElevatedButton(
                        child: Text('Cancel', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              )
            ),
          );
        }
      },
    );
  }
}
