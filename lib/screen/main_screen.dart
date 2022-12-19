import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late FlutterLocalNotificationsPlugin flutternotifications;
  late AndroidNotificationChannel channel;
  late FirebaseMessaging fireMessaging;
  bool isNotificationInit = false;
  late String token;
  late String initialMessage;
  late String message;
  late bool _resolved;

  @override
  void initState() {
    
    setupFlutterNotifications();
    fireMessaging = FirebaseMessaging.instance;
    fireMessaging.getInitialMessage().then((value) {
      _resolved = true;
      initialMessage = value!.data.toString();
      message = initialMessage;
      setState(() {});
    });
    FirebaseMessaging.onMessage.listen(showNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((event) { 
      print("new message is there");
      message = event.data.toString();
      setState(() {});
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text("sdfsdsdg")),
      ),
    );
  }


  Future<void> setupFlutterNotifications() async {
    if (isNotificationInit) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      's',
      description: 'ss',
      importance: Importance.high,
    );

    await flutternotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(channel);
    isNotificationInit = true;

    await fireMessaging
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = notification?.android;
    if (android != null && notification != null && !kIsWeb) {
      flutternotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: channel.importance
          )));
    }
  }
}
