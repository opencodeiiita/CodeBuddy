import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollaborationIssueScreen extends StatefulWidget {
  @override
  _CollaborationIssueScreenState createState() =>
      _CollaborationIssueScreenState();
}

class _CollaborationIssueScreenState extends State<CollaborationIssueScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController collaboratorController = TextEditingController();
  final List<String> collaborators = [];

  // Firebase Firestore instance
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void submitCollaborationIssue() async {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      try {
        await firestore.collection('collaboration_issues').add({
          'title': titleController.text,
          'description': descriptionController.text,
          'collaborators': collaborators,
          'created_at': DateTime.now(),
        });

        // Clear input fields and notify user
        titleController.clear();
        descriptionController.clear();
        collaboratorController.clear();
        collaborators.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Collaboration issue created successfully!')),
        );

        setState(() {}); // Update UI
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create issue: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title and Description are required!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Collaboration Issue'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Collaboration Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Collaboration Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: collaboratorController,
              decoration: InputDecoration(
                hintText: 'Enter username or email to invite',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    collaborators.add(value);
                  });
                  collaboratorController.clear();
                }
              },
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: collaborators.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(collaborators[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          collaborators.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 11),
            Center(
              child: ElevatedButton(
                onPressed: submitCollaborationIssue,
                child: Text('Submit Collaboration Issue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
