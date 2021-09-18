
import 'package:flutter/material.dart';
import 'package:startup_namer/data_view/air_screen.dart';

class DataView extends StatelessWidget{
  final int selectedPage;

  DataView({
    required this.selectedPage
  });


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:DefaultTabController(
        initialIndex: this.selectedPage,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'Air'),
                Tab(text: 'Posture'),
                Tab(text: 'Light')    
              ],
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              children: [
                AirScreen(),
                Text("Posture"),
                Text("Light")
                //PostureView(),
                //LightView(),
              ],
            ),
          ),
        )
      )
    );
  }
  
}