import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                height: 24,
              ),
              Icon(
                Icons.message,
                size: 75,
                color: Colors.blue,
              ),
              SizedBox(
                height: 36,
              ),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
