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
  String? selectedId;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final urlManager = UrlManager();

  Future<void> fetchAdvertisements() async {
    String url = await urlManager.getValidBaseUrl();
    Uri uri = Uri.parse("$url/images/");

    var response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> adsJson = jsonDecode(response.body);

      setState(() {
        postedAds = adsJson.map((json) {
          Advertisement ad = Advertisement(
            id: json['id'],
            text: json['caption'],
            image: XFile("$url${json['image']}"),
            updated: DateTime.parse(json['updated']),
            validUntil: json['valid_until'] != null
                ? DateTime.parse(json['valid_until'])
                : null,
            postedBy: json['posted_by'] ?? 'Unknown',
          );

          if (ad.validUntil != null &&
              ad.validUntil!.isBefore(DateTime.now())) {
            deleteAdvertisement(ad.id);
          }

          return ad;
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
              postedBy: user?.displayName ?? 'Unknown'));
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

  Future<void> deleteAdvertisement(int? id) async {
    if (id != null) {
      String url = await urlManager.getValidBaseUrl();
      Uri uri = Uri.parse("$url/images/$id/delete");

      var response = await http.delete(uri);

      if (response.statusCode == 200) {
        print("Advertisement $id deleted successfully");
        fetchAdvertisements();
      } else {
        print("Failed to delete advertisement $id");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAdvertisements();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: Colors.green,
              width: 3.0,
            ),
          ),
          child: Column(
            children: [
              Text(
                'Post an Advertisement',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arial',
                ),
              ),
              TextFormField(
                controller: _adController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Caption/Details',
                ),
              ),
              SizedBox(height: 10),
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
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text('Pick Image'),
              ),
              SizedBox(height: 10),
              pickedImage == null
                  ? Text('No image selected.')
                  : Image.file(File(pickedImage!.path)),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: uploadImage,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text('Upload Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
