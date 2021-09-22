import 'dart:math';

import "package:collection/collection.dart";
import 'package:fl_chart/fl_chart.dart';

class SensorData {
  final int id;
  final double
      timestamp; // In millisecondsSinceEpoch (this is different than in the json)
  final String baseSensor;
  final String sensorName;
  final double value;

  SensorData(
      {required this.id,
      required this.timestamp,
      required this.baseSensor,
      required this.sensorName,
      required this.value});

  DateTime get timestampAsDateTime =>
      DateTime.fromMillisecondsSinceEpoch(timestamp.floor());
}

class SensorDataContainer {
  final List<SensorData> _sensorData;
  late final double minTimestamp;
  late final double maxTimestamp;
  late final double minValue;
  late final double maxValue;

  SensorDataContainer(this._sensorData) {
    double minTimestamp = double.infinity;
    double maxTimestamp = double.negativeInfinity;
    double minValue = double.infinity;
    double maxValue = double.negativeInfinity;
    for (SensorData data in _sensorData) {
      minTimestamp = min(minTimestamp, data.timestamp);
      maxTimestamp = max(maxTimestamp, data.timestamp);
      minValue = min(minValue, data.value);
      maxValue = max(maxValue, data.value);
    }
    this.minTimestamp = minTimestamp;
    this.maxTimestamp = maxTimestamp;
    this.minValue = minValue;
    this.maxValue = maxValue;
    final maxT = DateTime.fromMillisecondsSinceEpoch(maxTimestamp.floor());
    final minT = DateTime.fromMillisecondsSinceEpoch(minTimestamp.floor());
  }

  List<FlSpot> get asFlSpotValues => _sensorData
      .map((e) => FlSpot(e.timestamp, e.value))
      .toList(growable: false);

  List<SensorData> get asSensorData => _sensorData;

  bool get isEmpty => _sensorData.isEmpty;

  SensorDataContainer filterByTimestampWithDateTime(
      {DateTime? minTimestamp, DateTime? maxTimestamp}) {
    return this.filterByTimestamp(
        minTimestamp: minTimestamp?.millisecondsSinceEpoch.toDouble(),
        maxTimestamp: maxTimestamp?.millisecondsSinceEpoch.toDouble());
  }

  SensorDataContainer filterByTimestamp(
      {double? minTimestamp, double? maxTimestamp}) {
    if ((minTimestamp == null || minTimestamp <= this.minTimestamp) &&
        (maxTimestamp == null || maxTimestamp >= this.maxTimestamp)) {
      return SensorDataContainer(_sensorData);
    }
    return SensorDataContainer(_sensorData
        .where((data) =>
            (minTimestamp == null || data.timestamp >= minTimestamp) &&
            (maxTimestamp == null || data.timestamp <= maxTimestamp))
        .toList(growable: false));
  }

  /// Age is relative to latest datapoint in the dataset
  SensorDataContainer filterByMaxRelativeAge(
          Duration age) =>
      _filterByMinTimestamp(
          DateTime.fromMillisecondsSinceEpoch(this.maxTimestamp.floor())
              .subtract(age));

  SensorDataContainer filterByMaxAbsolutAge(Duration age) =>
      _filterByMinTimestamp(DateTime.now().subtract(age));

  SensorDataContainer _filterByMinTimestamp(DateTime minTimestamp) {
    if (this.minTimestamp >= minTimestamp.millisecondsSinceEpoch) {
      // Container does not contain older data
      return SensorDataContainer(_sensorData);
    }
    final indexOfFirstToOldData = _sensorData.lastIndexWhere(
        (data) => data.timestampAsDateTime.isBefore(minTimestamp));
    // return value should never be -1 since we already handled the case when no data is older
    return SensorDataContainer(_sensorData.sublist(indexOfFirstToOldData + 1));
  }

  SensorDataContainer groupByAverageWithFixedIntervalCount(int intervals) {
    final intervalLength =
        DateTime.fromMillisecondsSinceEpoch(maxTimestamp.ceil()).difference(
                DateTime.fromMillisecondsSinceEpoch(minTimestamp.floor())) ~/
            intervals;
    return this.groupByAverageWithIntervalLength(intervalLength);
  }

  SensorDataContainer groupByAverageWithIntervalLength(
      Duration intervalLength) {
    assert(!intervalLength.isNegative, 'Interval must be positive.');
    final intervalMillis = intervalLength.inMilliseconds.toDouble();
    final groupedValues = _sensorData.groupListsBy(
        (data) => ((data.timestamp - minTimestamp) / intervalMillis).floor());
    // calculate avg for each interval
    final sensorData = groupedValues.entries
        .sorted((a, b) => a.key.compareTo(b.key)) // sort by timestamp
        .map((e) {
      // map to average
      final avg = e.value
              .map((m) => m.value)
              .reduce((value, element) => value + element) /
          e.value.length.toDouble();
      final data = e.value.first;
      return SensorData(
          id: data.id,
          timestamp: e.key * intervalMillis + this.minTimestamp,
          baseSensor: data.baseSensor,
          sensorName: data.sensorName,
          value: avg);
    }).toList(growable: false);
    return SensorDataContainer(sensorData);
  }

  SensorDataContainer roundValuesWithDecimalPlaces(int decimalPlaces) {
    final data = _sensorData
        .map((e) => SensorData(
            id: e.id,
            timestamp: e.timestamp,
            baseSensor: e.baseSensor,
            sensorName: e.sensorName,
            value: _roundWithPrecision(e.value, decimalPlaces)))
        .toList(growable: false);
    return SensorDataContainer(data);
  }

  double _roundWithPrecision(double val, int places) {
    num mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }
}
