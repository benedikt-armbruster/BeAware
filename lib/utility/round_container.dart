
import 'package:flutter/material.dart';

class RoundContainer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        //borderRadius: BorderRadius.all(Radius.circular(120))
      ),
    );
  }
}