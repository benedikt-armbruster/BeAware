
import 'dart:html';

import 'package:flutter/material.dart';

class RoundIconContainer extends StatelessWidget{
  final Color bgColor;
  final Widget? child;
  final IconData? icon;
  final Color? iconColor;

  RoundIconContainer({
    required this.bgColor,
    this.child,
    this.icon,
    this.iconColor = Colors.white,
  });


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
      //height: 50,
      //width: 50,
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: this.bgColor,
      ),
      child: Icon(
        this.icon,
        color: this.iconColor,
        size: 40,
      ),
    ),
  );
  }
}

class IconContainer extends StatelessWidget{
  final Color bgColor;
  final Widget? child;
  final IconData? icon;
  final Color? iconColor;
  final double borderRadius;

  IconContainer({
    required this.bgColor,
    this.child,
    this.icon,
    this.iconColor = Colors.white,
    required this.borderRadius,
  });


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
      //height: 50,
      //width: 50,
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: this.bgColor,
        borderRadius: BorderRadius.all(Radius.circular(this.borderRadius)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(60),
            blurRadius: 5.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Icon(
        this.icon,
        color: this.iconColor,
        size: 40,
      ),
    ),
  );
  }
}
