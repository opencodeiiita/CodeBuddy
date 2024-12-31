import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'widgets/profile_details_card.dart';
import 'widgets/profile_picture_box.dart';
import 'widgets/coding_stats_card.dart';
import 'widgets/badges_slider.dart';
import 'widgets/progress_graph.dart';
import 'widgets/contribution_calendar_card.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _clearPhoneNumber(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userPhoneNumber');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logged out successfully")),
    );
  }

  String email = "vk18lord@gmail.com";
  String name = "Virat Kohli";
  String bio = "A passionate Flutter developer.";
  String profileImageUrl = "https://cdn-icons-png.freepik.com/512/4209/4209019.png";

  void updateProfileDetails({
    required String newEmail,
    required String newName,
    required String newBio,
    required String newProfileImageUrl,
  }) {
    setState(() {
      email = newEmail;
      name = newName;
      bio = newBio;
      profileImageUrl = newProfileImageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    final contributionsData = List.generate(12, (monthIndex) {
      return List.generate(30, (dayIndex) {
        return (monthIndex + 1) * (dayIndex + 1) % 25;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _clearPhoneNumber(context),
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
                ProfilePictureBox(profileImageUrl: profileImageUrl),
                const SizedBox(width: 16),
                Expanded(
                  child: ProfileDetailsCard(
                    name: name,
                    email: email,
                    bio: bio,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LeetCodeDialogBox(
              onUpdateProfileDetails: ({
                required String newEmail,
                required String newName,
                required String newBio,
                required String newProfileImageUrl,
              }) {
                updateProfileDetails(
                  newEmail: newEmail,
                  newName: newName,
                  newBio: newBio,
                  newProfileImageUrl: newProfileImageUrl,
                );
              },
            ),
            const SizedBox(height: 16),
            CodingStatsCard(
              submissions: 234,
              challengesCompleted: 57,
              codingLanguages: ["Dart", "Python", "JavaScript", "C++"],
            ),
            const SizedBox(height: 16),
            BadgesSlider(),
            const SizedBox(height: 16),
            LeetCodeProgressGraph(),
            const SizedBox(height: 16),
            ContributionCalendarCard(contributionsData: contributionsData),
          ],
        ),
      ),
    );
  }
}

class LeetCodeDialogBox extends StatefulWidget {
  final Function({
  required String newEmail,
  required String newName,
  required String newBio,
  required String newProfileImageUrl,
  }) onUpdateProfileDetails;

  const LeetCodeDialogBox({Key? key, required this.onUpdateProfileDetails}) : super(key: key);

  @override
  _LeetCodeDialogBoxState createState() => _LeetCodeDialogBoxState();
}

class _LeetCodeDialogBoxState extends State<LeetCodeDialogBox> {
  String? leetCodeUsername;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _checkUsernameAndShowDialog();
  }

  Future<void> _checkUsernameAndShowDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    leetCodeUsername = prefs.getString('leetCodeUsername');

    if (leetCodeUsername == null || leetCodeUsername!.isEmpty) {
      Future.delayed(Duration.zero, () => _showUsernameInputDialog());
    } else {
      await _fetchUserData();
    }
  }

  Future<void> _showUsernameInputDialog() async {
    String tempUsername = "";

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter LeetCode Username'),
          content: TextField(
            onChanged: (value) {
              tempUsername = value;
            },
            decoration: const InputDecoration(
              hintText: "Enter your LeetCode username",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (tempUsername.isNotEmpty) {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString('leetCodeUsername', tempUsername);
                  setState(() {
                    leetCodeUsername = tempUsername;
                  });
                  Navigator.of(context).pop();
                  await _fetchUserData();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchUserData() async {
    if (leetCodeUsername == null || leetCodeUsername!.isEmpty) return;

    final url = 'https://leetcode-stats-api.onrender.com/$leetCodeUsername';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userData = data['data'];
        });

        final newEmail = userData?['username'] ?? "default@gmail.com";
        final newName = userData?['name'] ?? "Default User";
        final newBio = userData?['rank'] != null ? "Rank: ${userData!['rank']}" : "No Rank Data";
        final newProfileImageUrl = userData?['avatar'] ?? "https://cdn-icons-png.freepik.com/512/4209/4209019.png";

        widget.onUpdateProfileDetails(
          newEmail: newEmail,
          newName: newName,
          newBio: newBio,
          newProfileImageUrl: newProfileImageUrl,
        );
      } else {
        await _clearUsernameAndRetry();
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }


  Future<void> _clearUsernameAndRetry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('leetCodeUsername');
    setState(() {
      leetCodeUsername = null;
      userData = null;
    });
    Future.delayed(Duration.zero, () => _showUsernameInputDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (userData != null)
          LeetCodeStatsCard(
            totalSolved: userData?['totalSolved'] ?? 0,
            totalProblems: userData?['totalQuestions'] ?? 20,
            easySolved: userData?['easy']?['solved'] ?? 0,
            easyTotal: userData?['easy']?['total'] ?? 20,
            mediumSolved: userData?['medium']?['solved'] ?? 0,
            mediumTotal: userData?['medium']?['total'] ?? 20,
            hardSolved: userData?['hard']?['solved'] ?? 0,
            hardTotal: userData?['hard']?['total'] ?? 20,
          ),
        ElevatedButton(
          onPressed: () => _clearUsernameAndRetry(),
          child: const Text('Change Username'),
        ),
      ],
    );
  }
}

class LeetCodeStatsCard extends StatelessWidget {
  final int totalSolved;
  final int totalProblems;
  final int easySolved;
  final int easyTotal;
  final int mediumSolved;
  final int mediumTotal;
  final int hardSolved;
  final int hardTotal;

  const LeetCodeStatsCard({
    required this.totalSolved,
    required this.totalProblems,
    required this.easySolved,
    required this.easyTotal,
    required this.mediumSolved,
    required this.mediumTotal,
    required this.hardSolved,
    required this.hardTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "LeetCode Stats",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatItem(
                label: "Total Solved",
                value: "$totalSolved/$totalProblems",
                valueColor: Colors.blueAccent,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DifficultyStatItem(
                label: "Easy",
                solved: easySolved,
                total: easyTotal,
                color: Colors.green,
              ),
              DifficultyStatItem(
                label: "Medium",
                solved: mediumSolved,
                total: mediumTotal,
                color: Colors.orange,
              ),
              DifficultyStatItem(
                label: "Hard",
                solved: hardSolved,
                total: hardTotal,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const StatItem({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class DifficultyStatItem extends StatelessWidget {
  final String label;
  final int solved;
  final int total;
  final Color color;

  const DifficultyStatItem({
    required this.label,
    required this.solved,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "$solved/$total",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
