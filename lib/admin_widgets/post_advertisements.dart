// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tigas_application/widgets/show_snackbar.dart';

class Advertisement {
  final String text;
  final XFile image;
  final DateTime updated;

  Advertisement({
    required this.text,
    required this.image,
    required this.updated,
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: Colors.blue,
              width: 3.0,
            ),
          ),
          child: Column(
            children: [
              Text('Post an Advertisement'),
              TextFormField(
                controller: _adController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Advertisement Text',
                ),
              ),
              SizedBox(
                height: 10,
              ),
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text('Pick Image'),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (pickedImage != null && _adController.text.isNotEmpty) {
                    Uri uri =
                        // Uri.parse("http://127.0.0.1:8000/upload_image/");
                        Uri.parse(
                            "http://192.168.1.10:8000/upload_image/"); //used for external device
                    var request = http.MultipartRequest('POST', uri);
                    request.files.add(
                      await http.MultipartFile.fromPath(
                          'image', pickedImage!.path),
                    );

                    request.fields['caption'] = _adController.text;

                    var response = await request.send();

                    if (response.statusCode == 201) {
                      // Check the status code for a success response
                      print("Uploaded successfully");

                      // Assuming the response contains a field 'updated' with the timestamp
                      var responseData = await response.stream.bytesToString();
                      var decodedData = jsonDecode(responseData);
                      DateTime updated = DateTime.parse(decodedData['updated']);

                      setState(() {
                        postedAds.add(Advertisement(
                            text: _adController.text,
                            image: pickedImage!,
                            updated: updated));
                        _adController.clear();
                      });
                      showSnackBar(context, 'Image uploaded');
                    } else {
                      print("Upload failed");
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text('Upload Image'),
              ),
              SizedBox(
                height: 10,
              ),
              // Display the picked image
              pickedImage == null
                  ? Text('No image selected.')
                  : Image.file(File(pickedImage!.path)),
            ],
          ),
        ),
      ),
    );
  }
}
