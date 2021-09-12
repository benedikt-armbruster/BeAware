
import 'dart:html';

import 'package:flutter/material.dart';

class RoundContainer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        //borderRadius: BorderRadius.all(Radius.circular(120))
      ),
    );
  }
}
