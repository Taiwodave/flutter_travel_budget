

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_baby_name/services/auth_service.dart';
import 'package:flutter_app_baby_name/views/first_view.dart';
import 'package:flutter_app_baby_name/views/navigation_view.dart';
import 'package:flutter_app_baby_name/views/sign_up_view.dart';
import 'package:flutter_app_baby_name/widgets/provider_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeController(),
        routes: <String, WidgetBuilder> {
          '/home': (BuildContext context) => HomeController(),
          '/signUp': (BuildContext context) => SignUpView(authFormType: AuthFormType.signUp),
          '/signIn': (BuildContext context) => SignUpView(authFormType: AuthFormType.signIn),
          '/anonymousSignIn': (BuildContext context) => SignUpView(authFormType: AuthFormType.anonymous),
          '/convertUser': (BuildContext context) => SignUpView(authFormType: AuthFormType.convert),
        },
      ),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder(
      stream: auth.onAuthStateChangeed,
        builder: (context, AsyncSnapshot<String> snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            final bool signedIn = snapshot.hasData;
            return signedIn ? Home() : FirstView();
          }
          return CircularProgressIndicator();
        }
    );
  }
}



