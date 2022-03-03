import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:call_video/notificationservice.dart';
import 'dart:async';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static bool isLaunch = false;

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        final notification = message['notification'];
        print("onMessage: ${notification['title']}, $notification['body']");
        NotificationService()
            .showNotification(1, notification['title'], notification['body']);
        Future.delayed(Duration(seconds: 10), () {
          NotificationService().cancelAllNotifications();
          if (!isLaunch) {
            NotificationService().showMissNotification(
                2, "Trần Gia Bảo", "Bạn đã lỡ một cuộc gọi của Trần Gia Bảo");
            Future.delayed(Duration(seconds: 3), () {
              NotificationService().cancelAllNotifications();
            });
          }
        });
      },
      onBackgroundMessage: Platform.isIOS ? null : onBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        setState(() {
          isLaunch = true;
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  static Future<dynamic> onBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    final notification = message['notification'];
    print("onMessage: ${notification['title']}, $notification['body']");
    NotificationService()
        .showNotification(1, notification['title'], notification['body']);
    Future.delayed(Duration(seconds: 10), () {
      NotificationService().cancelAllNotifications();
      if (!isLaunch) {
        NotificationService().showMissNotification(
            2, "Trần Gia Bảo", "Bạn đã lỡ một cuộc gọi của Trần Gia Bảo");
        Future.delayed(Duration(seconds: 3), () {
          NotificationService().cancelAllNotifications();
        });
      }
    });

    return Future<void>.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                NotificationService().cancelAllNotifications();
              },
              child: Container(
                height: 40,
                width: 200,
                color: Colors.red,
                child: Center(
                  child: Text(
                    "Cancel All Notifications",
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                NotificationService()
                    .showNotification(1, "Trần Gia Bảo", "Đang gọi video đến");
                Future.delayed(Duration(seconds: 10), () {
                  NotificationService().cancelAllNotifications();
                  NotificationService().showMissNotification(1, "Trần Gia Bảo",
                      "Bạn đã lỡ một cuộc gọi của Trần Gia Bảo");
                  Future.delayed(Duration(seconds: 3), () {
                    NotificationService().cancelAllNotifications();
                  });
                });
              },
              child: Container(
                height: 40,
                width: 200,
                color: Colors.green,
                child: Center(
                  child: Text("Show Notification"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
