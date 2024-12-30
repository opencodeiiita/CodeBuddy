import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codebuddy/background.dart';
import 'package:codebuddy/home_screen.dart';
import 'package:codebuddy/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class OtpScreen extends StatefulWidget {
  String verificationId;
  String name;
  OtpScreen({super.key, required this.verificationId, this.name = ""});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  bool _canResendOtp = true;
  int _secondsRemaining = 30;
  late Timer _timer;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _canResendOtp = false;
      _secondsRemaining = 30;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_canResendOtp) return;

      if (_secondsRemaining == 0) {
        setState(() {
          _canResendOtp = true; // Enable button
        });
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining -= 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  void resendOtp() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Verification"),
        centerTitle: true,
      ),
      body: GradientBackground(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //spacing: 5,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              textAlign: TextAlign.center,
              inputFormatters: [LengthLimitingTextInputFormatter(6)],
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  helperStyle: const TextStyle(fontSize: 10),
                  hintText: "Enter OTP",
                  prefixIcon: const Icon(Icons.phone),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24))),
            ),
          ),
          GestureDetector(
            onTap: _canResendOtp
                ? () {
                    _canResendOtp = false;
                  }
                : null,
            child: Text(
              _canResendOtp ? "Resend OTP" : "Resend OTP ($_secondsRemaining)",
              style: TextStyle(
                color: _canResendOtp ? Colors.white : Colors.white30,
                fontSize: 14,
                // decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (isLoading)
            const CircularProgressIndicator(), // Show loading spinner
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });

                try {

                  // Code Removed to be Revived Later


                  PhoneAuthCredential authCredential =
                      await PhoneAuthProvider.credential(
                          verificationId: widget.verificationId,
                          smsCode: otpController.text.toString());
                  UserCredential userCredential = await FirebaseAuth.instance
                      .signInWithCredential(authCredential);
                  if (userCredential.additionalUserInfo?.isNewUser ?? false) {
                    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).set({
                      'name': widget.name,
                      'phoneNumber': FirebaseAuth.instance.currentUser?.phoneNumber?.isNotEmpty == true
                          ? FirebaseAuth.instance.currentUser?.phoneNumber
                          : "N/A",
                    });
                  }
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen()));

                //   Removal Start
                //   const universalOtp = "123456"; // Universal OTP for mockup
                //   if (otpController.text == universalOtp) {
                //     // Simulate new user creation for signup
                //     if (widget.name.isNotEmpty) {
                //       // You can add caching logic here for storing user details
                //       print("User signed up with name: ${widget.name}");
                //     }
                //
                //     // Navigate to HomeScreen
                //     Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(builder: (context) => PhoneNumberLogger()),
                //     );
                //   } else {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //         content: Text("Invalid OTP"),
                //         duration: Duration(seconds: 4),
                //       ),
                //     );
                //   }


                  //   Removal End
                } catch (exception) {
                  String message = exception.toString();
                  if (exception is FirebaseAuthException) {
                    message = exception.message ?? message;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("VerificationFailed, Error: $message")),
                  );
                }
                setState(() {
                  isLoading = false;
                });
              },
              child: const Text("Confirm")),
        ],
      ),
    ));
  }
}
