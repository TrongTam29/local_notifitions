import 'package:call_video/message_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:call_video/notificationservice.dart';
import 'package:call_video/mainscreen.dart';
import 'dart:async';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
FirebaseMessaging.(_firebaseMessagingBackgroundHandler);
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        importance: NotificationImportance.Max,
        defaultColor: Colors.amber,
        ledColor: Colors.white,
        playSound: true,
        enableVibration: true,
        enableLights: true),
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification App'),
        centerTitle: true,
      ),
      body: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];

  @override
  void initState() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              title: notification['title'], body: notification['body']));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    super.initState();
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 300,
            child: ListView(children: messages.map(buildMessage).toList())),
        RaisedButton(
          onPressed: () {
            AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: 1,
                  channelKey: 'basic_channel',
                  title: 'Gia Bảo',
                  body: 'Đang gọi video đến',
                  showWhen: true,
                  largeIcon:
                      'https://www.faceapp.com/static/img/content/compare/beard-example-before@3x.jpg'),
              actionButtons: <NotificationActionButton>[
                NotificationActionButton(
                  key: 'tuchoi',
                  label: 'Từ chối',
                  icon:
                      'https://www.pikpng.com/pngl/m/250-2504603_video-whatsapp-whatsapp-video-call-icon-clipart.png',
                ),
                NotificationActionButton(
                    key: 'traloi',
                    label: 'Trả lời',
                    buttonType: ActionButtonType.Default),
              ],
            );
          },
          color: Colors.red,
        ),
      ],
    );
  }

  Widget buildMessage(Message message) => ListTile(
        title: Text(message.title),
        subtitle: Text(message.body),
      );
}
