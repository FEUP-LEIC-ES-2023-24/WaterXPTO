import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'My Account:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text('Login / Sign in'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Login / Sign in page
            },
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'My Settings:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text('Notifications'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Notifications page
            },
          ),
          Divider(),
          ListTile(
            title: Text('Choose Country'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Choose Country page
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Help and Support:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text('Privacy Policy'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Privacy Policy page
            },
          ),
          Divider(),
          ListTile(
            title: Text('Terms and Conditions'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Terms and Conditions page
            },
          ),
          Divider(),
          ListTile(
            title: Text('About Us'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to About Us page
            },
          ),
        ],
      ),
    );
  }
}


