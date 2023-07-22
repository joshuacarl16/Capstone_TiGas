import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Advertisement {
  final String text;
  final XFile image;

  Advertisement({required this.text, required this.image});
}

class PostAdvertisement extends StatefulWidget {
  @override
  _PostAdvertisementState createState() => _PostAdvertisementState();
}

class _PostAdvertisementState extends State<PostAdvertisement> {
  final TextEditingController _adController = TextEditingController();
  List<Advertisement> postedAds = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Advertisement Section
          Container(
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

                    if (image != null && _adController.text.isNotEmpty) {
                      setState(() {
                        postedAds.add(Advertisement(
                            text: _adController.text, image: image));
                        _adController.clear(); // Clear the text after posting
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text('Pick Image and Upload'),
                ),
              ],
            ),
          ),

          // Display posted images
          Expanded(
            child: ListView.builder(
              itemCount: postedAds.length,
              itemBuilder: (context, index) {
                Advertisement ad = postedAds[index];
                return Card(
                  child: Column(
                    children: [
                      Text(ad.text),
                      SizedBox(
                        height: 10,
                      ),
                      Image.file(
                        File(ad.image.path),
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          // If image can't load, show a placeholder
                          return Icon(Icons.error);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
