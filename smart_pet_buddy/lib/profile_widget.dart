
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;

  const ProfileWidget ({
    key,
  this.imagePath,
  this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
          right: 4,
          child: buildEditIcon(color),
          ),
        ],
      )
    );
  }
  Widget buildImage() {
    final image = NetworkImage(imagePath);

    return ClipOval(
        child: Material(
            color: Colors.transparent,
            child:Ink.image(
      image: image,
      fit: BoxFit.cover,
      width: 128,
      height: 128,
            ),
        ),
    );

  }
  Widget buildEditIcon(Color color) => buildCircle(
    color: Colors.green,
  all: 8,
  child: Icon(
    Icons.edit,
    size: 20,
  ),
  );

  Widget buildCircle ({
  Widget child,
    double all,
    Color color,
    }) =>
      ClipOval(
       child:Container(
        padding: EdgeInsets.all(all),
          color: color,
          child: child,
       ),
      );
  }


