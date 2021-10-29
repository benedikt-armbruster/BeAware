import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import '../Constants.dart' as Constants;

class SettingsProvider {
  static get serverBaseUrl => Settings.getValue(Constants.shared_prefs_server_base_url_key, Constants.server_base_url).trim();
  static get serverSensorValuesJsonUrl => serverBaseUrl + Constants.server_relative_sensor_values_json_path;
}