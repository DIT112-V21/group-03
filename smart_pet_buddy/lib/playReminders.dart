import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RemindersPage extends StatefulWidget {
  final FirebaseApp app;


  RemindersPage(this.app);


  @override
  _RemindersPageState createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  bool morning = false;
  bool evening = false;
  bool afternoon = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
          backgroundColor: Color(0xFF005263),
          title: Text("Reminders",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400, color: Colors.white,),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back,
              color: Colors.white,),
          )

      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: Column(

          children: [

            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                    children: [
                      Text('Play session name', style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xFFAAD8DC),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,

                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter session name',
                              hintStyle: TextStyle(
                                color: Colors.black54,
                              )),
                        ),

                      )
                    ]
                )
            ),
            SizedBox(height: 40,),
            Text("Pick time for session", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),

            ),

            SizedBox(height: 10,),
            Row(
              children: [
                TimeCard(
                    icon: FontAwesomeIcons.sun,
                    time: 'Morning'
                ),
                TimeCard(
                    icon: FontAwesomeIcons.mugHot,
                    time: 'Afternoon'),
                TimeCard(
                    icon: FontAwesomeIcons.moon,
                    time: 'Evening'),
              ],
            ),
            SizedBox(height: 25),
            Text(
              "Additional notes",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 15),
            Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFAAD8DC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  style: TextStyle(
                    color: Color(0xFFAAD8DC),
                  ),
                  maxLines: 2,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Additional notes",
                      hintStyle: TextStyle(
                        color: Colors.black45,
                      )),

                )

            ),
            SizedBox(height: 25),
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
                      Icon(
                        FontAwesomeIcons.bell,
                        color: Colors.white,
                        size: 16,
                      ),
                      Text(
                        'Set Reminder',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TimeCard extends StatelessWidget {
  TimeCard({
    Key key, this.icon, this.time,
  }) : super(key: key);

  final IconData icon;
  final String time;
  bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        width: 80,
        margin: EdgeInsets.symmetric(horizontal: 17),
        decoration: BoxDecoration(
          color: Color(0xFF62A8AC),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFEAEAEA),
              blurRadius: 10,
              offset: Offset(2,3),
            ),
          ],
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 25,
              ),
              Text(
                  time,
                  style:( TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ))

              )
            ]
        )
    );
  }
}