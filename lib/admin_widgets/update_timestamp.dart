import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tigas_application/models/reviews_model.dart';
import 'package:tigas_application/models/station_model.dart';
import 'package:tigas_application/providers/url_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class UpdateTimestamp extends StatefulWidget {
  const UpdateTimestamp({Key? key}) : super(key: key);

  @override
  State<UpdateTimestamp> createState() => _UpdateTimestampState();
}

class _UpdateTimestampState extends State<UpdateTimestamp> {
  late Future<List<Station>> _stationsFuture;
  final UrlManager urlManager = UrlManager();

  @override
  void initState() {
    super.initState();
    _stationsFuture = fetchStations();
    tz.initializeTimeZones();
  }

  Future<List<Station>> fetchStations() async {
    String url = await urlManager.getValidBaseUrl();
    final response = await http.get(Uri.parse('$url/stations/'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((item) => Station.fromMap(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load stations');
    }
  }

  Future<List<Review>> fetchReviews(int stationId) async {
    String url = await urlManager.getValidBaseUrl();
    final response =
        await http.get(Uri.parse('$url/stations/$stationId/reviews'));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse
          .map((item) => Review.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  Future<String?> getUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.isAnonymous) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userSnapshot.get('role');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String?>(
        future: getUserRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Error fetching user role'));
          } else {
            String userRole = snapshot.data!;
            return FutureBuilder<List<Station>>(
              future: _stationsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Station> allStations = snapshot.data!;
                  List<Station> filteredStations = allStations
                      .where((station) => station.name.contains(userRole))
                      .toList();

                  return ListView.builder(
                    itemCount: filteredStations.length,
                    itemBuilder: (context, index) {
                      filteredStations
                          .sort((a, b) => b.updated.compareTo(a.updated));
                      Station station = filteredStations[index];
                      DateTime updated = tz.TZDateTime.from(
                        station.updated,
                        tz.getLocation('Asia/Manila'),
                      );

                      return Card(
                        color: Colors.grey[300],
                        margin: const EdgeInsets.all(8.0),
                        elevation: 4.0,
                        child: ListTile(
                          title: Text(
                            station.name,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8.0),
                              Text(
                                'Address: ${station.address}',
                                style: const TextStyle(fontSize: 14.0),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'Last Updated: ${DateFormat('yyyy-MM-dd HH:mm').format(updated)}',
                                style: const TextStyle(fontSize: 12.0),
                              ),
                              const SizedBox(height: 8.0),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem(
                                value: 'reviews',
                                child: Text('View Reviews'),
                              ),
                            ],
                            onSelected: (value) async {
                              if (value == 'reviews') {
                                List<Review> reviews =
                                    await fetchReviews(station.id);
                                _showReviewDialog(reviews);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showReviewDialog(List<Review> reviews) {
    reviews.sort((a, b) =>
        DateTime.parse(b.created).compareTo(DateTime.parse(a.created)));
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reviews'),
          content: reviews.isEmpty
              ? const SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      'No reviews',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : Container(
                  width: double.maxFinite,
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      Review review = reviews[index];
                      DateTime created = tz.TZDateTime.from(
                        DateTime.parse(review.created),
                        tz.getLocation('Asia/Manila'),
                      );

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    review.reviewerName,
                                    style: GoogleFonts.ubuntu(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('yyyy-MM-dd HH:mm')
                                        .format(created),
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                children: List.generate(
                                  5,
                                  (i) => Icon(
                                    i < review.rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.orange,
                                    size: 18.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                review.review.join(', '),
                                style: GoogleFonts.catamaran(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                review?.content ?? '',
                                style: GoogleFonts.catamaran(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
