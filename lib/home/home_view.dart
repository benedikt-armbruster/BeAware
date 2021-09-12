import 'package:flutter/material.dart';
import '../utility/round_container.dart';
import '../utility/be_aware_colors.dart';

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
                  child: RoundContainer(),
                  color: Color(BeAwareColors.hellblau),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            
                  
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  child: Text("Noch ein Text"),
                  color: Colors.lightBlue,
                  
                ),
              ), 
            ]

          );

  var dataContainer =  Container(
        decoration: BoxDecoration(
          color: Colors.tealAccent,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(60),
              blurRadius: 5.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Text("Noch ein Text"), 
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
                color: Colors.black38,
                height: MediaQuery.of(context).size.height*0.29,
                margin: EdgeInsets.only(top: 4.0 ),
                child: customRow,
              ),               
              
              Container(
                color: Colors.black45,
                height: MediaQuery.of(context).size.height*0.29,
                margin: EdgeInsets.only(bottom: 4.0 ),
                child: customRow,
              ),
                                          
        Row(
                  children: <Widget>[
                    Expanded(
                      flex: 10,
                      child: Container(
                        color: Colors.black12,
                        height: MediaQuery.of(context).size.height*0.33,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            dataContainer,
                            dataContainer,
                            dataContainer
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