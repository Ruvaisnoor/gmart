import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Wait for 3 seconds before checking the user's sign-in status.
    await Future.delayed(Duration(seconds: 3));

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is signed in, navigate to Home.
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // User is not signed in, navigate to Login.
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [ Color(0xFF4CAF50),   
         Color.fromARGB(221, 190, 234, 175), ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(seconds: 2),
            builder: (context, double opacity, child) {
              return Opacity(opacity: opacity, child: child);
            },
            child: Image.asset(
              "asset/images/logo.png",
              width: screenWidth * 0.4,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
