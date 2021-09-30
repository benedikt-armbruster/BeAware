import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/data/SensorDataProvider.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}

class PieChartSample1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PieChartSample1State();
}

class PieChartSample1State extends State {
  int touchedIndex = -1;
  List<double> mockData = [30.0, 20.0, 10.0, 18.0];
  int i = 0;

  Future<List<double>> getPostureData() async {
    return SensorDataProvider().postures.then((values) {
      var data = values.asSensorData;
      if (data.isEmpty || data.last.additionalData == null) {
        // Mock data
        return mockData;
      }
      // decode latest value
      return jsonDecode(data.last.additionalData!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onDoubleTap: () {
          i++;
          if (i % 2 == 0) {
            mockData = [30.0, 20.0, 10.0, 18.0];
          } else {
            mockData = [73, 10.0, 7.0, 12.0];
          }
        },
        child: FutureBuilder<List<double>>(
            future: getPostureData(),
            builder: (BuildContext context,
                AsyncSnapshot<List<double>> postureData) {
              var showingSections = ({List<double>? dataIn, radius = 160.0}) {
                var data = dataIn ?? mockData;
                return List.generate(
                  4,
                  (i) {
                    final isTouched = i == touchedIndex;
                    final opacity = isTouched ? 1.0 : 0.6;

                    final color0 = const Color(0xff0293ee);
                    final color1 = const Color(0xfff8b250);
                    final color2 = const Color(0xff845bef);
                    final color3 = const Color(0xff13d38e);

                    switch (i) {
                      case 0:
                        return PieChartSectionData(
                          color: color0.withOpacity(opacity),
                          value: data[i],
                          title: '',
                          radius: radius,
                          titleStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff044d7c)),
                          titlePositionPercentageOffset: 0.55,
                          borderSide: isTouched
                              ? BorderSide(color: color0.darken(40), width: 6)
                              : BorderSide(color: color0.withOpacity(0)),
                        );
                      case 1:
                        return PieChartSectionData(
                          color: color1.withOpacity(opacity),
                          value: data[i],
                          title: '',
                          radius: radius,
                          titleStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff90672d)),
                          titlePositionPercentageOffset: 0.55,
                          borderSide: isTouched
                              ? BorderSide(color: color1.darken(40), width: 6)
                              : BorderSide(color: color2.withOpacity(0)),
                        );
                      case 2:
                        return PieChartSectionData(
                          color: color2.withOpacity(opacity),
                          value: data[i],
                          title: '',
                          radius: radius,
                          titleStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff4c3788)),
                          titlePositionPercentageOffset: 0.6,
                          borderSide: isTouched
                              ? BorderSide(color: color2.darken(40), width: 6)
                              : BorderSide(color: color2.withOpacity(0)),
                        );
                      case 3:
                        return PieChartSectionData(
                          color: color3.withOpacity(opacity),
                          value: data[i],
                          title: '',
                          radius: radius,
                          titleStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff0c7f55)),
                          titlePositionPercentageOffset: 0.55,
                          borderSide: isTouched
                              ? BorderSide(color: color3.darken(40), width: 6)
                              : BorderSide(color: color2.withOpacity(0)),
                        );
                      default:
                        throw Error();
                    }
                  },
                );
              };
              if (postureData.hasData && postureData.data != null) {
                return AspectRatio(
                  aspectRatio: 1.3,
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 28,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Indicator(
                                    color: const Color(0xff0293ee),
                                    text: 'Perfect',
                                    isSquare: false,
                                    size: touchedIndex == 0 ? 18 : 16,
                                    textColor: touchedIndex == 0
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                  Indicator(
                                    color: const Color(0xfff8b250),
                                    text: 'Back lean',
                                    isSquare: false,
                                    size: touchedIndex == 1 ? 18 : 16,
                                    textColor: touchedIndex == 1
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ]),
                            Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Indicator(
                                    color: const Color(0xff845bef),
                                    text: 'Wrong arm pose',
                                    isSquare: false,
                                    size: touchedIndex == 2 ? 18 : 16,
                                    textColor: touchedIndex == 2
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                  Indicator(
                                    color: const Color(0xff13d38e),
                                    text: 'Too close',
                                    isSquare: false,
                                    size: touchedIndex == 3 ? 18 : 16,
                                    textColor: touchedIndex == 3
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ]),
                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                  pieTouchData: PieTouchData(touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
                                        touchedIndex = -1;
                                        return;
                                      }
                                      touchedIndex = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    });
                                  }),
                                  startDegreeOffset: 180,
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 1,
                                  centerSpaceRadius: 0,
                                  sections: showingSections(
                                      dataIn: postureData.data!)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                    child: SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator()));
              }
            }));
  }
}

extension ColorExtension on Color {
  /// Convert the color to a darken color based on the [percent]
  Color darken([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(alpha, (red * value).round(), (green * value).round(),
        (blue * value).round());
  }
}
