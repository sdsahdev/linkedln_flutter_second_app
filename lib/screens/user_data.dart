import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  late SharedPreferences _prefs;

  UserData({required SharedPreferences prefs}) {
    _prefs = prefs;
  }

  List<Map<String, dynamic>> candidates = [
    {
      "name": "lara leniy",
      "position": "Software Developer",
      "profileImage": "assets/images/post4.jpeg",
      "age": 28,
      "dob": "1996-05-20",
      "education": "BSc in Computer Science",
      "mobile": "+1234567890",
      "email": "lara.leniy@example.com",
      "posts": [
        {
          "description": "Sunset at the beach",
          "post": "assets/images/nature1.jpeg"
        }
      ],
      "isConnected": true
    },
    {
      "name": "netem Smith",
      "position": "Software Engineer",
      "profileImage": "assets/images/post5.jpg",
      "age": 33,
      "dob": "1991-09-12",
      "education": "Master's in Computer Engineering",
      "mobile": "+1987654321",
      "email": "netem.smith@example.com",
      "posts": [
        {
          "description": "Morning fog in the forest",
          "post": "assets/images/nature2.jpeg"
        },
        {
          "description": "Starry night sky",
          "post": "assets/images/nature3.jpeg"
        }
      ],
      "isConnected": false
    },
    {
      "name": "Alice Johnson",
      "position": "Software Developer",
      "profileImage": "assets/images/post6.jpg",
      "age": 25,
      "dob": "1999-12-30",
      "education": "Bachelor's in Information Technology",
      "mobile": "+1122334455",
      "email": "alice.johnson@example.com",
      "posts": [
        {
          "description": "Rainbow over the city",
          "post": "assets/images/nature4.jpeg"
        }
      ],
      "isConnected": true
    }
  ];
  List<Map<String, dynamic>> jobListings = [
    {
      'company': 'Linkedin',
      'position': 'Engineer',
      'companyLogo': 'assets/images/job1.png',
      'experience': 'USA',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'applied': false,
    },
    {
      'company': 'FaceBook',
      'position': 'Flutter Developer',
      'companyLogo': 'assets/images/job2.png',
      'experience': 'India',
      'description':
          'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'applied': false,
    },
  ];

  // List<String> applyJobsList = [];

  // Method to save data to SharedPreferences
  Future<void> saveDataToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    String candidatesJson = jsonEncode(candidates);
    await prefs.setString('candidates', candidatesJson);

    String jobListingsJson = jsonEncode(jobListings);
    await prefs.setString('jobListings', jobListingsJson);
  }

  // Method to load data from SharedPreferences

  // Method to load data from SharedPreferences
  Future<void> loadDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    String? candidatesJson = prefs.getString('candidates');
    if (candidatesJson != null && candidatesJson.isNotEmpty) {
      candidates = List<Map<String, dynamic>>.from(jsonDecode(candidatesJson));
    } else {
      candidates = candidates;
    }

    String? jobListingsJson = prefs.getString('jobListings');
    if (jobListingsJson != null && jobListingsJson.isNotEmpty) {
      jobListings =
          List<Map<String, dynamic>>.from(jsonDecode(jobListingsJson));
    } else {
      jobListings = jobListings;
    }
  }

  // Method to connect/disconnect user

  Function(List<String>)? onUpdatePosts;
  void connectDisconnectUser(int index) {
    if (candidates[index]['isConnected']) {
      candidates[index]['isConnected'] = false;
    } else {
      candidates[index]['isConnected'] = true;
    }
    saveDataToSharedPreferences();
  }

  // Method to apply/unapply for jobs
  bool applyJobsUser(int index) {
    // Check if the job is already applied
    bool isApplied = jobListings[index]['applied'];
    print(isApplied);
    // If applied, mark it as unapplied and remove it from the applyJobsList
    if (isApplied) {
      jobListings[index]['applied'] = false;
    } else {
      // If not applied, mark it as applied
      jobListings[index]['applied'] = true;
    }

    // Save the updated data to SharedPreferences
    saveDataToSharedPreferences();

    // Return whether the job is applied or not
    return !isApplied;
  }
}
