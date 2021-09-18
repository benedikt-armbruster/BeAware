import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/utility/be_aware_colors.dart';
import 'package:startup_namer/utility/data_view_layout.dart';

class AirScreen extends StatelessWidget {
  //const AirView({Key? key}) : super(key: key);

  final List<Color> gradientColors = [
    const Color(0xFFFFFFFF),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: [
           DataViewLayout(
             upperHeight: 0.49, 
             lowerHeight: 0.39, 
             upperBg: Color(BeAwareColors.crayola),
             upperChild: Container(
               child: LineChart(      
                  LineChartData(
                    gridData: FlGridData(
                      show: false
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    axisTitleData: FlAxisTitleData(
                      show: false,
                    ),
                    titlesData: FlTitlesData(
                      show: false,
                    ),
                    minX: 0,
                    maxX: 11,
                    minY: 0,
                    maxY: 6,
                    lineBarsData: [
                      LineChartBarData(
                        spots:[
                          FlSpot(0, 3),
                          FlSpot(2.6, 2),
                          FlSpot(4.9, 5),
                          FlSpot(6.8, 2.5),
                          FlSpot(8, 4),
                          FlSpot(9.5, 3),
                          FlSpot(11, 4),
                        ],
                        isCurved: true,
                        colors: gradientColors,
                        barWidth: 4, 
                        belowBarData: BarAreaData(
                          show: true,
                          colors: gradientColors
                            .map((color) => color.withOpacity(0.1))
                            .toList(),
                        )


                      )
                    ]
                  ),
                  swapAnimationDuration: Duration(milliseconds: 150), // Optional
                  swapAnimationCurve: Curves.linear, 
                ),
               ), 
             lowerChild: Container(
               child: Text("Lower")
               ), 
             
             )
          ]
      )
    );
  }
}