import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/data/SensorDataProvider.dart';
import 'package:startup_namer/utility/base_line_chart.dart';
import 'package:startup_namer/utility/be_aware_colors.dart';
import 'package:startup_namer/utility/data_view_layout.dart';
import 'package:intl/intl.dart';

class LightScreen extends StatelessWidget {
  //const AirView({Key? key}) : super(key: key);

  final List<Color> gradientColors = [
    const Color(0xFFFFFFFF),
  ];


  SideTitles _leftTitle() {
    return SideTitles(
        showTitles: true,
        getTitles: (value) => "${value.toStringAsFixed(0)}",
        reservedSize: 30,
        getTextStyles: (_, value) => TextStyle(
          color: Color(BeAwareColors.indigo),
          fontSize: 10,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: [
          DataViewLayout(
            upperHeight: 0.49,
            lowerHeight: 0.29,
            upperBg: Color(BeAwareColors.crayola),
            upperChild: Container(
              child: BaseLineChart(
                bottomTitle: BaseLineChart.defaultBottomTitles(),
                leftTitle: _leftTitle(),
                gradientColors: gradientColors,
                fetchDataFunction: () => SensorDataProvider().brightness.then(
                        (values) => values
                        .filterByMaxRelativeAge(Duration(days: 1))
                        .groupByAverageWithIntervalLength(Duration(minutes: 5))
                        .roundValuesWithDecimalPlaces(1)
                        .asFlSpotValues),
              ),
            ),
            lowerChild: Container(child: Text("Lower")),
          )
        ]));
  }
}
