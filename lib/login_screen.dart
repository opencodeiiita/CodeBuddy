import 'package:codebuddy/background.dart';
import 'package:codebuddy/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                textAlign: TextAlign.center,
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                controller: phoneNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  helperStyle: const TextStyle(fontSize: 15),
                  hintText: "Enter Phone Number",
                  prefixIcon: const Icon(Icons.phone, applyTextScaling: true),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            if (isLoading)
              const CircularProgressIndicator(), // Show loading spinner
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                if (isLoading) return;
                if (phoneNumberController.text.isEmpty ||
                    phoneNumberController.text.length != 10) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Error: Phone number field cannot be empty and should be 10 digits long.",
                      ),
                      duration: Duration(seconds: 4),
                    ),
                  );
                  return;
                }
                setState(() {
                  isLoading = true;
                });

                // Log the phone number before saving
                print("Phone number entered: ${phoneNumberController.text}");

                // Removal Start
                await Future.delayed(const Duration(seconds: 1)); // Simulate delay for mockup

                // Save phone number to SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('userPhoneNumber', phoneNumberController.text);

                // Log after saving to SharedPreferences
                print("Phone number saved to SharedPreferences: ${prefs.getString('userPhoneNumber')}");

                // Navigation to OTP screen with the default name "Usr"
                // Code Commented to Revive Later
                // Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(verificationId: "verificationId",)));
                await FirebaseAuth.instance.verifyPhoneNumber(
                    verificationCompleted:
                        (PhoneAuthCredential credential) {},
                    verificationFailed: (FirebaseAuthException ex) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "VerificationFailed, Error: ${ex.toString()}")),
                      );
                      setState(() {
                        isLoading = false;
                      });
                      // throw ex;
                    },
                    codeSent: (String verificationId, int? resendToken) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OtpScreen(
                                    verificationId: verificationId,
                                  )));
                      setState(() {
                        isLoading = false;
                      });
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                    phoneNumber: "+91${phoneNumberController.text}");
                // Removal End
              },
              child: const Text("Send OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
