import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/data/SensorDataProvider.dart';
import 'package:startup_namer/utility/be_aware_colors.dart';
import 'package:startup_namer/utility/data_view_layout.dart';
import 'package:intl/intl.dart';

class AirScreen extends StatelessWidget {
  //const AirView({Key? key}) : super(key: key);

  final List<Color> gradientColors = [
    const Color(0xFFFFFFFF),
  ];

  SideTitles _noTitle() {
    return SideTitles(showTitles: false);
  }

  SideTitles _bottomTitles() {
    return SideTitles(
      showTitles: true,
        getTextStyles: (_, value) =>  TextStyle(
          color: Color(BeAwareColors.indigo),
          fontSize: 10,
        ),
      getTitles: (value) {
        final DateTime date =
        DateTime.fromMillisecondsSinceEpoch(value.toInt());
        return DateFormat.E().add_j().format(date);
      },
      margin: 8,
      rotateAngle: 90.0,
    );
  }

  SideTitles _leftTitle() {
    return SideTitles(
      showTitles: true,
      getTitles: (value) => "${value.toStringAsFixed(1)}°C",
      reservedSize: 30,
      getTextStyles: (_, value) =>  TextStyle(
        color: Color(BeAwareColors.indigo),
        fontSize: 10,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
            child: Column(
                children: [
                  DataViewLayout(
                    upperHeight: 0.49,
                    lowerHeight: 0.39,
                    upperBg: Color(BeAwareColors.crayola),
                    upperChild: Container(
                        child: FutureBuilder<List<FlSpot>>(
                          future: SensorDataProvider().getValuesAsFLSpots(
                              "bme", "STATIC_IAQ"),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<FlSpot>> sensorData) {
                            return LineChart(
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
                                    show: true,
                                    bottomTitles: _bottomTitles(),
                                    topTitles: _noTitle(),
                                    rightTitles: _noTitle(),
                                    leftTitles: _leftTitle(),

                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                        spots: sensorData.data,
                                        isCurved: false,
                                        colors: gradientColors,
                                        barWidth: 4,
                                        dotData: FlDotData(show: false),
                                        belowBarData: BarAreaData(
                                          show: false,
                                          colors: gradientColors
                                              .map((color) =>
                                              color.withOpacity(0.1))
                                              .toList(),
                                        )


                                    )
                                  ]
                              ),
                              swapAnimationDuration: Duration(
                                  milliseconds: 150), // Optional
                              swapAnimationCurve: Curves.linear,
                            );
                          },
                        )
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