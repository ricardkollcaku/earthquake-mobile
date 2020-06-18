import 'package:earthquake/domain/services/notification_service.dart';
import 'package:earthquake/domain/services/user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseService {
  UserService _userService;
  FirebaseMessaging _firebaseMessaging;
  static NotificationService _notificationService;

  FirebaseService() {
    _userService = new UserService();
    _firebaseMessaging = new FirebaseMessaging();
    _notificationService = new NotificationService();
    getMessages();
    _notificationService.initNotifications();
  }

  Stream<String> registerToken() {
    return _firebaseMessaging.getToken().asStream().flatMap((token) =>
        _userService.setFirebaseToken(Uri.encodeQueryComponent(token)));
  }

  getMessages() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        return _notificationService.showOngoingNotification(
            _notificationService.flutterLocalNotificationsPlugin,
            title: message['data']['title'],
            body: message['data']['description']);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onlunch: $message");

        return _notificationService.showOngoingNotification(
            _notificationService.flutterLocalNotificationsPlugin,
            title: message['data']['title'],
            body: message['data']['description']);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onresume: $message");
        return _notificationService.showOngoingNotification(
            _notificationService.flutterLocalNotificationsPlugin,
            title: message['data']['title'],
            body: message['data']['description']);
      },
    );
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    if (_notificationService == null ||
        _notificationService.flutterLocalNotificationsPlugin == null) {
      _notificationService = new NotificationService();
      _notificationService.initNotifications();
    }
    if (message.containsKey('data')) {
      print("onbcq: $message");

      print("onbc2: $message");
      return _notificationService.showOngoingNotification(
          _notificationService.flutterLocalNotificationsPlugin,
          title: message['data']['title'],
          body: message['data']['description']);
    }
    return Future.value(true);
    // Or do other work.
  }
}
