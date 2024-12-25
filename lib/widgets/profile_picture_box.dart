import 'package:flutter/material.dart';

class ProfilePictureBox extends StatelessWidget {
  final String profileImageUrl;

  ProfilePictureBox({this.profileImageUrl = ""});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Assuming the ProfileDetailsCard height is calculated beforehand and passed here
        double cardHeight = 140; // Replace with a variable if needed
        return Padding(
          padding: const EdgeInsets.only(top: 16.0), // Add top padding here
          child: Container(
            width: cardHeight * 0.75, // Proportional width for a rectangular look
            height: cardHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0), // Rounded rectangle
              color: Colors.grey[300], // Placeholder background color
              image: profileImageUrl.isNotEmpty
                  ? DecorationImage(
                image: NetworkImage(profileImageUrl),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: profileImageUrl.isEmpty
                ? Icon(Icons.person, size: cardHeight * 0.4, color: Colors.grey[700]) // Default icon
                : null,
          ),
        );
      },
    );
  }
}
