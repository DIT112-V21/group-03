import 'package:flutter/material.dart';
import  'package:flutter/cupertino.dart';
import 'package:smart_pet_buddy/constants.dart';

AppBar buildAppBar(BuildContext context) {

  return AppBar(
    backgroundColor: strongPrimary,
      leading: BackButton(),
      elevation: 0,
    actions: [
      Text("Log out", style: TextStyle(fontSize: 18,))

    ],
  );
}
