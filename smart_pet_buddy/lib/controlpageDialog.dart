import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class ControlpageDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Normal Mode'),
      content: SingleChildScrollView(
        child: RichText(
          text: TextSpan(
            text: 'Before you start make sure that you are ',
            style: TextStyle(color: textColor, fontWeight: FontWeight.normal),
            children: <TextSpan>[
              TextSpan(
                  text: 'connected ',
                  style:
                  TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                  'to the car. (You can do so on the homepage) You control the car by using the arrow buttons. '
                      'To control the speed, press the ',
                  style: TextStyle(
                      color: textColor, fontWeight: FontWeight.normal)),
              TextSpan(
                  text: '+ ',
                  style:
                  TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: 'or ',
                  style: TextStyle(
                      color: textColor, fontWeight: FontWeight.normal)),
              TextSpan(
                  text: '- ',
                  style:
                  TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: 'at the bottom of the page. ',
                  style: TextStyle(
                      color: textColor, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
