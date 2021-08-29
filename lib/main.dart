import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async {
  // Firebase.initializeApp();
  
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(messageHandler);

  runApp(MyApp());

  
}
Future<void> messageHandler(RemoteMessage message) async {
    print('background message ${message.notification!.body}');
    print("hittttttttt");
  }
class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String imagePath;
  String messageTitle = "Empty";
  String notificationAlert = "alert";
  String customTitle = "custom_title";
  bool showThanks = false;

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    firebaseMessaging.getToken().then((value) => print(value.toString()));
    FirebaseMessaging.onMessage.listen((event) {
      setState(() {
        messageTitle = event.notification?.title ?? "N?A";
        notificationAlert = event.notification?.body ?? "N/A";
        print(event.data.toString());
        event.data.forEach((key, value) {
          if(key == "custom_title"){
            customTitle = value;
          }
          if(key == "show_thanks"){
            showThanks = value == "true" ? true : false;
          }
        });
        print(customTitle);
      });
    });


    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      setState(() {
        messageTitle = event.notification?.title ?? "N?A";
        notificationAlert = event.notification?.body ?? "N/A";
        print(event.data.toString());
        event.data.forEach((key, value) {
          if(key == "custom_title"){
            customTitle = value;
          }
          if(key == "show_thanks"){
            showThanks = value == "true" ? true : false;
          }
        });
        print(customTitle);
      });
    });

  }

  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text("Push Notification"),
      ),
      body: Center(
      
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            Text(
              messageTitle,
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              notificationAlert,
            ),
            if(showThanks)
            Text(
              customTitle,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
