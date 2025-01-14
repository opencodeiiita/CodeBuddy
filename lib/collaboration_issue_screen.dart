import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollaborationIssueScreen extends StatefulWidget {

  const CollaborationIssueScreen({super.key});

  @override
  State<CollaborationIssueScreen> createState() => _CollaborationIssueScreenState();
}

class _CollaborationIssueScreenState extends State<CollaborationIssueScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _collaboratorController = TextEditingController();
  final List<String> _collaborators = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _submitCollaborationIssue() {
    if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
      _firestore.collection('collaborationIssues').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'collaborators': _collaborators,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _titleController.clear();
      _descriptionController.clear();
      _collaboratorController.clear();
      setState(() => _collaborators.clear());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Collaboration issue created successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
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
            Text("Collaboration Title"),
            TextField(
              controller: _titleController,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(prefixIcon: Icon(Icons.playlist_add_check_circle_outlined),hintText: 'A good question',hintStyle: TextStyle(color: Colors.grey)),
            ),
            SizedBox(height: 32.0),

            Text("Description"),
            TextField(
              controller: _descriptionController,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(prefixIcon: Icon(Icons.description),hintText: 'Write something about the issue',hintStyle: TextStyle(color: Colors.grey)),
              minLines: 1,
              maxLines: 5,
              
            ),
            SizedBox(height: 32.0),
            Text("Add Collaborators"),
            TextField(
              controller: _collaboratorController,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(prefixIcon: Icon(Icons.person), hintText: 'Enter username or email to invite',hintStyle: TextStyle(color: Colors.grey),suffixIcon: IconButton(onPressed: () {
                if (_collaboratorController.text.isNotEmpty) {
                  setState(() => _collaborators.add(_collaboratorController.text));
                  _collaboratorController.clear();
                }
              }, icon: Icon(Icons.add_box_rounded))),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() => _collaborators.add(value));
                  _collaboratorController.clear();
                }
              },
              
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _collaborators.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(bottom: 15.0),
                    child: Material(
                      color: Colors.deepPurple.shade400,
                      borderRadius: BorderRadius.circular(25),
                      clipBehavior: Clip.antiAlias, 
                      child: ListTile(
                        title: Text(_collaborators[index], style: TextStyle(color: Colors.white),),
                        tileColor: Colors.deepPurple.shade400,
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            setState(() => _collaborators.removeAt(index));
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: _submitCollaborationIssue,
                child: const Text('Create Issue', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(57, 36, 72, 0.9),)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
