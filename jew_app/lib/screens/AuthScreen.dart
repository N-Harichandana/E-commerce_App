// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '/models/http_exception.dart';
import '/providers/auth.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatelessWidget {
  static const routename = '/auth';
  @override
  Widget build(BuildContext context) {
    final devicesize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
            )),
          ),
          SingleChildScrollView(
            child: Container(
              height: devicesize.height,
              width: devicesize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    //     child: Container(
                    //   margin: EdgeInsets.only(bottom: 20),
                    //   padding:
                    //       EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                    //   transform: Matrix4.rotationZ(-8 * pi / 180)
                    //     ..translate(-10.0),
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(20),
                    //       color: Colors.deepOrange.shade900,
                    //       boxShadow: [
                    //         BoxShadow(
                    //             blurRadius: 8,
                    //             color: Colors.black26,
                    //             offset: Offset(0, 2))
                    //       ]),
                    //   child: Text(
                    //     "My Shop",
                    //     style: TextStyle(
                    //         color: Colors.black45,
                    //         fontSize: 50,
                    //         fontWeight: FontWeight.normal),
                    //   ),
                    // )),

                    child: Image.network(
                        "https://www.tryourjewellery.com/wp-content/uploads/2020/10/Try-Our-Jewellery-Logo.png"),
                  ),
                  Flexible(
                    child: Authcard(),
                    flex: devicesize.width > 600 ? 2 : 1,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Authcard extends StatefulWidget {
  const Authcard({super.key});

  @override
  State<Authcard> createState() => _AuthcardState();
}

class _AuthcardState extends State<Authcard> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  Map<String, String> _authdata = {'email': '', 'password': ''};
  bool _isloading = false;
  final passwordcontroller = TextEditingController();

  void _showerrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("An Error Occured"),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text("Okay"))
              ],
            ));
  }

  Future<void> submit() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }
    _formkey.currentState!.save();
    setState(() {
      _isloading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authdata['email']!, _authdata['password']!);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authdata['email']!, _authdata['password']!);
      }
    } on HttpException catch (error) {
      var errormessage = "Authentication Failed";
      if (error.toString().contains('EMAIL_EXISTS')) {
        errormessage = "This email address is already in use";
      } else if (error.toString().contains("INVALID_EMAIL")) {
        errormessage = "This is not valid email address";
      } else if (error.toString().contains("WEAK_PASSWORD")) {
        errormessage = "This password is too weak";
      } else if (error.toString().contains("INVALID_LOGIN_CREDENTIALS")) {
        errormessage = "Could not find a user with that email";
        // } else if (error.toString().contains("INVALID_PASSWORD")) {
        //   errormessage = "Inavlid Password";
      }
      _showerrorDialog(errormessage);
    } catch (error) {
      const errormessage = "Could not authenticate. Please try again";
      _showerrorDialog(errormessage);
    }

    setState(() {
      _isloading = false;
    });
  }

  void switchAuthmode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final devicesize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.signup ? 380 : 280,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.signup ? 320 : 260),
        width: devicesize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  TextFormField(
                    scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "Invalid email";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _authdata['email'] = newValue!;
                    },
                  ),
                  TextFormField(
                    scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                    controller: passwordcontroller,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 5) {
                        return "Password is too short";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _authdata['password'] = newValue!;
                    },
                  ),
                  if (_authMode == AuthMode.signup)
                    TextFormField(
                      scrollPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      enabled: _authMode == AuthMode.signup,
                      decoration: InputDecoration(labelText: 'ConfirmPassword'),
                      obscureText: true,
                      validator: _authMode == AuthMode.signup
                          ? (value) {
                              if (value != passwordcontroller.text) {
                                return "Password do not match";
                              }
                              return null;
                            }
                          : null,
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (_isloading)
                    CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: submit,
                      child: Text(
                          _authMode == AuthMode.login ? 'Login' : 'Signup'),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 30, vertical: 8)),
                      ),
                    ),
                  TextButton(
                    onPressed: switchAuthmode,
                    child: Text(
                        '${_authMode == AuthMode.login ? "Signup" : "Login"} INSTEAD'),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 30, vertical: 4)),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
