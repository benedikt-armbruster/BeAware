class SensorData {
  final int id;
  final double
      timestamp; // In millisecondsSinceEpoche (this is different than in the json)
  final String baseSensor;
  final String sensorName;
  final double value;

  SensorData(
      {required this.id,
      required this.timestamp,
      required this.baseSensor,
      required this.sensorName,
      required this.value});

  get timestampAsDateTime =>
      DateTime.fromMillisecondsSinceEpoch(timestamp.floor());
}
