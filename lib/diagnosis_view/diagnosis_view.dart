import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:startup_namer/diagnosis_view/headache_view.dart';
import 'package:startup_namer/utility/be_aware_colors.dart';


class DiagnosisView extends StatefulWidget {
  //final int selectedPage;

  //DiagnosisView({required this.selectedPage});

  @override
 _DiagnosisViewState createState() => _DiagnosisViewState();
}

class _DiagnosisViewState extends State<DiagnosisView> {
  //final int selectedPage;
  int _selectedIndex = 0;
  int badge = 0;

  PageController controller = PageController();
  //_DiagnosisViewState({required this.selectedPage});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
    appBar: AppBar(
      backgroundColor: Color(BeAwareColors.crayola),
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
          return HeadacheView();
          //TODO: Evtl. mit Enum Symptom Views ansteuern + und im Konstruktor mitübergeben
        })),

    bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(BeAwareColors.crayola),
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
              rippleColor: Color(BeAwareColors.lapislazuli),
              hoverColor: Color(BeAwareColors.lapislazuli),
              gap: 8,
              activeColor: Color(BeAwareColors.lapislazuli),
              iconSize: 24,
              padding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[50]!,
              color: Colors.grey[100],
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
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                controller.jumpToPage(index);
              },
            ),
          ),
        ),
      ),


    );
  
}
}