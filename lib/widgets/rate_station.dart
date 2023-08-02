// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:tigas_application/providers/station_provider.dart';
import 'package:tigas_application/providers/url_manager.dart';
import 'package:tigas_application/widgets/bottom_navbar.dart';
import 'package:tigas_application/widgets/show_snackbar.dart';

import '../models/station_model.dart';

class RateDialog extends StatefulWidget {
  final int stationId;
  const RateDialog({
    Key? key,
    required this.stationId,
  }) : super(key: key);

  @override
  State<RateDialog> createState() => _RateDialogState();
}

class _RateDialogState extends State<RateDialog> {
  late double deviceHeight;
  late double deviceWidth;
  var ratingScreenController = PageController();
  var _starPosition = 220.0;
  var rating = 0;
  List<int> _selectedChipIndexes = [];
  var _isMoreDetailActive = false;
  var _moreDetailFocusNode = FocusNode();
  final urlManager = UrlManager();
  final commentsController = TextEditingController();

  List<String> chipTexts = [
    'Outdated prices',
    'Unavailable Oil',
    'Unavailable Air',
    'Unavailable Water',
    'No Restroom',
    'Bad service',
  ];

  Future<void> postReview(String? comments, rating, List<String> review) async {
    String baseurl = await urlManager.getValidBaseUrl();
    String url = '$baseurl/reviews/create/';
    String? postedBy = FirebaseAuth.instance.currentUser?.displayName;
    int stationId = widget.stationId;

    Map<String, dynamic> reviewData = {
      'station': stationId,
      'posted_by': postedBy,
      'rating': rating,
      'review': review,
    };

    if (comments != null && comments.isNotEmpty) {
      reviewData['comments'] = comments;
    }

    http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reviewData),
    );

    if (response.statusCode == 201) {
      print('Review posted successfully');
    } else {
      print('Failed to post review. Error: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    super.dispose();
    commentsController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(deviceHeight * 0.02)),
      // clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Container(
            height: max(deviceHeight * 0.4, 200),
            child: PageView(
              controller: ratingScreenController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                buildThanksNote(),
                ratingDescription(),
              ],
            ),
          ),
          //done button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.green,
              height: deviceHeight * 0.05,
              child: MaterialButton(
                onPressed: () {
                  List<String> selectedChips = _selectedChipIndexes
                      .map((index) => chipTexts[index])
                      .toList();
                  postReview(commentsController.text, rating, selectedChips);
                  showSnackBar(context, 'Review posted');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NavBar(
                        selectedTab: 0,
                      ),
                    ),
                  );
                },
                textColor: Colors.white,
                child: Text('Done',
                    style: TextStyle(fontSize: deviceHeight * 0.02)),
              ),
            ),
          ),
          //quit button
          Positioned(
            right: 0,
            child: IconButton(
              icon:
                  Icon(Icons.close, size: deviceHeight * 0.03), // Exit (x) icon
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          //Star
          AnimatedPositioned(
            top: _starPosition,
            left: 0,
            right: 0,
            // ignore: sort_child_properties_last
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: index < rating
                      ? Icon(Icons.star,
                          color: Colors.yellowAccent, size: deviceHeight * 0.04)
                      : Icon(Icons.star_border, size: deviceHeight * 0.04),
                  onPressed: () {
                    ratingScreenController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                    setState(() {
                      _starPosition = 20.0;
                      rating = index + 1;
                    });
                  },
                ),
              ),
            ),
            duration: Duration(milliseconds: 300),
          ),
          //back button
          if (_isMoreDetailActive)
            Positioned(
                left: 0,
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      _isMoreDetailActive = false;
                    });
                  },
                  child: Icon(Icons.arrow_back_ios),
                )),
        ],
      ),
    );
  }

  buildThanksNote() {
    String stationName = '';

    try {
      StationProvider stationProvider =
          Provider.of<StationProvider>(context, listen: false);
      Station? station =
          stationProvider.stations.firstWhere((s) => s.id == widget.stationId);

      stationName = station.name;
    } catch (e) {
      print("failed to get station name: $e");
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Thank you for using',
          style: TextStyle(
            fontSize: deviceHeight * 0.03,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        Image.asset('assets/greenlogo.png',
            height: deviceHeight * 0.06, width: deviceWidth * 0.3),
        Text('How was $stationName\u0027s services?',
            style: TextStyle(fontSize: deviceHeight * 0.02)),
      ],
    );
  }

  ratingDescription() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Visibility(
          visible: !_isMoreDetailActive,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: deviceHeight * 0.05),
              Text('What could be better?'),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              Wrap(
                spacing: deviceWidth * 0.01,
                runSpacing: deviceWidth * 0.01,
                alignment: WrapAlignment.center,
                children: List.generate(
                  6,
                  (index) => InkWell(
                    onTap: () {
                      setState(() {
                        if (_selectedChipIndexes.contains(index)) {
                          _selectedChipIndexes.remove(index);
                        } else {
                          _selectedChipIndexes.add(index);
                        }
                      });
                    },
                    child: Chip(
                      backgroundColor: _selectedChipIndexes.contains(index)
                          ? Colors.green
                          : Colors.grey,
                      label: Text(
                        chipTexts[index],
                        style: TextStyle(
                          color: _selectedChipIndexes.contains(index)
                              ? Colors.white
                              : Colors.black,
                          fontSize: deviceHeight * 0.02,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: deviceHeight * 0.01),
              InkWell(
                onTap: () {
                  _moreDetailFocusNode.requestFocus();
                  setState(() {
                    _isMoreDetailActive = true;
                  });
                },
                child: Text(
                  'Tell us more.',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: deviceHeight * 0.02),
                ),
              ),
              SizedBox(height: deviceHeight * 0.04)
            ],
          ),
          replacement: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('What is the reason of your review?'),
              SizedBox(height: deviceHeight * 0.01),
              Chip(
                  backgroundColor: Colors.green,
                  label: Text(
                    _selectedChipIndexes
                        .map((index) => chipTexts[index])
                        .join(', '),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white, fontSize: deviceHeight * 0.01),
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.01),
                child: TextField(
                  controller: commentsController,
                  focusNode: _moreDetailFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Write your review here...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
