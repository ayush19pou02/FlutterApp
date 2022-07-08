// function to implement the google signin
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'homepage.dart';
// creating firebase instance
final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
String? name;
String? email;
String? imageUrl;
Future<void> signup(BuildContext context) async {

  //await googleSignIn.disconnect();
  //await auth.signOut();
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    // Getting users credential
    UserCredential result = await auth.signInWithCredential(authCredential);
    User? user = result.user;
    if(user!=null)
    {
      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoURL != null);
      name = user.displayName;
      email = user.email;
      imageUrl = user.photoURL;
      if (name!.contains(" ")) {
        name = name!.substring(0, name!.indexOf(" "));
      }}
    if (result != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } // if result not null we simply call the MaterialpageRoute,
    // for go to the HomePage screen
  }
}
void signOutGoogle() async{
  await googleSignIn.signOut();
}
