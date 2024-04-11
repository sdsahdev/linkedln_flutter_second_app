import 'package:flutter/material.dart';
import 'package:job_finder/screens/candidates_screen.dart';
import 'package:job_finder/screens/home_screen.dart';
import 'package:job_finder/screens/job_listings_screen.dart';
import 'package:job_finder/screens/createPostScreen.dart';
import 'package:job_finder/screens/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  UserData userData = UserData(prefs: prefs);
  await userData.loadDataFromSharedPreferences();
  runApp(MyApp(userData: userData));
}

class MyApp extends StatelessWidget {
  final UserData userData;

  const MyApp({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Job Portal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // Hide debug banner
      home: MyHomePage(userData: userData),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final UserData userData;

  const MyHomePage({Key? key, required this.userData}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    // List of screens to navigate based on the selected index
    List<Widget> _screens = [
      HomeScreen(userData: widget.userData), // Home Screen
      CandidatesScreen(
        userData: widget.userData,
        onUpdateCandidates: _updatePosts, // Pass the correct function here
      ),
// Candidates Screen
      JobListingsScreen(
        jobListings: widget.userData.jobListings,
        userData: widget.userData,
      ), // Job Listings Screen
      CreatePostScreen(
        userData: widget.userData,
        onUpdate: updateCandidates,
      ), // Create Post Screen
    ];

    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0; // Navigate to Home Screen if not already on it
          });
          return false; // Prevent the app from closing
        }
        return true; // Allow the app to close
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Job Portal'), // App Bar Title
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Display the first user's circular image
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/post4.jpeg'),
                      radius: 30, // Adjust the radius as needed
                    ),
                    SizedBox(height: 10),
                    // Display the name of the first user
                    Text(
                      'lara leniy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'), // Home Screen Navigation
                onTap: () => _onItemSelected(0),
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('All Candidates'), // Candidates Screen Navigation
                onTap: () => _onItemSelected(1),
              ),
              ListTile(
                leading: Icon(Icons.work),
                title: Text('Job List'), // Job Listings Screen Navigation
                onTap: () => _onItemSelected(2),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Post Jobs'), // Create Post Screen Navigation
                onTap: () => _onItemSelected(3),
              ),
            ],
          ),
        ),
        body: _screens[_selectedIndex], // Display selected screen
      ),
    );
  }

  // Function to update the user's posts
  void _updatePosts(List<Map<String, dynamic>> updatedCandidates) {
    setState(() {
      widget.userData.candidates = updatedCandidates;
    });
  }

  // Function to update the list of candidates
  void updateCandidates(List<Map<String, dynamic>> updatedCandidates) {
    setState(() {
      widget.userData.candidates = updatedCandidates;
    });
  }
}
