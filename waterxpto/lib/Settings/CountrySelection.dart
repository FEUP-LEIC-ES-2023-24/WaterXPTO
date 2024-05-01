import 'package:flutter/material.dart';
import 'package:country_list_pick/country_list_pick.dart';

class CountrySelection extends StatefulWidget {
  final Function(CountryCode) onCountrySelected;
  final String initialSelection;

  CountrySelection({required this.onCountrySelected, required this.initialSelection});

  @override
  _CountrySelectionState createState() => _CountrySelectionState();
}

class _CountrySelectionState extends State<CountrySelection> {
  CountryCode? tempSelectedCountry;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select your country', style: TextStyle(color: Color(int.parse('0xFF027088')))),
      backgroundColor: Colors.white,
      content: Container(
        width: double.maxFinite,
        child: CountryListPick(
          initialSelection: widget.initialSelection,
          pickerBuilder: (context, CountryCode? countryCode) {
            return Row(
              children: [
                Image.asset(
                  countryCode!.flagUri!,
                  package: 'country_list_pick',
                  width: 32,
                ),
                SizedBox(width: 8.0),
                Text(countryCode.name!, style: TextStyle(color: Color(int.parse('0xFF027088')))),
              ],
            );
          },
          onChanged: (CountryCode? code) {
            setState(() {
              tempSelectedCountry = code;
            });
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('CANCEL', style: TextStyle(color: Color(int.parse('0xFF027088')))),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('OK', style: TextStyle(color: Color(int.parse('0xFF027088')))),
          onPressed: () {
            widget.onCountrySelected(tempSelectedCountry!);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}