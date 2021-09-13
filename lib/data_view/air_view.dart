import 'package:flutter/material.dart';
import 'package:startup_namer/utility/be_aware_colors.dart';
import 'package:startup_namer/utility/data_view_layout.dart';

class AirView extends StatelessWidget {
  const AirView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Air Quality"),
      ),
      body: SafeArea(
        child: Column(
          children: [
           DataViewLayout(
             upperHeight: 0.49, 
             lowerHeight: 0.39, 
             upperBg: Color(BeAwareColors.indigo),
             upperChild: Container(
               child: Text("Upper")
               ), 
             lowerChild: Container(
               child: Text("Lower")
               ), 
             
             )
          ]
        )
      )
    );
  }
}