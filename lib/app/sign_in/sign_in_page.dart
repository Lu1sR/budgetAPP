import 'package:budget/widgets/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'social_sign_in_button.dart';
import 'package:budget/services/auth.dart';

class SignInPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  SignInPage({@required this.auth});
  final AuthBase auth;
  String email;
  String password;

  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Sign in',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          _buildForm(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            child: SocialSignInButton(
              assetName: 'images/google-logo.png',
              text: 'Ingresa con google',
              textColor: Colors.indigo,
              color: Colors.white,
              onPressed: _signInWithGoogle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: _buildFields(),
      ),
    );
  }

  List<Widget> _buildFields() {
    return [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.indigo[50],
              boxShadow: [
                BoxShadow(
                    blurRadius: 3.0,
                    color: Colors.black12,
                    offset: Offset(0, 3)),
              ]),
          child: CustomTextForm(
            function: (String input) => email = input,
            hintText: 'Email',
            prefixIcon: MdiIcons.account,
            keyboardType: TextInputType.emailAddress,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.indigo[50],
              boxShadow: [
                BoxShadow(
                    blurRadius: 3.0,
                    color: Colors.black12,
                    offset: Offset(0, 3)),
              ]),
          child: CustomTextForm(
            function: (String input) => password = input,
            hintText: 'Contrasenia',
            prefixIcon: Icons.lock,
            keyboardType: TextInputType.visiblePassword,
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.only(right: 30),
        alignment: Alignment.centerRight,
        child: Text(
          "Recordar contrasenia?",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.indigo),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        child: _submitButtom(),
      )
    ];
  }

  Widget _submitButtom() {
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.indigo,
      highlightColor: Colors.indigo,
      splashColor: Colors.white.withAlpha(100),
      padding: EdgeInsets.only(top: 16, bottom: 16),
      onPressed: () {
        _formKey.currentState.save();
        _submit(email, password);
      },
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              "INGRESAR",
              style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Positioned(
            right: 16,
            child: ClipOval(
              child: Container(
                color: Colors.indigo[700],
                child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Icon(
                      MdiIcons.arrowRight,
                      color: Colors.white,
                      size: 18,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submit(String email, String password) async {
    _formKey.currentState.save();
    print(email);
    print(password);
    try {
      await auth.signInWithEmailAndPassword(email, password);
    } catch (e) {
      print(e.toString());
    }
  }
}
