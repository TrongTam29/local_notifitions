import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:call_video/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_flutternotification');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future _notificationDetails() async {
    final largeIconPath = await Utils.downloadFile(
      'https://png.pngtree.com/png-clipart/20190904/original/pngtree-hand-drawn-flat-wind-user-avatar-icon-png-image_4492039.jpg',
      'LargeIcon',
    );

    return NotificationDetails(
      android: AndroidNotificationDetails(
        'main_channel',
        'Main Channel',
        'Main channel notifications',
        importance: Importance.max,
        priority: Priority.max,
        category: 'CATEGORY_CALL',
        showWhen: true,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('wake_up_alarm'),
        largeIcon: FilePathAndroidBitmap(largeIconPath),
        fullScreenIntent: true,
      ),
      iOS: IOSNotificationDetails(
        sound: 'wake_up_alarm.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  Future<void> showNotification(
    int id,
    String title,
    String body,
  ) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      await _notificationDetails(),
    );
  }

  static Future _missNotificationDetails() async {
    final largeIconPath = await Utils.downloadFile(
      'https://png.pngtree.com/png-clipart/20190904/original/pngtree-hand-drawn-flat-wind-user-avatar-icon-png-image_4492039.jpg',
      'LargeIcon',
    );

    return NotificationDetails(
      android: AndroidNotificationDetails(
        'main_channel2',
        'Main Channel2',
        'Main channel notifications2',
        importance: Importance.max,
        priority: Priority.max,
        category: 'CATEGORY_CALL',
        showWhen: true,
        playSound: true,
        largeIcon: FilePathAndroidBitmap(largeIconPath),
        fullScreenIntent: true,
      ),
      iOS: IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  Future<void> showMissNotification(int id, String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      await _missNotificationDetails(),
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
