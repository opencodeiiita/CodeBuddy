import 'package:codebuddy/home_screen.dart';
import 'package:codebuddy/collaboration_issue_screen.dart';
import 'package:codebuddy/signup_screen.dart';
import 'package:codebuddy/login_screen.dart';
import 'package:codebuddy/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:codebuddy/search_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // If you have Firebase options for your project

void main() {
  // Ensure Firebase is initialized and the orientation is locked to portrait mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp])
      .then((value) {
    _initializeFirebase(); // Initialize Firebase
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SearchProvider()),
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(57, 36, 72, 1),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: FutureBuilder<String?>(
        // Use FutureBuilder to load phone number and decide which screen to show
        future: loadPhoneNumber(),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Scaffold(
          //     body: Center(child: CircularProgressIndicator()),
          //   );
          // } else if (snapshot.hasData && snapshot.data != null) {
          //   // If phone number exists, navigate to HomeScreen
          //   return HomeScreen();
          // } else {
          //   // If no phone number, navigate to SignupScreen
          //   return HomeScreen();
          // }
          return CollaborationIssueScreen();
        },
      ),
    );
  }
}

// Firebase Initialization
_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

// Load phone number from SharedPreferences
Future<String?> loadPhoneNumber() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userPhoneNumber');
}
