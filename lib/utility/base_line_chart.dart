import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:startup_namer/utility/be_aware_colors.dart';

class BaseLineChart extends StatelessWidget {
  final SideTitles? leftTitle;
  final SideTitles? bottomTitle;
  final SideTitles? rightTitle;
  final SideTitles? topTitle;
  final List<Color> gradientColors;
  final Future<List<FlSpot>> Function() fetchDataFunction;

  const BaseLineChart(
      {Key? key,
      this.leftTitle,
      this.bottomTitle,
      this.rightTitle,
      this.topTitle,
      required this.gradientColors,
      required this.fetchDataFunction})
      : super(key: key);

  static SideTitles defaultBottomTitles() {
    return SideTitles(
      showTitles: true,
      getTextStyles: (_, value) => TextStyle(
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
      reservedSize: 52,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FlSpot>>(
      future: fetchDataFunction(),
      builder: (BuildContext context, AsyncSnapshot<List<FlSpot>> sensorData) {
        return LineChart(
          LineChartData(
              gridData: FlGridData(show: false),
              borderData: FlBorderData(
                show: false,
              ),
              axisTitleData: FlAxisTitleData(
                show: false,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: bottomTitle ?? defaultBottomTitles(),
                topTitles: topTitle ?? SideTitles(showTitles: false),
                rightTitles: rightTitle ?? SideTitles(showTitles: false),
                leftTitles: leftTitle,
              ),
              lineTouchData: LineTouchData(touchTooltipData:
                  LineTouchTooltipData(getTooltipItems: (items) {
                return items
                    .map((e) => LineTooltipItem(
                        "${e.y}\n${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(e.x.toInt()))}",
                        TextStyle(
                          color: e.bar.colors[0],
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        )))
                    .toList(growable: false);
              })),
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
                          .map((color) => color.withOpacity(0.1))
                          .toList(),
                    ))
              ]),
          swapAnimationDuration: Duration(milliseconds: 150), // Optional
          swapAnimationCurve: Curves.linear,
        );
      },
    );
  }
}
