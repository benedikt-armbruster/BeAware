import 'package:flutter/material.dart';

class UpdateText extends StatefulWidget{
  UpdateTextState createState() => UpdateTextState();
}

class UpdateTextState extends State<UpdateText>{
  String diagnosisText = 'Sample Diagnosis';

  changeText(){
    setState(() {
      diagnosisText = 'Next Sample Diagnosis';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Text('$diagnosisText'),
        padding: EdgeInsets.all(24)
      )
      );
  }

}