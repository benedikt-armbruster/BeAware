import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import '../Constants.dart' as Constants;

class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => _AppSettingsState();

  static void openSettings(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AppSettings(),
        ));
  }
}

class _AppSettingsState extends State<AppSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SettingsScreen(
        title: 'Application Settings',
        children: [
          SettingsGroup(
            title: 'General Settings',
            children: <Widget>[
              SimpleSettingsTile(
                title: 'Dev Settings',
                subtitle: '',
                child: SettingsScreen(
                  title: 'App Settings',
                  children: <Widget>[
                    TextInputSettingsTile(
                      title: 'Server Address',
                      settingKey: Constants.shared_prefs_server_base_url_key,
                      initialValue: Constants.server_base_url,
                      borderColor: Colors.blueAccent,
                      errorColor: Colors.deepOrangeAccent,
                    ),
                  ],
                ),
              ),
              SimpleSettingsTile(
                title: 'Posture Calibration',
                subtitle: 'Calibrate Camera',
                child: SettingsScreen(
                  title: 'App Settings',
                  children: <Widget>[
                    TextButton(
                      onPressed: () => null,
                      child: const Text('Calibrate Posture'),
                    ),
                    TextButton(
                      onPressed: () => null,
                      child: const Text('Calibrate Camera Position'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SettingsGroup(
            title: 'Notification Settings',
            children: <Widget>[
              CheckboxSettingsTile(
                settingKey: 'key-check-box-dev-mode1',
                title: 'Enable Notifications',
                onChange: (value) {
                  debugPrint('key-check-box-dev-mode: $value');
                },
                childrenIfEnabled: <Widget>[
                  CheckboxSettingsTile(
                    settingKey: 'key-is-developer2',
                    title: 'Notify on bad posture',
                    onChange: (value) {
                      debugPrint('key-is-developer: $value');
                    },
                    childrenIfEnabled: <Widget>[
                      SliderSettingsTile(
                        title: 'Delay (minutes)',
                        settingKey: 'key-slider-volume1',
                        defaultValue: 20,
                        min: 2,
                        max: 120,
                        step: 1,
                        decimalPrecision: 0,
                        leading: Icon(Icons.access_alarm),
                        onChange: (value) {
                          debugPrint('key-slider-volume: $value');
                        },
                      )
                    ],
                  ),
                  CheckboxSettingsTile(
                    settingKey: 'key-is-developer3',
                    title: 'Notify on bad environment',
                    onChange: (value) {
                      debugPrint('key-is-developer: $value');
                    },
                    childrenIfEnabled: <Widget>[
                      SliderSettingsTile(
                        title: 'Delay (minutes)',
                        settingKey: 'key-slider-volume2',
                        defaultValue: 20,
                        min: 2,
                        max: 120,
                        step: 1,
                        decimalPrecision: 0,
                        leading: Icon(Icons.access_alarm),
                        onChange: (value) {
                          debugPrint('key-slider-volume: $value');
                        },
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
