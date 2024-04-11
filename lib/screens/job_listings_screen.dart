import 'dart:io';
import 'package:flutter/material.dart';
import 'user_data.dart';
import 'job_detail_screen.dart';

class JobListingsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> jobListings; // List of job listings
  final UserData userData; // User data

  const JobListingsScreen({
    Key? key,
    required this.jobListings,
    required this.userData,
  }) : super(key: key);

  // Method to build circular avatar based on image path
  Widget buildCircularAvatar(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return CircleAvatar(
        backgroundImage: AssetImage(imagePath),
        radius: 24, // Adjust the radius as needed
      );
    } else {
      return CircleAvatar(
        backgroundImage: FileImage(File(imagePath)),
        radius: 24, // Adjust the radius as needed
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: jobListings.length,
        itemBuilder: (context, index) {
          final job = jobListings[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: buildCircularAvatar(job['companyLogo']), // Avatar
                title: Text(job['position']), // Job position
                subtitle: Text(job['company']), // Company name
                trailing: Icon(Icons.arrow_forward_ios), // Arrow icon
                onTap: () {
                  // Navigate to JobDetailScreen when tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailScreen(
                        job: job,
                        userData: userData,
                        index: index,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
