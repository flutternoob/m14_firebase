import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:m14_firebase/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, this._isLoading, {super.key});

  final void Function(
      String email, String password, String userName, File image, bool isLogin) submitFn;

  final bool _isLoading;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _userEmail = "";
  String _userName = "";
  String _userPassword = "";
  File _userImageFile = File("");

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Please pick an image"),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      /*print(_userEmail);
      print(_userName);
      print(_userPassword);*/
      widget.submitFn(_userEmail.trim(), _userPassword, _userName, _userImageFile, _isLogin);
      //Use those values to send auth request to Firebase...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) ...[
                    UserImagePicker(_pickedImage),
                  ],
                  TextFormField(
                    key: const ValueKey("email"),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                    ),
                  ),
                  if (!_isLogin) ...[
                    TextFormField(
                      key: const ValueKey("username"),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return "Please enter at least 4 characters";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value!;
                      },
                      decoration: const InputDecoration(
                        labelText: "Username",
                      ),
                    ),
                  ],
                  TextFormField(
                    key: const ValueKey("password"),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return "Password must be at least 7 characters long";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget._isLoading) ...[const CircularProgressIndicator()],
                  if (!widget._isLoading) ...[
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? "Login" : "Signup"),
                    ),
                  ],
                  const SizedBox(
                    height: 12,
                  ),
                  if (!widget._isLoading) ...[
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? "Create new account"
                          : "I already have an account"),
                    )
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
