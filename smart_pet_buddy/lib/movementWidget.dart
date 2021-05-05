import 'package:flutter/material.dart';
import 'package:smart_pet_buddy/movementInfo.dart';


class MovementWidget extends StatefulWidget {
  final MovementInfo info;
  final GestureTapCallback onPressed;
  final bool commandRunning;

  MovementWidget(this.info, this.commandRunning, this.onPressed);

  @override
  _MovementWidgetState createState() => _MovementWidgetState();
}

class _MovementWidgetState extends State<MovementWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.info.imageUrl),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextButton(
          onPressed: widget.commandRunning ? null : widget.onPressed,
          child: Ink(
            decoration: BoxDecoration(
              /*gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.transparent
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),*/
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(widget.commandRunning ? "Busy driving..." : widget.info.title, textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
          ),
        ),
    );
  }
}
