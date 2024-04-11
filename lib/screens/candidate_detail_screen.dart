import 'dart:io';

import 'package:flutter/material.dart';
import 'user_data.dart';

class CandidateDetailScreen extends StatelessWidget {
  final Map<String, dynamic> candidate; // Holds candidate data
  final UserData userData; // Holds user data
  final Function(List<Map<String, dynamic>>)
      onUpdateCandidates; // Callback function to update candidates
  final int index; // Index of the candidate in the list

  const CandidateDetailScreen({
    Key? key,
    required this.candidate,
    required this.userData,
    required this.onUpdateCandidates,
    required this.index,
  }) : super(key: key);

  // Widget to display image, either asset or file
  Widget buildImageWidget(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      // If image is an asset
      return Image.asset(
        imagePath,
        width: double.infinity,
        fit: BoxFit.contain,
        height: 200,
      );
    } else {
      // If image is a file
      return Image.file(
        File(imagePath),
        width: double.infinity,
        fit: BoxFit.contain,
        height: 200,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isConnected =
        candidate['isConnected']; // Check if candidate is connected
    return Scaffold(
      appBar: AppBar(
        title: Text('Candidate Detail'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display candidate profile image
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: buildImageWidget(candidate['profileImage']),
              ),
            ),
            SizedBox(height: 20),
            // Display candidate name
            Text(
              candidate['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Display candidate position
            Text(
              candidate['position'],
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            // Display candidate details
            _buildDetailRow('Age', candidate['age'].toString()),
            _buildDetailRow('Date of Birth', candidate['dob']),
            _buildDetailRow('Education', candidate['education']),
            _buildDetailRow('Mobile', candidate['mobile']),
            _buildDetailRow('Email', candidate['email']),
            SizedBox(height: 20),
            // Button to connect/disconnect candidate
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Connect/disconnect candidate and update candidates
                    userData.connectDisconnectUser(index);
                    onUpdateCandidates(userData
                        .candidates); // Passing the updated list of candidates
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 238, 182, 240),
                  ),
                  child: Text(isConnected ? 'Disconnect' : 'Connect'),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Display candidate posts
            Text(
              'Posts:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: candidate['posts'].map<Widget>((post) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display post image
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: buildImageWidget(post['post']),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          post['description'], // Display post description
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build a row for candidate details
  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title + ':  ',
          style: TextStyle(fontSize: 16),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
