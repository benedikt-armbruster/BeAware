import 'package:BeAware/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:BeAware/data_view/air_screen.dart';
import 'package:BeAware/data_view/light_screen.dart';
import 'package:BeAware/data_view/posture_screen.dart';
import 'package:BeAware/utility/be_aware_colors.dart';

class DataView extends StatefulWidget {
  final int selectedPage;

  DataView({required this.selectedPage});

  @override
  _DataViewState createState() =>
      _DataViewState(selectedPage: this.selectedPage);
}

class _DataViewState extends State<DataView> {
  final int selectedPage;
  int _selectedIndex = 0;
  int _bottomNavSelectedView = 0;
  int badge = 0;

  Widget getView({required int index, required Widget home}) {
    if (index == 1) {
      return AppSettings();
    } else {
      return home;
    }
  }

  PageController controller = PageController();

  _DataViewState({required this.selectedPage});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: getView(
        index: this._bottomNavSelectedView,
        home: DefaultTabController(
            initialIndex: this.selectedPage,
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Color(BeAwareColors.crayola),
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'Air'),
                    Tab(text: 'Posture'),
                    Tab(text: 'Light')
                  ],
                ),
              ),
              body: SafeArea(
                  child: PageView.builder(
                      onPageChanged: (page) {
                        setState(() {
                          _selectedIndex = page;
                          badge = badge + 1;
                        });
                      },
                      controller: controller,
                      itemBuilder: (context, position) {
                        return TabBarView(
                          children: [
                            AirScreen(),
                            PieChartSample1(),
                            LightScreen(),
                            //PostureView(),
                            //LightView(),
                          ],
                        );
                      })),
            )),
      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
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
                setState(() {
                  _bottomNavSelectedView = index;
                });
              },
            ),
          ),
        ),
      ),
    ));
  }
}
