import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PrivacyPage extends StatefulWidget {
  final FirebaseApp app;

  PrivacyPage(this.app);


  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  bool value = false;
  bool valueShare = false;
  bool valueAuto = false;
  bool valueRem = false;
  bool valueError = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF6F6F6),
        appBar: AppBar(
          backgroundColor: Color(0xFF005263),
          title: Text("Privacy & security",
            style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w400, color: Colors.white,),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back,
              color: Colors.white,),
          ),

        ),
        body: Padding(
          padding: EdgeInsets.only(left: 10, top: 35, right: 25),

          child: Column(
            children: [
              SizedBox(height: 15,),
              Row(
                children: <Widget>[
                  Text(
                    'Smart Pet Buddy can access my location',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ), //Text
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.blue,
                    value: this.value,
                    onChanged: (bool value) {
                      setState(() {
                        this.value = value;
                      });
                    },
                  ),
                ], //<Widget>
              ),
              SizedBox(height: 10,),
              Row(
                children: <Widget>[
                  Text(
                    'I agree to share usage data',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ), //Text
                  /** Checkbox Widget **/
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.blue,
                    value: this.valueShare,
                    onChanged: (bool value) {
                      setState(() {
                        this.valueShare = value;
                      });
                    },
                  ),
                ], //<Widget>
              ),
              SizedBox(height: 15,),
              Row(
                children: <Widget>[
                  Text(
                    'I want app to update automatically ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ), //Text
                  /** Checkbox Widget **/
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.blue,
                    value: this.valueAuto,
                    onChanged: (bool value) {
                      setState(() {
                        this.valueAuto = value;
                      });
                    },
                  ),
                ], //<Widget>
              ),
              SizedBox(height: 15,),
              Row(
                children: <Widget>[
                  Text(
                    'I want to enable reminder notification',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ), //Text
                  /** Checkbox Widget **/
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.blue,
                    value: this.valueRem,
                    onChanged: (bool value) {
                      setState(() {
                        this.valueRem = value;
                      });
                    },
                  ),
                ], //<Widget>
              ),
              SizedBox(height: 10,),
              Row(
                children: <Widget>[
                  Text(
                    'Allow Smart Pet Buddy to send error logs',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ), //Text
                  /** Checkbox Widget **/
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.blue,
                    value: this.valueError,
                    onChanged: (bool value) {
                      setState(() {
                        this.valueError = value;
                      });
                    },
                  ),
                ], //<Widget>
              ),
              SizedBox(height: 30,),
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom( padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15,
                    ),
                      backgroundColor: Color(0xFFAAD8DC),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Save changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              SizedBox(height: 25,),


            ],
          ),
        ));

  }

  }
