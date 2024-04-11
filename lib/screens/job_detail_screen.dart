import 'dart:io';

import 'package:flutter/material.dart';
import 'user_data.dart';

class JobDetailScreen extends StatefulWidget {
  final Map<String, dynamic> job; // Holds job details
  final UserData userData; // Holds user data
  final int index; // Index of the job in the list

  const JobDetailScreen({
    Key? key,
    required this.job,
    required this.userData,
    required this.index,
  }) : super(key: key);

  @override
  _JobDetailScreenState createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  late bool hasApplied; // Indicates whether the user has applied for the job

  @override
  void initState() {
    super.initState();
    // Initialize hasApplied based on whether the user has applied for the job
    hasApplied = widget.userData.jobListings[widget.index]["applied"];
  }

  // Method to build image widget based on image path
  Widget buildImageWidget(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(imagePath);
    } else {
      return Image.file(File(imagePath));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.job['position'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card to display job details
            Card(
              margin: EdgeInsets.symmetric(vertical: 16),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image of the company/logo
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: buildImageWidget(widget.job['companyLogo']),
                    ),
                  ),
                  // Job details
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          icon: Icons.business,
                          label: 'Company',
                          value: widget.job['company'],
                        ),
                        SizedBox(height: 12),
                        _buildDetailRow(
                          icon: Icons.work,
                          label: 'Position',
                          value: widget.job['position'],
                        ),
                        SizedBox(height: 12),
                        _buildDetailRow(
                          icon: Icons.location_on,
                          label: 'Location',
                          value: widget.job['experience'],
                        ),
                        SizedBox(height: 12),
                        _buildDetailRow(
                          icon: Icons.description,
                          label: 'Description',
                          value: widget.job['description'],
                          overflow: TextOverflow.visible,
                        ),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Apply Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Update hasApplied and apply job if not already applied
                    hasApplied = widget.userData.applyJobsUser(widget.index);
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    hasApplied ? Colors.grey : Colors.blue,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  child: Text(
                    hasApplied ? 'You have applied' : 'Apply Now',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build a row of job detail
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    TextOverflow? overflow,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.blue,
          size: 20,
        ),
        SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                    fontSize: 16, color: const Color.fromARGB(255, 0, 0, 0)),
                overflow: overflow,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
