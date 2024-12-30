
import 'package:codebuddy/login_screen.dart';
import 'package:codebuddy/signup_screen.dart';
import 'package:codebuddy/start_screen.dart';
import 'package:codebuddy/provider.dart';
import 'package:provider/provider.dart';
import 'package:codebuddy/search_provider.dart';
import 'package:codebuddy/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';
import 'home_screen.dart';

import 'package:flutter/material.dart';

// Version 3.0

import 'package:flutter/material.dart';
import 'widgets/profile_details_card.dart';
import 'widgets/profile_picture_box.dart';
import 'widgets/coding_stats_card.dart';
import 'widgets/badges_slider.dart';  // Import the badges slider widget
import 'widgets/progress_graph.dart';  // Import the LeetCode progress graph widget
import 'widgets/contribution_calendar_card.dart';  // Import the Contribution Calendar Card

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import

class ProfilePage extends StatelessWidget {
  // Function to clear the stored phone number from SharedPreferences
  Future<void> _clearPhoneNumber(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userPhoneNumber'); // Remove the stored phone number
    // Show a confirmation message and navigate to the login screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logged out successfully")),
    );
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => const LoginScreen()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    // Sample data for the contribution calendar (12 months, each with 4 weeks)
    final contributionsData = List.generate(12, (monthIndex) {
      return List.generate(30, (dayIndex) {
        // Random contribution count between 0 and 25 (for illustration)
        return (monthIndex + 1) * (dayIndex + 1) % 25;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _clearPhoneNumber(context), // Call the logout method
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture Box
                ProfilePictureBox(
                  profileImageUrl: "https://cdn-icons-png.freepik.com/512/4209/4209019.png",
                ),
                const SizedBox(width: 16), // Space between picture and details
                // Profile Details Card
                Expanded(
                  child: ProfileDetailsCard(
                    name: "Virat Kohli",
                    email: "vk18lord@gmail.com",
                    bio: "A passionate Flutter developer.",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Coding Stats Card
            CodingStatsCard(
              submissions: 234,
              challengesCompleted: 57,
              codingLanguages: ["Dart", "Python", "JavaScript", "C++"],
            ),
            const SizedBox(height: 16),
            // Badges Slider (Imported widget)
            BadgesSlider(),
            const SizedBox(height: 16),
            // LeetCode Progress Graph (Imported widget)
            LeetCodeProgressGraph(),
            const SizedBox(height: 16),
            // Contribution Calendar Card (Imported widget)
            ContributionCalendarCard(contributionsData: contributionsData),

            // Add the LeetCode dialog box section here
            const SizedBox(height: 32),
            LeetCodeDialogBox(),
          ],
        ),
      ),
    );
  }
}

class LeetCodeDialogBox extends StatefulWidget {
  @override
  _LeetCodeDialogBoxState createState() => _LeetCodeDialogBoxState();
}

class _LeetCodeDialogBoxState extends State<LeetCodeDialogBox> {
  String? leetCodeUsername;
  Map<String, dynamic>? userData;

  // Function to fetch data from the LeetCode API
  Future<void> _fetchUserData() async {
    if (leetCodeUsername == null || leetCodeUsername!.isEmpty) {
      return;
    }

    final url = 'https://leetcode-stats-api.onrender.com/$leetCodeUsername'; // API URL format
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userData = data['data']; // Store the 'data' key from the response
        });
      } else {
        // Handle API error
        print('Failed to load user data');
        setState(() {
          userData = null;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        userData = null;
      });
    }
  }

  // Function to clear the username and stats
  void _clearStats() {
    setState(() {
      leetCodeUsername = null;
      userData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Username Input Section
          if (leetCodeUsername == null || userData == null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter LeetCode Username:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      leetCodeUsername = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter username",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _fetchUserData,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Submit'),
                ),
              ],
            ),
          const SizedBox(height: 20),

          // Display Stats if Data is Available
          if (userData != null) ...[
            // Profile Section
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(userData!['avatar'] ?? ''),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Username: ${userData!['name']}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
            ),
            Center(
              child: Text('Rank: ${userData!['rank']}', style: const TextStyle(fontSize: 16, color: Colors.blueGrey)),
            ),
            const SizedBox(height: 20),

            // Problem Stats Section
            Text(
              'Total Problems: ${userData!['totalProblems']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            Text(
              'Total Solved: ${userData!['totalSolved']}',
              style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
            const SizedBox(height: 10),
            // Difficulty Breakdown
            _buildDifficultyStat('Easy', userData!['easy']),
            _buildDifficultyStat('Medium', userData!['medium']),
            _buildDifficultyStat('Hard', userData!['hard']),
            const SizedBox(height: 20),

            // Contest Ranking Section
            if (userData!['contestRanking'] != null)
              Text(
                'Contest Ranking: ${userData!['contestRanking']}',
                style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
            const SizedBox(height: 20),

            // Language Stats Section
            if (userData!['languageStats'] != null &&
                userData!['languageStats'].isNotEmpty)
              const Text(
                'Languages Stats: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
            ...userData!['languageStats'].map<Widget>((languageStat) {
              return Text(
                '${languageStat['languageName']}: ${languageStat['problemsSolved']} solved',
                style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
              );
            }).toList(),

            const SizedBox(height: 20),
            // Change Username Button
            ElevatedButton(
              onPressed: _clearStats,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Change Username'),
            ),
          ],
        ],
      ),
    );
  }

  // Helper method to style difficulty stats
  Widget _buildDifficultyStat(String difficulty, Map<String, dynamic> stats) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        '$difficulty Problems: ${stats['solved']} solved out of ${stats['total']} (Beats ${stats['beatsPercentage']}%)',
        style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
      ),
    );
  }
}