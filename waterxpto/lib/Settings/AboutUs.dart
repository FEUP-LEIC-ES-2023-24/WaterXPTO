import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('About Us', style: TextStyle(fontFamily: 'Montserrat')),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Icon(
              CupertinoIcons.back,
              color: Color(int.parse('0xFF027088')),
            ),
          ),
        ),
      ),
      child: Scaffold(
          body: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: 0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Color(int.parse('0xFF027088')),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'For environmentally conscious individuals who aim for a sustainable lifestyle. WaterXPTO provides real-time monitoring, personalized insights, and actionable tips to reduce water consumption effortlessly. Track usage, receive tailored recommendations, and contribute to global conservation efforts with WaterXPTO.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Color(int.parse('0xFFFFFFFF')),
                        fontSize: MediaQuery.of(context).size.height < 800 ? 12 : 15,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.4,
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
                        'Creators:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.height < 800 ? 12 : 15,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Duarte Lagoela\nGonçalo Remelhe\nJosé Costa\nRafael Pires\n',
                        textAlign: TextAlign.center,
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
            ],
          )
      ),
    );
  }
}
