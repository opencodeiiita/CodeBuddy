import 'package:codebuddy/background.dart';
import 'package:codebuddy/login_screen.dart';
import 'package:codebuddy/signup_screen.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("CodeBuddy"),
          centerTitle: true,
        ),
        body: GradientBackground(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Stack(
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  
                  children: [
                    SizedBox(height: 200,),
                    Text("Welcome to", style: TextStyle(color: Colors.white30, fontSize: 20),textAlign: TextAlign.center),
                    Text("CodeBuddy Demo", style: TextStyle(color: Colors.white, fontSize: 40),textAlign: TextAlign.center),
                    SizedBox(height: 130,),
                    Text("What would you like to do ?", style: TextStyle(color: Colors.white70, fontSize: 20),textAlign: TextAlign.center),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  //spacing: 20,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: const Text("Login")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupScreen()));
                        },
                        child: const Text("Signup")),
                    const SizedBox(height: 100)
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
