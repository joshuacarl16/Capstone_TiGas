import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:tigas_application/providers/url_manager.dart';
import 'package:tigas_application/widgets/show_snackbar.dart';

class Advertisement {
  final int? id;
  final String text;
  final XFile image;
  final DateTime updated;
  final DateTime? validUntil;
  final String postedBy;

  Advertisement({
    this.id,
    required this.text,
    required this.image,
    required this.updated,
    this.validUntil,
    required this.postedBy,
  });
}

class PostAdvertisement extends StatefulWidget {
  @override
  _PostAdvertisementState createState() => _PostAdvertisementState();
}

class _PostAdvertisementState extends State<PostAdvertisement> {
  final TextEditingController _adController = TextEditingController();
  List<Advertisement> postedAds = [];
  XFile? pickedImage;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final urlManager = UrlManager();

  @override
  void initState() {
    super.initState();
    fetchAdvertisements();
  }

  Future<void> fetchAdvertisements() async {
    String url = await urlManager.getValidBaseUrl();
    Uri uri = Uri.parse("$url/images/");

    var response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> adsJson = jsonDecode(response.body);

      setState(() {
        postedAds = adsJson.map((json) {
          return Advertisement(
            id: json['id'],
            text: json['caption'],
            image: XFile("$url${json['image']}"),
            updated: DateTime.parse(json['updated']),
            validUntil: json['valid_until'] != null
                ? DateTime.parse(json['valid_until'])
                : null,
            postedBy: json['posted_by'] ?? 'Unknown',
          );
        }).toList();
      });
    } else {
      throw Exception('Failed to load advertisements');
    }
  }

  Future<void> uploadImage() async {
    if (pickedImage != null && _adController.text.isNotEmpty) {
      String url = await urlManager.getValidBaseUrl();
      Uri uri = Uri.parse("$url/upload_image/");
      var request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath('image', pickedImage!.path),
      );

      request.fields['caption'] = _adController.text;

      request.fields['valid_until'] = selectedDate != null
          ? DateFormat('yyyy-MM-dd HH:mm').format(selectedDate!)
          : '';

      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String role = await getUserRole(user.uid);
        request.fields['posted_by'] = role;
      } else {
        request.fields['posted_by'] = 'Unknown';
      }

      var response = await request.send();

      if (response.statusCode == 201) {
        var responseData = await response.stream.bytesToString();
        var decodedData = jsonDecode(responseData);
        DateTime updated = DateTime.parse(decodedData['updated']);

        setState(() {
          postedAds.add(Advertisement(
            text: _adController.text,
            image: pickedImage!,
            updated: updated,
            postedBy: user?.displayName ?? 'Unknown',
          ));
          _adController.clear();
        });
        showSnackBar(context, 'Image uploaded');
      } else {
        showSnackBar(context, 'Image upload failed');
      }
    }
  }

  Future<String> getUserRole(String uid) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((snapshot) {
      return snapshot.data()?['role'] ?? 'Unknown';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Caption/Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _adController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTime ?? TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedDate = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        selectedTime = pickedTime;
                      });
                    }
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: TextEditingController(
                      text: selectedDate != null
                          ? DateFormat('yyyy-MM-dd HH:mm').format(selectedDate!)
                          : '',
                    ),
                    decoration: InputDecoration(
                      labelText: 'Valid Until',
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final ImagePicker _picker = ImagePicker();
                  XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      pickedImage = image;
                    });
                  }
                },
                child: Text('Pick Image'),
              ),
              SizedBox(height: 16),
              pickedImage == null
                  ? Text('No image selected.')
                  : Image.file(File(pickedImage!.path)),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: uploadImage,
                child: Text('Upload Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
