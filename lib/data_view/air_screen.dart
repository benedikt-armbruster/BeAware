import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/data/SensorDataProvider.dart';
import 'package:startup_namer/data/model/SensorData.dart';
import 'package:startup_namer/utility/base_line_chart.dart';
import 'package:startup_namer/utility/be_aware_colors.dart';
import 'package:startup_namer/utility/data_view_layout.dart';


class AirScreen extends StatelessWidget {
  //const AirView({Key? key}) : super(key: key);

  final List<Color> gradientColors = [
    const Color(0xFFFFFFFF),
  ];

  Widget simpleTextButton(
      BuildContext context, Widget Function(BuildContext) onTap,
      {required Widget child}) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      ),
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => onTap(context),
          )),
      child: child,
    );
  }

  Widget baseLineChartForDataSource(
      Future<SensorDataContainer> Function() getData,
      {String Function(double)? getText}) {
    return Scaffold(
        backgroundColor: Color(BeAwareColors.crayola),
        body: BaseLineChart(
          bottomTitle: BaseLineChart.defaultBottomTitles(),
          leftTitle: _leftTitle(getText: getText),
          gradientColors: gradientColors,
          fetchDataFunction: () => getData().then((values) => values
              .filterByMaxRelativeAge(Duration(days: 1))
              .groupByAverageWithIntervalLength(Duration(minutes: 5))
              .roundValuesWithDecimalPlaces(1)
              .asFlSpotValues),
        ));
  }

  SideTitles _leftTitle({String Function(double)? getText}) {
    return SideTitles(
        showTitles: true,
        getTitles: getText ?? (value) => "${value.toStringAsFixed(0)}",
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
        upperHeight: 0.52,
        lowerHeight: 0.2,
        upperBg: Color(BeAwareColors.crayola),
        upperChild: Container(
          child: BaseLineChart(
            bottomTitle: BaseLineChart.defaultBottomTitles(),
            leftTitle: _leftTitle(),
            gradientColors: gradientColors,
            fetchDataFunction: () => SensorDataProvider().staticAqi.then(
                (values) => values
                    .filterByMaxRelativeAge(Duration(days: 1))
                    .groupByAverageWithIntervalLength(Duration(minutes: 5))
                    .roundValuesWithDecimalPlaces(1)
                    .asFlSpotValues),
          ),
        ),
        lowerChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                simpleTextButton(
                    context,
                    (context) => baseLineChartForDataSource(
                        () => SensorDataProvider().temperature,
                        getText: (value) => "${value.toStringAsFixed(1)}C"),
                    child: Text('Temperature')),
                simpleTextButton(
                    context,
                    (context) => baseLineChartForDataSource(
                        () => SensorDataProvider().co2Equivalent),
                    child: Text("CO2")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                simpleTextButton(
                    context,
                    (context) => baseLineChartForDataSource(
                        () => SensorDataProvider().humidity,
                        getText: (value) => "${value.toStringAsFixed(1)}%"),
                    child: Text('Humidity')),
                simpleTextButton(
                    context,
                    (context) => baseLineChartForDataSource(
                        () => SensorDataProvider().breathVocEquivalent),
                    child: Text("VOC")),
              ],
            )
          ],
        ),
      )
    ]));
  }
}
