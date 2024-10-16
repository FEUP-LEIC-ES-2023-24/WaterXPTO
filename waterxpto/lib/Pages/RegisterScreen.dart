import 'package:country_list_pick/support/code_country.dart';
import 'package:flutter/material.dart';
import '../Settings/CountrySelection.dart';
import 'LoginScreen.dart';
import 'MainMenu.dart';
import '../models/User.dart'; // Import your AuthService

class RegisterScreen extends StatefulWidget {
const RegisterScreen({Key? key}) : super(key: key);

@override
_RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  CountryCode? _selectedCountry;

  AuthService _authService = AuthService(); // Initialize your AuthService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
              ),
              child: ListTile(
                title: Text('Country', style: TextStyle(color: Colors.black)),
                subtitle: Text(_selectedCountry != null ? _selectedCountry!.name! : 'Select your country', style: TextStyle(color: Colors.black)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => CountrySelection(
                      onCountrySelected: (country) {
                        setState(() {
                          _selectedCountry = country;
                        });
                      },
                      initialSelection: _selectedCountry != null ? _selectedCountry!.code! : '',
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text;
                String password = _passwordController.text;
                String name = _nameController.text;
                String nationality = _selectedCountry != null ? _selectedCountry!.name! : 'Portugal';
                String region = _regionController.text;
                String result = await _authService.registerUser(
                email, password, name, nationality);
                if (result == "Registration successful") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } else {
                  // Handle error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result)),
                  );
                }
              },
              child: Text('Register'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
            child: Text('Already have an account? Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}