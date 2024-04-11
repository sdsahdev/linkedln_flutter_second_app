import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'user_data.dart'; // Import the UserData class to access the jobListings list

class CreatePostScreen extends StatefulWidget {
  final UserData userData;
  final Function(List<Map<String, dynamic>>) onUpdate;

  const CreatePostScreen(
      {Key? key, required this.userData, required this.onUpdate})
      : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late GlobalKey<FormState> _postFormKey =
      GlobalKey<FormState>(); // GlobalKey for Post form
  late GlobalKey<FormState> _createJobFormKey =
      GlobalKey<FormState>(); // GlobalKey for Create Job form

  String _postType = 'Post';
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  final _experienceController = TextEditingController();
  File? _postImage; // Separate image variable for Post Job section
  File? _createJobImage; // Separate image variable for Create Job section

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: TabBar(
            tabs: [
              Tab(text: 'Post Job'),
              Tab(text: 'Create Job'),
            ],
          ),
          body: TabBarView(
            children: [
              _buildPostForm(),
              _buildCreateJobForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _postFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _showImagePicker('post');
                  },
                  child: Text('Select Image'),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: _postImage != null
                    ? Container(
                        height: 100,
                        width: 100,
                        child: Image.file(
                          _postImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_postFormKey.currentState!.validate()) {
                      _submitPost();
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateJobForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _createJobFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _companyController,
                decoration: InputDecoration(labelText: 'Company Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a company name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _positionController,
                decoration: InputDecoration(labelText: 'Position'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a company Position';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _experienceController,
                decoration: InputDecoration(labelText: 'experience'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a company name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _showImagePicker('createJob');
                  },
                  child: Text('Select Company Logo'),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: _createJobImage != null
                    ? Container(
                        height: 100,
                        width: 100,
                        child: Image.file(
                          _createJobImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_createJobFormKey.currentState!.validate()) {
                      // Change _formKey to _createJobFormKey
                      _submitJobListing();
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePicker(String section) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        if (section == 'post') {
          _postImage = File(pickedImage.path);
        } else if (section == 'createJob') {
          _createJobImage = File(pickedImage.path);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  void _submitPost() async {
    String description = _descriptionController.text;

    // Check if an image has been selected
    if (_postImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    // Create a new post map with String values
    Map<String, String> newPost = {
      'description': description,
      'post': _postImage!.path,
    };
    // Update the 'posts' list of the 'lara leniy' candidate
    int lemonaIndex = widget.userData.candidates
        .indexWhere((candidate) => candidate['name'] == 'lara leniy');
    if (lemonaIndex != -1) {
      widget.userData.candidates[lemonaIndex]['posts'].insert(0, newPost);

      await _savepostToSharedPreferences(widget.userData.candidates);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Candidate "lara leniy" not found')),
      );
      return; // Exit the method if candidate 'lemona' is not found
    }

    // Clear the description field
    _descriptionController.clear();
    setState(() {
      _postImage = null;
    });
    widget.onUpdate(widget.userData.candidates);

    // Navigate back to the home screen
    // Navigator.pop(context);
    Navigator.popUntil(context, ModalRoute.withName('/'));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Post submitted successfully')),
    );
  }

  void _submitJobListing() async {
    String company = _companyController.text;
    String position = _positionController.text;
    String experience = _experienceController.text;
    String description = _descriptionController.text;

    // Check if any fields are empty
    if (company.isEmpty || position.isEmpty || experience.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return; // Exit the method if any field is empty
    }

    // Check if an image has been selected
    if (_createJobImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    // Create a new job listing map
    Map<String, dynamic> newJobListing = {
      'company': company,
      'position': position,
      'companyLogo': _createJobImage!.path,
      'experience': experience,
      'description': description,
      'applied': false,
    };

    // Add the new job listing to the jobListings list
    widget.userData.jobListings.add(newJobListing);
    await _saveJobListingsToSharedPreferences(widget.userData.jobListings);
    // Navigator.pop(context, newJobListing);
    Navigator.popUntil(context, ModalRoute.withName('/'));

    // Clear the text fields and reset the image
    _companyController.clear();
    _positionController.clear();
    _experienceController.clear();
    _descriptionController.clear();
    setState(() {
      _createJobImage = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Job listing submitted successfully')),
    );
  }

// Method to save job listings data to SharedPreferences
  Future<void> _saveJobListingsToSharedPreferences(
      List<Map<String, dynamic>> jobListings) async {
    // Serialize the job listings data to JSON
    String jobListingsJson = jsonEncode(jobListings);

    // Get the SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the serialized job listings data to SharedPreferences
    await prefs.setString('jobListings', jobListingsJson);
  }

  Future<void> _savepostToSharedPreferences(
      List<Map<String, dynamic>> candidates) async {
    // Serialize the job listings data to JSON
    String candidatesJson = jsonEncode(candidates);

    // Get the SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the serialized job listings data to SharedPreferences
    await prefs.setString('candidates', candidatesJson);
  }
}
