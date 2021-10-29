import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:BeAware/utility/be_aware_colors.dart';
import 'package:BeAware/utility/data_container.dart';
import 'package:BeAware/utility/data_view_layout.dart';
import 'package:BeAware/utility/icon_container.dart';

class HomeScreen extends StatefulWidget {
  // HomeScreen({ Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var customRowTop = Row(children: <Widget>[
    Expanded(
      flex: 5,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 8.0),
        child: RoundIconContainer(
          bgColor: Color(BeAwareColors.crayola),
          icon: Icons.health_and_safety_outlined,
          title: "Headache",
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
          title: "Nausea",
        ),
      ),
    ),
  ]);

  var customRowBottom = Row(children: <Widget>[
    Expanded(
      flex: 5,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 8.0),
        child: RoundIconContainer(
          bgColor: Color(BeAwareColors.crayola),
          icon: Icons.settings_accessibility_rounded,
          title: "Backpain",
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
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding:
              EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Color(BeAwareColors.someblue).withAlpha(120),
              color: Colors.black,
              tabs: [
                GButton(icon: Icons.home_outlined, text: 'Home'),
                GButton(
                  icon: Icons.settings_outlined,
                  text: 'Settings',
                ),
                GButton(
                  icon: Icons.person_outlined,
                  text: 'Profile',
                )
              ],
              selectedIndex: 0,
              onTabChange: (index) {
                // TODO
              },
            ),
          ),
        ),
      ),
        body: SafeArea(
            child: Column(children: [
      DataViewLayout(
          upperHeight: 0.69,
          lowerHeight: 0.18,
          // lowerBg: Colors.black12,
          upperChild: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.contain,
                //alignment: Alignment.topCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Text(""),
                ),
                Container(
                  //color: Colors.black38,
                  height: MediaQuery.of(context).size.height * 0.28,
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: customRowTop,
                ),
                Container(
                  //color: Colors.black45,
                  height: MediaQuery.of(context).size.height * 0.28,

                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: customRowBottom,
                ),
              ],
            ),
          ),
          lowerChild: (Stack(children: [
            Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                  //color: Colors.deepOrangeAccent,
                  height: MediaQuery.of(context).size.height * 0.28,
                  width: MediaQuery.of(context).size.width,

                  child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            flex: 1,
                            child: DataContainer(
                                height: 0.7,
                                width: 0.9,
                                child: IconContainer(
                                  bgColor: Color(BeAwareColors.someblue),
                                  borderRadius: 10.0,
                                  icon: Icons.stacked_line_chart_outlined,
                                  title: "Air",
                                  tabIndex: 0,
                                ))),
                        //Text("Some Data")

                        Expanded(
                            child: DataContainer(
                                height: 0.7,
                                width: 0.9,
                                child: IconContainer(
                                  bgColor: Color(BeAwareColors.someblue),
                                  borderRadius: 10.0,
                                  icon: Icons.stacked_bar_chart_outlined,
                                  title: "Posture",
                                  tabIndex: 1,
                                ))),
                        //Text("Some Data")

                        Expanded(
                            child: DataContainer(
                                height: 0.7,
                                width: 0.9,
                                child: IconContainer(
                                  bgColor: Color(BeAwareColors.someblue),
                                  borderRadius: 10.0,
                                  icon: Icons.data_usage_outlined,
                                  title: "Light",
                                  tabIndex: 2,
                                )))
                      ]),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(BeAwareColors.etonblue),
                        width: 4,
                      ),
                    ),
                  ),
                ))
              ],
            ),
          ])))
    ])));
  }
}
