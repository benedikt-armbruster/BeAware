import 'package:flutter/material.dart';
import 'package:startup_namer/data_view/air_view.dart';

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
      //margin: EdgeInsets.all(30),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: this.bgColor,
      ),
      child: 
        Icon(
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
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
        Text("Test 2"),
        InkWell(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AirView()),
             );
  
          },
          child: new Ink(
          width: MediaQuery.of(context).size.width,
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
        size: 50,
      ),
    
            
          )  
                  
        ),
          

       
        ]
      )
  );
  }
}
