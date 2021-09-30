import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startup_namer/data/model/SensorData.dart';

import '../Constants.dart' as Constants;

class SensorDataProvider {
  static final SensorDataProvider _instance = SensorDataProvider._internal();
  static final Duration cacheTTL = Duration(seconds: 30);

  factory SensorDataProvider() => _instance;
  Map<String, dynamic>? data;
  DateTime? lastRetrieval;

  late Future _initializationDone;

  Future<SensorDataContainer> get staticAqi => getValues("bme", "STATIC_IAQ");

  Future<SensorDataContainer> get temperature =>
      getValues("bme", "TEMPERATURE");

  Future<SensorDataContainer> get humidity => getValues("bme", "HUMIDITY");

  Future<SensorDataContainer> get iaq => getValues("bme", "IAQ");

  Future<SensorDataContainer> get co2Equivalent =>
      getValues("bme", "CO2_EQUIVALENT");

  Future<SensorDataContainer> get breathVocEquivalent =>
      getValues("bme", "BREATH_VOC_EQUIVALENT");

  Future<SensorDataContainer> get aiqAccuracy =>
      getValues("bme", "AIQ_ACCURACY");

  Future<SensorDataContainer> get brightness => getValues("gy", "lux");

  Future<SensorDataContainer> get colorTemperature =>
      getValues("tcs", "colorTemp");

  Future<SensorDataContainer> get postures =>
      getValues("jetson", "postures");

  SensorDataProvider._internal() {
    _initializationDone = _init();
  }

  Future _init() async {
    // Try to load data from preferences
    return SharedPreferences.getInstance().then((prefs) => {
          if (prefs.containsKey(Constants.shared_prefs_sensor_json_key))
            {
              data = jsonDecode(
                  prefs.getString(Constants.shared_prefs_sensor_json_key)!)
            }
          else
            {loadMockData().then((values) => data = values)}
        });
  }

  Future<Map<String, dynamic>> loadMockData() async {
    final String fileContent =
        await rootBundle.loadString('assets/mock_sensor_values.json');
    return jsonDecode(fileContent);
  }

  Future<SensorDataContainer> getValues(String baseSensor, sensorName,
      {bool forceReload = false}) async {
    return _getValues(baseSensor, sensorName, forceReload: forceReload)
        .then((values) => SensorDataContainer(values));
  }

  Future<List<SensorData>> _getValues(String baseSensor, sensorName,
      {bool forceReload = false}) async {
    await _initializationDone; // Make sure that we have finished the initialisation
    await reloadData(forceReload);
    if (data == null) {
      return [];
    }
    List<dynamic>? sensorData =
        data?[baseSensor]?[baseSensor + '_' + sensorName];
    if (sensorData == null) {
      return [];
    }
    return List.generate(
        sensorData.length,
        (i) => SensorData(
            id: sensorData[i]['id'],
            timestamp: sensorData[i]['ts'] * 1000.0,
            // Convert from seconds to milliseconds
            baseSensor: sensorData[i]['bs'],
            sensorName: sensorData[i]['sn'],
            value: sensorData[i]['v'],
        additionalData: sensorData[i]['a']));
  }

  reloadData(bool forceReload) async {
    if (!forceReload &&
        data != null &&
        lastRetrieval != null &&
        DateTime.now().difference(lastRetrieval!) < cacheTTL) {
      return;
    }
    http.Response response;
    try {
      response = await http
          .get(Uri.parse(Constants.server_sensor_values_json_url))
          .timeout(Duration(seconds: 5));
    } on IOException catch (e) {
      print("Error while fetching sensor data from server $e");
      return;
    } on TimeoutException catch (_) {
      print("Timeout while fetching sensor data from server");
      return;
    }
    if (response.statusCode != 200) {
      print(
          "Unexpected status code while fetching sensor data from server: ${response.statusCode}");
      return;
    }
    data = jsonDecode(response.body);
    lastRetrieval = DateTime.now();

    // save data to preferences
    await SharedPreferences.getInstance().then((prefs) =>
        prefs.setString(Constants.shared_prefs_sensor_json_key, response.body));
  }
}
