import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habitmaker/screens/authScreens/login.dart';
import 'package:habitmaker/screens/mainScreens/navBar.dart';
class Authwrapper extends StatelessWidget {
  const Authwrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,));
        }
        if (snapshot.hasData) {
          return const NavBar();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}