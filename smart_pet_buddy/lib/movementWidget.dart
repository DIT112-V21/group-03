import 'package:flutter/material.dart';
import 'package:smart_pet_buddy/movementInfo.dart';


class MovementWidget extends StatefulWidget {
  final MovementInfo info;
  final GestureTapCallback onPressed;
  final String commandRunning;

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
            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.softLight),
            image: NetworkImage(widget.info.imageUrl),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12),
        ),

        child: TextButton(
          onPressed: widget.commandRunning == "" || widget.commandRunning == widget.info.command ? widget.onPressed : null, //null means that nothing happens when on pressed (button disabled)
          child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.commandRunning == widget.info.command ? "Busy driving..." : widget.info.title, textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)),
                  Icon(
                    widget.commandRunning == widget.info.command ? Icons.pause_circle_filled : Icons.play_circle_fill,
                    color: Colors.white,
                    size: 50.0,
                  ),
                ],
              )
          )
        ),
    );
  }
}
