import 'package:flutter/material.dart';

class DataContainer extends StatelessWidget {
  //Parameters
  final Widget? child;
  final double width;
  final double height;

  //Initialise Parameters
  DataContainer({
    this.child,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      //color: Colors.deepPurpleAccent,

      child: FractionallySizedBox(
        widthFactor: this.width,
        heightFactor: this.height,
        child: this.child,
      ),
    ));
  }
}
