import 'package:earthquake/domain/services/notification_service.dart';
import 'package:earthquake/domain/services/user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';


class FirebaseService{

UserService _userService;
FirebaseMessaging _firebaseMessaging;
static NotificationService _notificationService;

FirebaseService(){
  _userService = new UserService();
  _firebaseMessaging = new FirebaseMessaging();
  _notificationService = new NotificationService();
  getMessages();
   _notificationService.initNotifications();

}
  Stream<String> registerToken(){
 return _firebaseMessaging.getToken()
     .asStream()
     .flatMap((token)=>_userService.setFirebaseToken(  Uri.encodeQueryComponent(token)));
  }

  getMessages(){
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _notificationService.showOngoingNotification(_notificationService.flutterLocalNotificationsPlugin,title: "title",body: message.toString());
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onlunch: $message");

        _notificationService.showOngoingNotification(_notificationService.flutterLocalNotificationsPlugin,title: "title",body: message.toString());
      },
      onResume: (Map<String, dynamic> message) async {
        print("onresume: $message");
        _notificationService.showOngoingNotification(_notificationService.flutterLocalNotificationsPlugin,title: "title",body: message.toString());
      },
    );
  }

static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if(_notificationService==null|| _notificationService.flutterLocalNotificationsPlugin==null){
    _notificationService=new NotificationService();
    _notificationService.initNotifications();
  }
  if (message.containsKey('data')) {
    print("onMessage: $message");
    _notificationService.showOngoingNotification(_notificationService.flutterLocalNotificationsPlugin,title: "title",body: message.toString());
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    print("onMessage: $message");
    _notificationService.showOngoingNotification(_notificationService.flutterLocalNotificationsPlugin,title: "title",body: message.toString());
    final dynamic notification = message['notification'];
  }
  print('dddd');
  return Future.value(true);
  // Or do other work.
}
}


