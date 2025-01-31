import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spot/screens/splashscreen.dart';
import 'package:spot/screens/startingpage.dart';
import 'package:spot/vendor/authentication/login.dart';
import 'package:spot/vendor/screens/vendorReport.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'spot',
        channelGroupKey: 'group key',
        channelName: 'Spot',
        channelDescription: 'TECHFIFO')
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: 'group key', channelGroupName: 'Techfifo group'),
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Spot 1',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(240, 27, 102, 231)),
          useMaterial3: true,
        ),
        // home: const LoginPage()); as ventor
        home: StartingPage());
  }
}
