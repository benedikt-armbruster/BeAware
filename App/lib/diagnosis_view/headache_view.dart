

import 'package:flutter/material.dart';
import 'package:BeAware/utility/be_aware_colors.dart';
import 'package:BeAware/utility/data_view_layout.dart';

class HeadacheView extends StatefulWidget{
  _HeadacheViewState createState() => _HeadacheViewState();
}

class _HeadacheViewState extends State<HeadacheView>{
  //TabController _tabController = new TabController(length: 2, vsync: this);
  //PageController _controller = PageController(initialPage: 0,);
  int _widgetIndex = 0;
  var containerCenter = Alignment(0.0, 0.0);
  var buttonColor = Color(BeAwareColors.someblue);
  bool _isSelected0 = true;
  bool _isSelected1 = false;
  bool _isSelected2 = false;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children:[
        DataViewLayout(
          upperHeight: 0.5,
          lowerHeight: 0.3,
          upperBg: Colors.white,
          upperChild: Stack(
            alignment: containerCenter,
            children: <Widget>[
              Positioned(
                bottom: (containerCenter.y + 0.3) * 100,
                left: (containerCenter.x + 0.3) * 100,
                child: ElevatedButton(
              onPressed: () {
                setState(() => _widgetIndex = 0);
                    buttonColor = Color(BeAwareColors.someblue);
                    _isSelected0 = true;
                    _isSelected1 = false;
                    _isSelected2 = false;
              },
              child: Icon(Icons.menu, color: Colors.white),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                primary: _isSelected0 ? Color(BeAwareColors.someblue) :  Color(BeAwareColors.lightgrey), // <-- Button color
                //onPrimary: Color(BeAwareColors.etonblue), // <-- Splash color
              ),
            )
          ),

           Positioned(
              child: ElevatedButton(
              onPressed: () {
                setState(() => _widgetIndex = 1);
                    buttonColor = Color(BeAwareColors.someblue);
                    _isSelected0 = false;
                    _isSelected1 = true;
                    _isSelected2 = false;
              },
              child: Icon(Icons.menu, color: Colors.white),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                primary: _isSelected1 ? Color(BeAwareColors.someblue) :  Color(BeAwareColors.lightgrey), // <-- Button color
                //onPrimary: Colors.red, // <-- Splash color
              ),
            )
          ),

           Positioned(
              bottom: (containerCenter.y + 0.3) * 100,
              right: (containerCenter.x + 0.3) * 100,
              child: ElevatedButton(
              onPressed: () {
                setState(() => _widgetIndex = 2);
                    buttonColor = Color(BeAwareColors.someblue);
                    _isSelected0 = false;
                    _isSelected1 = false;
                    _isSelected2 = true;
              },
              child: Icon(Icons.menu, color: Colors.white),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                primary: _isSelected2 ? Color(BeAwareColors.someblue) :  Color(BeAwareColors.lightgrey), // <-- Button color
               //onPrimary: Colors.red, // <-- Splash color
              ),
            )

          ),
          ]  
          ),
           
          lowerChild: IndexedStack(
            index: _widgetIndex,
            children: [
              Text("Page1"),
              Text("Page2"),
              Text("Page3"),
          ],)
          )
        
      ])
    
    );
  }

}