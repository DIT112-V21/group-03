import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum DialogAction { save, abort }

var _languages = ['English', 'Swedish', 'Chinese', 'Russian'];
//var _currentItemSelected = 'English';

class Dialogs {
  static Future<DialogAction> yesAbortDialog(
      BuildContext context,
      String title,
      String body,
      ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          actions: <Widget>[
            Align(alignment: Alignment.topLeft, child: TextButton(
              onPressed: () => Navigator.of(context).pop(DialogAction.abort),
              child: const Text('X',  style: TextStyle( fontWeight: FontWeight.w500, fontSize: 16, color: Color(0xFF005263))),
            ),
            ),
            Align (alignment: Alignment.center, child: Text('Select language',
                textAlign: TextAlign.center,
                style: TextStyle( fontWeight: FontWeight.w500, fontSize: 18, color: Color(0xFF005263),)
            ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(alignment: Alignment.center, child: DropdownButton<String>(
              items: _languages.map((String dropDownStringItem) {
                return DropdownMenuItem<String>(
                  value: dropDownStringItem,
                  child: Text(dropDownStringItem,
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20,)),
                );
              }).toList(),

              onChanged: (String newValueSelected) {
                //setState(() {
              },
            ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(alignment: Alignment.center, child:
            ElevatedButton(onPressed: () =>  Navigator.of(context).pop(DialogAction.save),
              child: const Text('Save',  style: TextStyle( fontWeight: FontWeight.w500, fontSize: 16, backgroundColor: Color(0xFF62A8AC),) ),

            ),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogAction.abort;
  }
}