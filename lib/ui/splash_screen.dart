import 'package:firebase_app/firebase%20services/splash_services.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashService splashServices = SplashService();

  @override
  void initState() {
    splashServices.islogin(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Firebase Toturials",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
