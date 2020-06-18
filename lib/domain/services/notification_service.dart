import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
void initNotifications(){
  _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  final settingsAndroid = AndroidInitializationSettings('ic_launcher');
  final settingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) =>
          onSelectNotification(payload));

  _flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(settingsAndroid, settingsIOS),
      onSelectNotification: onSelectNotification);
}

  Future onSelectNotification(String payload) async {
    print(payload);
    return true;
  }

  NotificationDetails get _ongoing {
    final androidChannelSpecifics = AndroidNotificationDetails(
      'earthquake',
      'Earthquake app',
      'Notification channel for earthquake app',
      importance: Importance.Default,
      priority: Priority.Default,
      autoCancel: true,
      enableVibration: true,
      playSound: true,
    );
    final iOSChannelSpecifics = IOSNotificationDetails();
    return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
  }

  Future showOngoingNotification(FlutterLocalNotificationsPlugin notifications,
      {
        String title,
        String body,
        int id = 0,
      }) =>
      _showNotification(notifications,
          title: title, body: body, id: id, type: _ongoing);

  Future _showNotification(FlutterLocalNotificationsPlugin notifications, {
    String title,
    String body,
    NotificationDetails type,
    int id = 0,
  }) =>
      notifications.show(0, title, body, type);

  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      _flutterLocalNotificationsPlugin;


}