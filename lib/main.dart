import 'package:flutter/material.dart';
import 'dart:async';
// main.dart file
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:login_page/homepage.dart';
import 'package:splashscreen/splashscreen.dart';
import 'SignInScreen.dart';
import 'auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
var c=0;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid = new
  AndroidInitializationSettings('codex_logo');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {});


  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
      });
// initializing the firebase app
  await Firebase.initializeApp();

// calling of runApp
  runApp(GoogleSignIn());
}

class GoogleSignIn extends StatefulWidget {
  const GoogleSignIn({Key? key}) : super(key: key);
  @override
  _GoogleSignInState createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
  @override
  Widget build(BuildContext context) {

    // we return the MaterialApp here ,
    // MaterialApp contain some basic ui for android ,
    return MaterialApp(

      //materialApp title
      title: 'Productivity Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // home property contain SignInScreen widget
      home:

      SplashScreen(
          seconds: 5,
          navigateAfterSeconds:SignInScreen(),
          title: new Text(
            'WELCOME',
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.white),
          ),
          image: new Image.asset('assets/flut.png'),
          photoSize: 100.0,
          backgroundColor: Colors.cyan,
          styleTextUnderTheLoader: new TextStyle(),
          loaderColor: Colors.white
      ),

    );
  }
}
Future<bool> check(BuildContext context) async{
  await WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLoggedIn = (prefs.getBool('isLoggedIn')==null)? false:prefs.getBool('isLoggedIn');
  print(isLoggedIn);
  c++;
  print('f');
  if (isLoggedIn == null) {
    return false;
  }
  else
  {
    return true;
  }
}