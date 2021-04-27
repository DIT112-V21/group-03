import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'controlpanel.dart';
import 'main.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor:Colors.green.shade400,
          actions: <Widget>[
            Builder(builder: (BuildContext context) {
              return FlatButton(
                textColor: Theme.of(context).buttonColor,
                onPressed: () async {
                  final User user = _auth.currentUser;
                  if (user == null) {
                    Scaffold.of(context).showSnackBar(const SnackBar(
                      content: Text('No one has signed in.'),
                    ));
                    return;
                  }
                  await _signOut();

                  final String uid = user.uid;
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('$uid has successfully signed out.'),
                  ));
                },
                child: const Text('Sign out'),
              );
            })
          ],
      ),
      body: Controlpanel(),
    );
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => AuthTypeSelector()));
  }
}
