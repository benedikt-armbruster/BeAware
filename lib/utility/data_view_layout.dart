import 'package:flutter/material.dart';

class DataViewLayout extends StatelessWidget {
  final double upperHeight;
  final double lowerHeight;
  final Color? upperBg;
  final Color? lowerBg;
  final Widget upperChild;
  final Widget lowerChild;
  final double upperPadTop;
  final double lowerPadBottom;

  DataViewLayout(
      {required this.upperHeight,
      required this.lowerHeight,
      this.upperBg,
      this.lowerBg,
      required this.upperChild,
      required this.lowerChild,
      this.upperPadTop = 0,
      this.lowerPadBottom = 0,
      });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: [
      Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * this.upperHeight,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: this.upperPadTop),
            color: this.upperBg,
            child: this.upperChild,
          )
        ],
      ),
      Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * this.lowerHeight,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: this.lowerPadBottom),
            color: this.lowerBg,
            child: this.lowerChild,
          )
        ],
      )
    ]));
  }
}
