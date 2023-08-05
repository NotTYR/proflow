import 'package:ProFlow/extensions.dart';
import 'package:flutter/material.dart';

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   bool _isEnabled = false;
//   bool _additionalSettingsEnabled = false;
//   int _daysBeforeDue = 1; // Default value
//   String _selectedUnit = 'days'; // Default value

//   List<int> _numberOptions = [
//     1,
//     2,
//     3,
//     4,
//     5,
//     6,
//     7
//   ]; // Dropdown options for number
//   List<String> _unitOptions = ['days', 'weeks']; // Dropdown options for unit

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Settings'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.only(
//           top: 3.0.hp,
//           left: 5.0.wp,
//           right: 5.0.wp,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   'Enable Task Notifications',
//                   style: TextStyle(fontSize: 13.0.sp),
//                 ),
//                 SizedBox(
//                   width: 12.0.wp,
//                 ),
//                 Switch(
//                   value: _isEnabled,
//                   onChanged: (value) {
//                     setState(() {
//                       _isEnabled = value;
//                     });
//                   },
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 1.0.hp,
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
//               child: Visibility(
//                 visible: _isEnabled,
//                 child: Row(
//                   children: [
//                     Text(
//                       'Notify',
//                       style: TextStyle(fontSize: 12.0.sp),
//                     ),
//                     SizedBox(
//                       width: 4.0.wp,
//                     ),
//                     DropdownButton<int>(
//                       value: _daysBeforeDue,
//                       onChanged: (newValue) {
//                         setState(() {
//                           _daysBeforeDue = newValue!;
//                         });
//                       },
//                       items: _numberOptions.map((int value) {
//                         return DropdownMenuItem<int>(
//                           value: value,
//                           child: Text('$value'),
//                         );
//                       }).toList(),
//                     ),
//                     DropdownButton<String>(
//                       value: _selectedUnit,
//                       onChanged: (newValue) {
//                         setState(() {
//                           _selectedUnit = newValue!;
//                         });
//                       },
//                       items: _unitOptions.map((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     ),
//                     SizedBox(
//                       width: 3.0.wp,
//                     ),
//                     Text(
//                       'before task is due.',
//                       style: TextStyle(fontSize: 12.0.sp),
//                     )
//                     // Add more additional settings here if needed
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
          top: 3.0.hp,
          left: 5.0.wp,
          right: 5.0.wp,
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
                SizedBox(width: 10.0.wp),
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
                padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _notificationSettings.add(NotificationSetting(
                        daysBeforeDue: 1,
                        unit: 'days',
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
  int _selectedNumber = 1; // Default value
  String _selectedUnit = 'days'; // Default value

  List<int> _numberOptions = [
    1,
    2,
    3,
    4,
    5,
    6,
    7
  ]; // Dropdown options for number
  List<String> _unitOptions = ['days', 'week']; // Dropdown options for unit

  @override
  void initState() {
    super.initState();
    _selectedNumber = widget.setting.daysBeforeDue;
    _selectedUnit = widget.setting.unit;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notify',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 1.0.hp),
          Row(
            children: [
              SizedBox(width: 5.0.wp),
              DropdownButton<int>(
                value: _selectedNumber,
                onChanged: (newValue) {
                  setState(() {
                    _selectedNumber = newValue!;
                  });
                },
                items: _numberOptions.map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value'),
                  );
                }).toList(),
              ),
              SizedBox(width: 2.0.wp),
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
              SizedBox(width: 1.0.wp),
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
          SizedBox(height: 2.0.hp),
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
