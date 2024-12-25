
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

class ProfilePage extends StatelessWidget {
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
      appBar: AppBar(title: Text('Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
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
                SizedBox(width: 16), // Space between picture and details
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
            SizedBox(height: 16),
            // Coding Stats Card
            CodingStatsCard(
              submissions: 234,
              challengesCompleted: 57,
              codingLanguages: ["Dart", "Python", "JavaScript", "C++"],
            ),
            SizedBox(height: 16),
            // Badges Slider (Imported widget)
            BadgesSlider(),
            SizedBox(height: 16),
            // LeetCode Progress Graph (Imported widget)
            LeetCodeProgressGraph(),
            SizedBox(height: 16),
            // Contribution Calendar Card (Imported widget)
            ContributionCalendarCard(contributionsData: contributionsData),
          ],
        ),
      ),
    );
  }
}
