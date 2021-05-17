import 'package:flutter/material.dart';
import  'package:flutter/cupertino.dart';
import 'package:smart_pet_buddy/constants.dart';

AppBar buildAppBar(BuildContext context) {

  final icon = CupertinoIcons.moon_stars;
  return AppBar(
    backgroundColor: strongPrimary,
      leading: BackButton(),
      elevation: 0,
    actions: [
      IconButton (
        icon: Icon(icon),
        onPressed: () {},
      )
    ],
  );
}
