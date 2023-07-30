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
                onPressed: () {},
                child: Text('Done'),
                textColor: Colors.white,
              ),
            ),
          ),
          //quit button
          Positioned(
            right: 0,
            child: IconButton(
              icon: Icon(Icons.close), // This represents the (x) icon
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),

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
                            _starPosition = 20.0;
                            _rating = index + 1;
                          });
                        },
                      )),
            ),
            duration: Duration(milliseconds: 300),
          )
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
    return Container();
  }
}
