import 'package:budget/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sign_in/sign_in_page.dart';
import 'package:budget/services/auth.dart';
import 'package:budget/home/home_page.dart';

class LandingPage extends StatelessWidget {
  LandingPage({@required this.auth});
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return SignInPage(
                auth: auth,
              );
            }
            return Provider<Database>(
              create: (_) => FirestoresDatabase(uid: user.uid),
              child: HomePage(
                auth: auth,
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
