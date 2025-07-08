import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ytgrabber/pages/homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF0B0F2B,
      ), // Dark blue background (based on your logo)
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Rounded Logo
            ClipOval(
              child: Image.asset(
                'assets/logo.jpg',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Loading Spinner
            const CircularProgressIndicator(
              color: Color(0xFF00BFFF), // Light blue spinner to match the logo
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
