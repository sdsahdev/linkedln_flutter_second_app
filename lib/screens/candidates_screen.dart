import 'package:flutter/material.dart';
import 'user_data.dart';
import 'candidate_detail_screen.dart';

class CandidatesScreen extends StatelessWidget {
  final UserData userData; // Holds user data
  final Function(List<Map<String, dynamic>>)
      onUpdateCandidates; // Callback function to update candidates

  const CandidatesScreen({
    Key? key,
    required this.userData,
    required this.onUpdateCandidates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: userData.candidates.length, // Total number of candidates
        itemBuilder: (context, index) {
          final candidate = userData.candidates[index]; // Get candidate data
          return Card(
            elevation: 3,
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(candidate[
                    'profileImage']), // Display candidate profile image
              ),
              title: Text(
                candidate['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle:
                  Text(candidate['position']), // Display candidate position
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CandidateDetailScreen(
                      candidate:
                          candidate, // Pass candidate data to detail screen
                      userData: userData,
                      onUpdateCandidates: onUpdateCandidates,
                      index: index,
                    ),
                  ),
                );
              },
              trailing: Icon(
                  Icons.arrow_forward), // Display arrow icon for navigation
            ),
          );
        },
      ),
    );
  }
}
