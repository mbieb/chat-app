import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/widgets/user_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isLoading = false;
  String _email = '';
  String _username = '';
  String _password = '';
  XFile? _userImageFile;

  void _pickedImage(XFile file) {
    _userImageFile = file;
  }

  onSubmit() async {
    bool isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please pick an image'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      UserCredential result;
      try {
        setState(() {
          _isLoading = true;
        });
        if (_isLogin) {
          result = await _auth.signInWithEmailAndPassword(
            email: _email.trim(),
            password: _password.trim(),
          );
        } else {
          result = await _auth.createUserWithEmailAndPassword(
            email: _email.trim(),
            password: _password.trim(),
          );
          final ref = FirebaseStorage.instance.ref().child('user_image').child(
                result.user!.uid + '.jpg',
              );

          await ref.putFile(File(_userImageFile!.path));

          final url = await ref.getDownloadURL();
          final status = await OneSignal.shared.getDeviceState();
          final String? osUserID = status?.userId;

          await FirebaseFirestore.instance
              .collection('users')
              .doc(result.user!.uid)
              .set({
            'username': _username,
            'email': _email,
            'image_url': url,
            'tokenId': osUserID,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sucess'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } on PlatformException catch (err) {
        String? message = 'Error';

        if (err.message != null) {
          message = err.message;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message!),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      } catch (err) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err.toString()),
            backgroundColor: Colors.red,
          ),
        );
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    _isLogin ? 'Sign In' : 'Create an Account',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  if (!_isLogin) UserImagePicker(imagePickFn: _pickedImage),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    style: const TextStyle(fontSize: 14),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: const Color(0xffffde6a),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.all(8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 0,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffffde6a),
                          width: 0,
                        ),
                      ),
                      labelText: 'Email',
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xffffde6a),
                      ),
                    ),
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (!_isLogin)
                    TextFormField(
                      style: const TextStyle(fontSize: 14),
                      cursorColor: const Color(0xffffde6a),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 0,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffffde6a),
                            width: 0,
                          ),
                        ),
                        labelText: 'Username',
                        floatingLabelStyle: const TextStyle(
                          color: Color(0xffffde6a),
                        ),
                      ),
                      onSaved: (value) {
                        _username = value!;
                      },
                    ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    style: const TextStyle(fontSize: 14),
                    cursorColor: const Color(0xffffde6a),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Min 7 character';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.all(8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 0,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffffde6a),
                          width: 0,
                        ),
                      ),
                      labelText: 'Password',
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xffffde6a),
                      ),
                    ),
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (_isLoading)
                    const CircularProgressIndicator(
                      color: Color(0xffffde6a),
                    ),
                  if (!_isLoading)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xffffde6a),
                        ),
                        onPressed: onSubmit,
                        child: Text(
                          _isLogin ? 'Login' : 'Sign Up',
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (!_isLoading)
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? 'Create New Account'
                            : 'I already have an account',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
