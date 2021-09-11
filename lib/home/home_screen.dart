import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({ Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  var customRow = Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  child: Text("Text"),
                  color: Colors.green,
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            
                  
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  child: Text("Noch ein Text"),
                  color: Colors.lightBlue,
                  height: 40,
                  
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
              children: [    
                Container(
                  margin: EdgeInsets.only(top: 4.0 ),
                  child: customRow,
                ),
                      
                Container(
                  margin: EdgeInsets.only(bottom: 4.0 ),
                  child: customRow,
                ),
                                
                            
              Flexible(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 10,
                      child: Container(
                        child: Text("Noch ein Text"),
                        color: Colors.tealAccent,
                        height: 30,

                        
                      ),
                    ), 
                  ]
                )
              
              ),
            ]
          )

          )
        );
  }
}