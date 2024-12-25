import 'package:flutter/material.dart';

class ProfileDetailsCard extends StatelessWidget {
  final String name;
  final String email;
  final String bio;

  ProfileDetailsCard({
    required this.name,
    required this.email,
    this.bio = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(57, 36, 72, 1),
            Color.fromRGBO(57, 36, 72, 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.pink[100],
            ),
          ),
          SizedBox(height: 8),
          Text(
            email,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          if (bio.isNotEmpty) ...[
            SizedBox(height: 16),
            Text(
              "About Me 👋 :",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              bio,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
