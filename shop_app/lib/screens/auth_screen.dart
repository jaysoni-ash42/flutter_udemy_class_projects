import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/custom_exception.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/util/helper.dart';
import 'package:shop_app/widgets/loading_state.dart';
import '../util/enum.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(340, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(490, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SizedBox(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 94.0),
                    transform: Matrix4.rotationZ(-8 * pi / 180)
                      ..translate(-10.0),
                    // ..translate(-10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.indigoAccent,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: const Text(
                      'MyShop',
                      style: TextStyle(
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ),
                ),
                Flexible(
                  flex: deviceSize.width > 600 ? 3 : 2,
                  child: const AuthCard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': "",
    'password': "",
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showToast(BuildContext context, bool error, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    error
        ? showToast(context, message,
            icon: Icons.cancel_rounded, iconColor: Colors.redAccent)
        : showToast(context, message);
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_authMode == AuthMode.Login) {
      try {
        await Provider.of<Auth>(context, listen: false).signIn(
            _authData["email"].toString(), _authData["password"].toString());
        _showToast(context, false, "Logged In!");
      } on CustomException catch (e) {
        _showToast(context, true, e.message);
      } catch (e) {
        _showToast(context, true, "SomeThing Went Wrong,Please Try Again");
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      try {
        await Provider.of<Auth>(context, listen: false).signUp(
            _authData["email"].toString(), _authData["password"].toString());
        _showToast(context, false, "User Registered!");
        setState(() {
          _authMode = AuthMode.Login;
        });
      } on CustomException catch (e) {
        _showToast(context, true, e.message);
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        _showToast(context, true, "SomeThing Went Wrong,Please Try Again");
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchAuthMode() {
    _formKey.currentState!.reset();
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
        width: deviceSize.width * 0.85,
        height: _authMode == AuthMode.Signup ? 400 : 320,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 400 : 320),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 8.0,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 7),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'E-Mail', border: OutlineInputBorder()),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Invalid email!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['email'] = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Password', border: OutlineInputBorder()),
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 7) {
                          return 'Password is too short!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['password'] = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    if (_authMode == AuthMode.Signup)
                      TextFormField(
                        enabled: _authMode == AuthMode.Signup,
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder()),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                              }
                            : null,
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (_isLoading)
                      const LoadingState()
                    else
                      ElevatedButton(
                        onPressed: () => _submit(context),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 8.0)),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                        ),
                        child: Text(
                            _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                      ),
                    TextButton(
                      onPressed: _switchAuthMode,
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 4))),
                      child: Text(
                          '${_authMode == AuthMode.Login ? 'SignUp if you don\'t have a account?' : 'Login if you have a account.'} '),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
