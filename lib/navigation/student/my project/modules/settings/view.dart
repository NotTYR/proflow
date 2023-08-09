import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isEnabled = false;
  List<NotificationSetting> _notificationSettings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 32.0,
          left: 16.0,
          right: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Enable Task Notifications',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 10.0),
                Switch(
                  value: _isEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isEnabled = value;
                      if (!_isEnabled) {
                        _notificationSettings.clear();
                      }
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_isEnabled) ..._buildNotificationSettings(),
            SizedBox(height: 16),
            if (_isEnabled)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _notificationSettings.add(NotificationSetting(
                        daysBeforeDue: 1,
                        unit: 'day',
                      ));
                    });
                  },
                  child: Text('Add Field'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNotificationSettings() {
    return _notificationSettings.map((setting) {
      return AdditionalSettings(
        setting: setting,
        onDelete: () {
          setState(() {
            _notificationSettings.remove(setting);
          });
        },
      );
    }).toList();
  }
}

class AdditionalSettings extends StatefulWidget {
  final NotificationSetting setting;
  final VoidCallback onDelete;

  AdditionalSettings({
    required this.setting,
    required this.onDelete,
  });

  @override
  _AdditionalSettingsState createState() => _AdditionalSettingsState();
}

class _AdditionalSettingsState extends State<AdditionalSettings> {
  int _selectedNumber = 1;
  String _selectedUnit = 'day';
  List<int> _numberOptions = [1, 2, 3, 4, 5, 6, 7];
  List<String> _unitOptions = ['day', 'week'];

  @override
  void initState() {
    super.initState();
    _selectedNumber = widget.setting.daysBeforeDue;
    _selectedUnit = widget.setting.unit;
  }

  void _updateUnitOptions() {
    setState(() {
      if (_selectedNumber == 1) {
        _unitOptions = ['day', 'week'];
      } else {
        _unitOptions = ['days', 'weeks'];
      }
      _selectedUnit = _unitOptions.contains(_selectedUnit)
          ? _selectedUnit
          : _unitOptions[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notify',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              DropdownButton<int>(
                value: _selectedNumber,
                onChanged: (newValue) {
                  setState(() {
                    _selectedNumber = newValue!;
                    _updateUnitOptions();
                  });
                },
                items: _numberOptions.map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value'),
                  );
                }).toList(),
              ),
              SizedBox(width: 8.0),
              DropdownButton<String>(
                value: _selectedUnit,
                onChanged: (newValue) {
                  setState(() {
                    _selectedUnit = newValue!;
                  });
                },
                items: _unitOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(width: 8.0),
              Text(
                'before task is due',
                style: TextStyle(fontSize: 18),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: widget.onDelete,
              ),
            ],
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

class NotificationSetting {
  int daysBeforeDue;
  String unit;

  NotificationSetting({
    required this.daysBeforeDue,
    required this.unit,
  });
}
