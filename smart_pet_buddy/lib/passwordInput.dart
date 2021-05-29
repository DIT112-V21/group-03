import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final String labelText;
  final String placeholder;
  final TextEditingController textController;

  PasswordInput({this.labelText, this.placeholder, this.textController});

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: widget.textController,
        obscureText: showPassword,
        decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: Icon(
                Icons.remove_red_eye,
                color: showPassword ? Colors.grey : Colors.green,
              ),
            ),
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: widget.labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: widget.placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }

}
