// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';

class RateDialog extends StatefulWidget {
  const RateDialog({super.key});

  @override
  State<RateDialog> createState() => _RateDialogState();
}

class _RateDialogState extends State<RateDialog> {
  var _ratingScreenController = PageController();
  var _starPosition = 170.0;
  var _rating = 0;
  var _selectedChipIndex =
      -1; //this one should not be negative but if e zero kay mo auto select siya sa Custom text 1 carl
  var _isMoreDetailActive = false;
  var _moreDetailFocusNode = FocusNode();

  List<String> chipTexts = [
    'Custom Text 1',
    'Outdated prices',
    'Unavailable Air',
    'Unavailable Water',
    'No CR',
    'Bad service',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Container(
            height: max(200, MediaQuery.of(context).size.height * 0.3),
            child: PageView(
              controller: _ratingScreenController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildThanksNote(),
                _ratingDescription(),
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
              height: 40,
              child: MaterialButton(
                onPressed: () {}, //fetch the inputted data here carl
                child: Text('Done'),
                textColor: Colors.white,
              ),
            ),
          ),
          //quit button
          Positioned(
            right: 0,
            child: IconButton(
              icon: Icon(Icons.close), // Exit (x) icon
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
                        icon: index < _rating
                            ? Icon(
                                Icons.star,
                                color: Colors.yellowAccent,
                                size: 32,
                              )
                            : Icon(
                                Icons.star_border,
                                size: 32,
                              ),
                        onPressed: () {
                          _ratingScreenController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                          setState(() {
                            _starPosition = 10.0;
                            _rating = index + 1;
                          });
                        },
                      )),
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

  _buildThanksNote() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Thank you for using',
          style: TextStyle(
            fontSize: 24,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'TiGAS',
          style: TextStyle(
            fontSize: 24,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text('How was (Station Name)\u0027s services?'),
      ],
    );
  }

  _ratingDescription() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Visibility(
          visible: !_isMoreDetailActive,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('What could be better?'),
              SizedBox(
                height: 8.0,
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: List.generate(
                  6,
                  (index) => InkWell(
                    onTap: () {
                      setState(() {
                        _selectedChipIndex = index;
                      });
                    },
                    child: Chip(
                      backgroundColor: _selectedChipIndex == index
                          ? Colors.green
                          : Colors.grey,
                      label: Text(
                        chipTexts[index],
                        style: TextStyle(
                          color: _selectedChipIndex == index
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              InkWell(
                onTap: () {
                  _moreDetailFocusNode.requestFocus();
                  setState(() {
                    _isMoreDetailActive = true;
                  });
                },
                child: Text(
                  'Tell us more.',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          replacement: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('What is the reason of your review?'),
              SizedBox(
                height: 8.0,
              ),
              Chip(
                  backgroundColor: Colors.green,
                  label: Text(
                    chipTexts[
                        _selectedChipIndex + 1], //I need help with this carl
                    style: TextStyle(color: Colors.white),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
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
