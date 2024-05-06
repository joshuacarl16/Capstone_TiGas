import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tigas_application/notification/notif_services.dart';
import 'package:tigas_application/notification/notification_service.dart';

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
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    fetchAdvertisements();
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value){
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
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
      String userRole = await getUserRole(user?.uid ?? '');
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

        notificationServices.getDeviceToken().then((value)async{
            List<String> tokens = await getAllFCMTokens();
            for (String token in tokens) {
            var data = {
              'to' : token,
              'priority' : 'high',
              'notification' : {
                'title' : 'TiGAS' ,
                'body' : '$userRole just dropped a new promotion!' ,
            },
              'android': {
                'notification': {
                  'notification_count': 23,
                },
              },
              'data' : {
                'type' : 'msj' ,
                'id' : 'TiGAS'
              }
            };

            await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            body: jsonEncode(data) ,
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization' : 'key=AAAAzH3-XCg:APA91bGi2Tzb9q8B_X1sxp-_WUKmhPoiIxs5o7KNym8y9H8W67tf5r98Nl3FIcPJLbVl_OE0dFPXFHu-QiL_K6GHaI8-6IZGHDukylwV283KKIXpdFyhJVbsvVwFv94uYSsHMU_hXWOr'
              }
            ).then((value){
              if (kDebugMode) {
                print(value.body.toString());
              }
            }).onError((error, stackTrace){
              if (kDebugMode) {
                print(error);
              }
            });
          }});
        showSnackBar(context, 'Image uploaded');
      } else {
        showSnackBar(context, 'Image upload failed');
      }
    }
  }

  Future<List<String>> getAllFCMTokens() async {
    return ['dSw_3VCCTGmgveL7G3NBEU:APA91bF_Vf7bLn-XaLzPF4bh_HfTzE627IioyHXPAt7VFima9v1fl33eYPAdBJS3Mqa7oSMIgjONdJbUlVom48eqSnJK_fDToSiWq9DFGcQJlBtY2lT9irfsmGZnmJoqo9mdBZjOyM6A', 'e8ecAouqRqyvmjQbubMJ4c:APA91bGZFI4JTAe1gmjyJyL2jNEBxyfADm-j_q7unVVK-fZE0tULmuAlpkmerqO7V5GHDbfZ0Peb5U04TAFAaQDhRm49qQlghDhm9HUU8yOy9T1lXK_mupRR5eBdhopbq6JYRxjBEEsi'];
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
