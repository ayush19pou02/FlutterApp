//SignInScreen

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'homepage.dart';
import 'auth.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    backgroundColor: Colors.cyan,
    centerTitle: true,

    // appbar text
    title: Text("Login Here"),
    ),
        body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xc58cef),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text(
    "Productivity Manager",
    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    ),
    Padding(
    padding: const EdgeInsets.fromLTRB(75, 50, 75, 20),
    child: MaterialButton(
    color: Colors.white24,
    elevation: 10,
    child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    Container(
    height: 30.0,
    width: 30.0,
    decoration: BoxDecoration(
    image: DecorationImage(
    image:
    AssetImage('assets/googleimage.png'),
    fit: BoxFit.cover),
    shape: BoxShape.circle,
    ),
    ),
    SizedBox(
    width: 40,
      child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white12
          )),
    ),
    Text("Sign In with Google" ,
    style:TextStyle(
      fontWeight: FontWeight.bold ,
    ) )
    ],
    ),

    // by onpressed we call the function signup function
    onPressed: ()=>
    signup(context),

  ),
  )
  ],
  ),
  // ),
  ),
  );
}
}
