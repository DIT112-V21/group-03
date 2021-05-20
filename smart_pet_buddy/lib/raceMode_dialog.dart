import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class RaceModeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Race Mode'),
      content: SingleChildScrollView(
        child: RichText(
          text: TextSpan(
            text: 'Before you start make sure that you are  ',
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.normal),
            children: <TextSpan>[
              TextSpan(
                  text: 'connected ',
                  style: TextStyle(
                      color: textColor, fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                  'to the car. (You can do so on the homepage) To increase the speed you press ',
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.normal)),
              TextSpan(
                  text: 'GAS ',
                  style: TextStyle(
                      color: textColor, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: 'To slow down or reverse you press ',
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.normal)),
              TextSpan(
                  text: 'BREAK ',
                  style: TextStyle(
                      color: textColor, fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                  'At the bottom of the page the current speed is displayed. '
                      'When it is positive the car will move forward and when negative it will reverse. To steer the car, ',
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.normal)),
              TextSpan(
                  text: 'tilt your phone ',
                  style: TextStyle(
                      color: textColor, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: 'to the left and right',
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.normal)),
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
