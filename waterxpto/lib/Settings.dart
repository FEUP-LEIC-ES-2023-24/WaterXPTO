import 'package:country_list_pick/support/code_country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Settings/AboutUs.dart';
import 'Settings/CountrySelection.dart';
import 'Settings/NotificationSettings.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}


class _SettingsState extends State<Settings> {
  CountryCode? selectedCountry;

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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationSettings()),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text('Country'),
            subtitle: Text(selectedCountry != null ? selectedCountry!.name! : 'Select your country'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => CountrySelection(
                  onCountrySelected: (country) {
                    setState(() {
                      selectedCountry = country;
                    });
                  },
                  initialSelection: selectedCountry != null ? selectedCountry!.code! : '',
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text('Reset Data'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {

            },
          ),
          Divider(),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Help and Support:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text('About Us'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUs()),
              );
            },
          ),
        ],
      ),
    );
  }
}