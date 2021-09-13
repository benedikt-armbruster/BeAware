import 'package:flutter/material.dart';
import 'package:flutter_titled_container/flutter_titled_container.dart';

import '../utility/icon_container.dart';
import '../utility/data_container.dart';
import '../utility/be_aware_colors.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({ Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen>{

  var customRowTop = Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 8.0),
                  child: RoundIconContainer(
                    bgColor: Color(BeAwareColors.crayola),
                    icon: Icons.health_and_safety_outlined,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                 child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 8.0),
                  child: RoundIconContainer(
                    bgColor: Color(BeAwareColors.crayola),
                    icon: Icons.healing_outlined,
                  ), 
                ),
              ), 
            ]
          );

   var customRowBottom = Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 8.0),
                  child: RoundIconContainer(
                    bgColor: Color(BeAwareColors.crayola),
                    icon: Icons.settings_accessibility_rounded,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 8.0),
                  child: RoundIconContainer(
                    bgColor: Color(BeAwareColors.crayola),
                    icon: Icons.favorite_outline,
                  ),
                ), 
              ),
            ]
          );

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:SafeArea(
        child: Column (
          children:[  
          Container(
             height: MediaQuery.of(context).size.height*0.05,
            margin: EdgeInsets.only(left: 20.0, right: 20.0 ),
            child: Text("Some Icons"),
          ),

          Container(
            //color: Colors.black38,
            height: MediaQuery.of(context).size.height*0.28,
            margin: EdgeInsets.only(left: 20.0, right: 20.0 ),
            child: customRowTop,
          ),               
          
          Container(
            //color: Colors.black45,
            height: MediaQuery.of(context).size.height*0.28,
            margin: EdgeInsets.only(left: 20.0, right: 20.0 ),
            child: customRowBottom,
          ),
                                            
          Row(
            children: <Widget>[
              Expanded(
              //  flex: 10,
               child:Container(
                 //color: Colors.deepOrangeAccent,
                 height: MediaQuery.of(context).size.height*0.28,
                 width: MediaQuery.of(context).size.width,
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,                 
                    children:[ 
                      Expanded(
                        flex: 1,
                        child: DataContainer(
                          height: 0.7,
                          width: 0.9, 
                          child: IconContainer(  
                            bgColor: Color(BeAwareColors.lapislazuli),
                            borderRadius: 10.0,
                            icon: Icons.stacked_line_chart_outlined, 
                          )
                            
                        )
                      ),
                      //Text("Some Data")
                           
                    Expanded(
                      child: DataContainer(
                        height: 0.7,
                        width: 0.9,
                        child: IconContainer(
                          bgColor: Color(BeAwareColors.lapislazuli),
                          borderRadius: 10.0,
                          icon: Icons.stacked_bar_chart_outlined,
                        )
                      )
                    ),
                    //Text("Some Data")
                   
                    Expanded(
                      child: DataContainer(
                        height: 0.7,
                        width: 0.9,
                        child: IconContainer(
                          bgColor: Color(BeAwareColors.lapislazuli),
                          borderRadius: 10.0,
                          icon: Icons.data_usage_outlined,
                        )
                      )
                      )
                    ]
                          )
                        ),
                      ),
                    ]
                  )
              
            ]
          )

          )
        );
  }
}