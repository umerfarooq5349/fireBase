import 'dart:async';

import 'package:firebase_app/ui/auth/login_screen.dart';
import 'package:firebase_app/ui/upload_image.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class SplashService {
  final _auth = FirebaseAuth.instance;
  void islogin(BuildContext context) {
    final user = _auth.currentUser;

    if (user != null) {
      Timer(
        const Duration(seconds: 3),
        () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UploadImageScreen(),
              ));
        },
      );
    } else {
      Timer(
        const Duration(seconds: 3),
        () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ));
        },
      );
    }
  }
}
