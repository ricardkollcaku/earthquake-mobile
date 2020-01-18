import 'package:earthquake/presantation/fragment/settings_fragment.dart';
import 'package:flutter/material.dart';

class SettingsState extends State<SettingsFragment> {
  bool _notification = true;

  SettingsState() {
    initFields();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      children: [getChangePassword(), getNotification()],
    );
  }

  List<Widget> _listItems;

  void initFields() {}

  Widget getNotification() {
    return Card(
      child: SwitchListTile(
        value: _notification,
        title: Text("Earthquake Notifications"),
        onChanged: (bool value) {
          setState(() {
            _notification = value;
          });
        },
      ),
    );
  }

  Widget getChangePassword() {
    return Card(
      child: ListTile(
        title: Text("Change password"),
        trailing: Icon(Icons.security),
      ),
    );
  }
}
