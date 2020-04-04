import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_app_baby_name/main.dart';
import 'package:flutter_app_baby_name/services/auth_service.dart';
import 'package:flutter_app_baby_name/widgets/provider_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

//Todo move this to tone location
final primaryColor = const Color(0xFF75A2EA);

enum AuthFormType { signIn, signUp, reset, anonymous, convert }

class SignUpView extends StatefulWidget {
  final AuthFormType authFormType;

  SignUpView({Key key, @required this.authFormType}) : super(key: key);

  @override
  _SignUpViewState createState() =>
      _SignUpViewState(authFormType: this.authFormType);
}

class _SignUpViewState extends State<SignUpView> {
  AuthFormType authFormType;
  _SignUpViewState({this.authFormType});

  final formKey = GlobalKey<FormState>();
  String _email, _password, _name, _warning;

  //method to know the current state of a user
  void switchFormState(String state) {
    formKey.currentState.reset();
    if (state == "signUp") {
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    } else if (state == 'home') {
      Navigator.of(context).pop();
    }
    else {
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  bool validate() {
    final form = formKey.currentState;
    if(authFormType == AuthFormType.anonymous) {
      return true;
    }
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        switch(authFormType){

          case AuthFormType.signIn:
            await auth.signInWithEmailAndPassword(_email, _password);
            Navigator.of(context).pushReplacementNamed("/home");
            break;
          case AuthFormType.signUp:
            await auth.createUserWithEmailAndPassword(
                _email, _password, _name);
            Navigator.of(context).pushReplacementNamed("/home");
            break;
          case AuthFormType.reset:
            await auth.sendPasswordResetEmail(_email);
            _warning = "A password reset link has been sent to $_email";
            setState(() {
              authFormType == AuthFormType.signIn;
            });
            break;
          case AuthFormType.anonymous:
            await auth.signInAnonymously();
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case AuthFormType.convert:
            await auth.convertUserwWithEmail(_email, _password, _name);
            Navigator.of(context).pop();
            break;
        }

      } catch (e) {
        setState(() {
          _warning = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    if (authFormType == AuthFormType.anonymous) {
      submit();
      return Scaffold(
        backgroundColor: primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitDoubleBounce(
              color: Colors.white,
            ),
            Text(
              "Loading",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          color: primaryColor,
          height: _height,
          width: _width,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: _height * 0.025),
                  showAlert(),
                  SizedBox(height: _height * 0.025),
                  buildHeaderText(),
                  SizedBox(height: _height * 0.05),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: buildInputs() + buildButtons(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(_warning, maxLines: 3),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _warning = null;
                    });
                  }),
            )
          ],
        ),
      );
    }
    return SizedBox(height: 0);
  }

  AutoSizeText buildHeaderText() {
    String _hearderText;
    if (authFormType == AuthFormType.signIn) {
      _hearderText = "Sign In";
    } else if (authFormType == AuthFormType.reset) {
      _hearderText = "Reset Password";
    } else {
      _hearderText = "Create New Account";
    }
    return AutoSizeText(
      _hearderText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 35, color: Colors.white),
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];
    if (authFormType == AuthFormType.reset) {
      textFields.add(
        TextFormField(
          validator: EmailValidator.validate,
          style: TextStyle(fontSize: 22.0),
          decoration: buildSignUpInputDecoration("Email"),
          onSaved: (value) => _email = value,
        ),
      );
      textFields.add(SizedBox(height: 20.0));
      return textFields;
    }

    //if were in the signup state add name
    if ({AuthFormType.signUp, AuthFormType.convert}.contains(authFormType)) {
      textFields.add(TextFormField(
        validator: NameValidator.validate,
        style: TextStyle(fontSize: 22.0),
        decoration: buildSignUpInputDecoration("Name"),
        onSaved: (value) => _name = value,
      ));
      textFields.add(SizedBox(height: 20.0));
    }

    ////add email and password
    //Email
    textFields.add(TextFormField(
      validator: EmailValidator.validate,
      style: TextStyle(fontSize: 22.0),
      decoration: buildSignUpInputDecoration("Email"),
      onSaved: (value) => _email = value,
    ));
    textFields.add(SizedBox(
      height: 20.0,
    ));
    //Password
    textFields.add(TextFormField(
      validator: PasswordValidator.validate,
      style: TextStyle(fontSize: 22.0),
      decoration: buildSignUpInputDecoration("Password"),
      obscureText: true,
      onSaved: (value) => _password = value,
    ));

    return textFields;
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.0)),
      contentPadding:
          const EdgeInsets.only(left: 24.0, bottom: 10.0, top: 10.0),
    );
  }

  List<Widget> buildButtons() {
    String _switchButtonText, _newFormState, _submitButtonText;
    bool _showForgotPassword = false;
    bool _showSocial = true;

    if (authFormType == AuthFormType.signIn) {
      _switchButtonText = "Create New Account";
      _newFormState = "signUp";
      _submitButtonText = "Sign In";
      _showForgotPassword = true;
    } else if (authFormType == AuthFormType.reset) {
      _switchButtonText = "Return to Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Submit";
      _showSocial = false;
    } else if (authFormType == AuthFormType.convert){
      _switchButtonText = "Cancel";
      _newFormState = "home";
      _submitButtonText = "Sign Up";
    }
    else {
      _switchButtonText = "Have an Account? Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Sign Up";
    }

    return [
      SizedBox(height: 15.0),
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Colors.white,
          textColor: primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _submitButtonText,
//              "Sign Up",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
            ),
          ),
          onPressed: submit,
        ),
      ),
      showForgotPassword(_showForgotPassword),
      FlatButton(
        onPressed: () {
          switchFormState(_newFormState);
        },
        child: Text(
          _switchButtonText,
          style: TextStyle(color: Colors.white),
        ),
      ),
      buildSocialIcon(_showSocial),
    ];
  }

  Widget showForgotPassword(bool visible) {
    return Visibility(
      child: FlatButton(
        child: Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          setState(() {
            authFormType = AuthFormType.reset;
          });
        },
      ),
      visible: visible,
    );
  }

  Widget buildSocialIcon(bool visible) {
    final _auth = Provider.of(context).auth;
    return Visibility(
      child: Column(
        children: <Widget>[
          Divider(color: Colors.white),
          SizedBox(height: 10),
          GoogleSignInButton(
            onPressed: () async {
              try{
                if(authFormType == AuthFormType.convert){
                  await _auth.convertWithGoogle();
                  Navigator.of(context).pop();
                } else {
                  await _auth.signInWithGoogle();
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              } catch(e){
                setState(() {
                  _warning = e.message;
                });
              }
            },
          )
        ],
      ),
      visible: visible,
    );
  }
}
