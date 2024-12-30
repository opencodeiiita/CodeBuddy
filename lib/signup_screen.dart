import 'package:codebuddy/background.dart';
import 'package:codebuddy/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Signup"),
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
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      helperStyle: const TextStyle(fontSize: 10),
                      hintText: "Enter Your Name",
                      prefixIcon:
                      const Icon(Icons.person, applyTextScaling: true),
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24))),
                ),
              ),
              const SizedBox(height: 10),
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
                      prefixIcon:
                      const Icon(Icons.phone, applyTextScaling: true),
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24))),
                ),
              ),
              const SizedBox(height: 15),
              if (isLoading)
                const CircularProgressIndicator(), // Show loading spinner
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () async {
                    if (isLoading) return;
                    if (nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Error: Name field cannot be empty"),
                            duration: Durations.extralong4),
                      );
                      return;
                    }
                    if (phoneNumberController.text.isEmpty ||
                        phoneNumberController.text.length != 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Error: Phone number field cannot be empty and should be 10 lengths long."),
                          duration: Durations.extralong4,
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
                    // await Future.delayed(const Duration(seconds: 1)); // Simulate delay for mockup

                    // Save phone number to SharedPreferences
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('userPhoneNumber', phoneNumberController.text);

                    // Log after saving to SharedPreferences
                    print("Phone number saved to SharedPreferences: ${prefs.getString('userPhoneNumber')}");

                    // Navigation to OTP screen
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
                        },
                        codeSent: (String verificationId, int? resendToken) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OtpScreen(
                                      verificationId: verificationId,
                                      name: nameController.text.isNotEmpty ? nameController.text : "Code Buddy"
                                  )));
                          setState(() {
                            isLoading = false;
                          });
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                        phoneNumber:
                        "+91${phoneNumberController.text}"); //todo allow different codes

                    // Removal End
                  },
                  child: const Text("Send OTP")),
            ],
          ),
        ));
  }
}
