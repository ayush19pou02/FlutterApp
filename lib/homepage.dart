// Home page screen

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_page/enums.dart';
import 'package:login_page/eventPage.dart';
import 'package:login_page/homepage1.dart';
import 'package:login_page/menu_info.dart';
import 'package:login_page/widgets.dart';
import 'package:provider/provider.dart';
import 'SignInScreen.dart';
import 'auth.dart';
import 'taskPage.dart';
//import 'reminderPage.dart';
import 'database.dart';
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,

        // appbar text
        title: Text("Productivity Hacker"),
        ),
        // In body text containing 'Home page ' in center
        drawer: Drawer(
          child: ListView(
          // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children:<Widget> [
              //UserAccountsDrawerHeader(accountName: name, accountEmail: email),
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                ),
                child:

               Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.zero,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        imageUrl!,
                      ),
                      radius: 40,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    name!,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    email!,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                    ),

                ],
               ),
              ),
              ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.red,
                  ),
                  title: Text(
                    "Sign Out",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    signOutGoogle();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                          return SignInScreen();
                        }), ModalRoute.withName('/'));
                  }),
            ],
          ),
        ),

        body: SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            color: Color(0xFFF6F6F6),
            child: Stack(
              children: [
                Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 16.0,
                    bottom: 10.0
                  ),
                  child: Image(image: AssetImage(
                    'assets/logo.png'
                  ),
                  ),
                ),
                TaskCardWidget(
                  title: "Get Started!",
                  desc: "Hello! $name",),
                Padding(
                  padding: EdgeInsets.only(
                    top: 50.0,
                    bottom: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueGrey,
                          padding:  EdgeInsets.symmetric(horizontal: 24,vertical: 20),
                          textStyle: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) {
                                return EventPage();
                              }), ModalRoute.withName('/'));
                        },
                        child: const Text('Event',
                        style: TextStyle(
                          fontSize: 20
                        ),)
                      ),


                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blueGrey,
                              padding:  EdgeInsets.symmetric(horizontal: 24,vertical: 20),
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                                  return ChangeNotifierProvider<MenuInfo>(
                                    create: (context) => MenuInfo(MenuType.alarm, imageSource: ''),
                                    child: HomePage1(),
                                  );
                                }), ModalRoute.withName('/'));
                          },
                          child: const Text('Reminder')),
                    ],
                  )
                ),

              ],
            ),
            ],
              ),
        ),
        ),
      );

  }
}
