import 'package:flutter/material.dart';
import 'package:smart_pet_buddy/movementInfo.dart';


class MovementWidget extends StatefulWidget {
  final MovementInfo info;
  final GestureTapCallback onPressed;

  MovementWidget(this.info, this.onPressed);

  @override
  _MovementWidgetState createState() => _MovementWidgetState();
}

class _MovementWidgetState extends State<MovementWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.green,
          image: DecorationImage(
            image: NetworkImage(widget.info.imageUrl),
            fit: BoxFit.cover,
          ),
          border: Border.all(
            color: Colors.black12,
            width: 8,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextButton(
          child: Text(widget.info.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25), ),
          onPressed: widget.onPressed,
        ));
  }
}
