// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:tigas_application/providers/url_manager.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class CommercialPage extends StatefulWidget {
//   final int selectedTab;
//   final ScrollController scrollController;
//   CommercialPage({
//     Key? key,
//     required this.selectedTab,
//     required this.scrollController,
//   }) : super(key: key);

//   @override
//   _CommercialPageState createState() => _CommercialPageState();
// }

// class _CommercialPageState extends State<CommercialPage> {
//   List<Map<String, dynamic>> advertisements = [];
//   final urlManager = UrlManager();

//   @override
//   void initState() {
//     super.initState();
//     tz.initializeTimeZones();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return const Dialog(
//             backgroundColor: Colors.white,
//             child: SizedBox(
//               height: 100,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   Text(
//                     "Loading Posts",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );

//       fetchAdvertisements().then((_) {
//         Navigator.pop(
//             context); // close the dialog after fetchAdvertisements completes
//       }).catchError((error) {
//         // Handle any errors here
//         Navigator.pop(context); // close the dialog
//       });
//     });
//   }

//   Future<void> fetchAdvertisements() async {
//     String url = await urlManager.getValidBaseUrl();
//     final response = await http.get(Uri.parse('$url/images/'));

//     if (response.statusCode == 200) {
//       List<dynamic> ads = json.decode(response.body);

//       setState(() {
//         advertisements = ads
//             .where((ad) {
//               // Filter out expired advertisements
//               if (ad['valid_until'] != null) {
//                 DateTime validUntil = DateTime.parse(ad['valid_until']);
//                 if (validUntil.isBefore(DateTime.now())) {
//                   // Advertisement is expired, delete it
//                   deleteAdvertisement(ad['id']);
//                   return false; // Exclude from the list
//                 }
//               }
//               return true; // Include non-expired advertisements
//             })
//             .map<Map<String, dynamic>>((ad) => {
//                   'id': ad['id'],
//                   'image': '$url${ad['image']}',
//                   'caption': ad['caption'],
//                   'updated': convertTime(ad['updated']),
//                   'valid_until': ad['valid_until'] != null
//                       ? convertTime(ad['valid_until'])
//                       : 'Not specified',
//                   'posted_by': ad['posted_by'] ?? 'Unknown',
//                 })
//             .toList();
//       });
//     } else {
//       throw Exception('Failed to load advertisements');
//     }
//   }

//   Future<void> deleteAdvertisement(int? id) async {
//     if (id != null) {
//       String url = await urlManager.getValidBaseUrl();
//       Uri uri = Uri.parse("$url/images/$id/delete");

//       var response = await http.delete(uri);

//       if (response.statusCode == 200) {
//         print("Advertisement $id deleted successfully");
//         fetchAdvertisements();
//       } else {
//         print("Failed to delete advertisement $id");
//       }
//     }
//   }

//   String convertTime(String time) {
//     DateTime updatedUtc = DateTime.parse(time);
//     tz.TZDateTime updated =
//         tz.TZDateTime.from(updatedUtc, tz.getLocation('Asia/Manila'));

//     return DateFormat('yyyy-MM-dd - hh:mm a').format(updated);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       body: NestedScrollView(
//         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//           return <Widget>[
//             SliverAppBar(
//               automaticallyImplyLeading: false,
//               elevation: 0,
//               expandedHeight: 270,
//               floating: false,
//               pinned: true,
//               stretch: true,
//               flexibleSpace: FlexibleSpaceBar(
//                 centerTitle: true,
//                 collapseMode: CollapseMode.pin,
//                 title: Text('PARTNERS',
//                     style: GoogleFonts.signika(fontWeight: FontWeight.bold)),
//                 background: Image.asset(
//                   'assets/logo.png',
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               backgroundColor: Color(0xFF609966),
//             )
//           ];
//         },
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.center,
//               colors: [
//                 Color(0xFF609966),
//                 Color(0xFF175124),
//               ],
//             ),
//           ),
//           child: advertisements.isEmpty
//               ? Center(
//                   child: Text(
//                     'No ads to display for now',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 )
//               : Column(
//                   children: [
//                     Expanded(
//                       child: RefreshIndicator(
//                         onRefresh: fetchAdvertisements,
//                         child: ListView.builder(
//                           itemCount: advertisements.length,
//                           itemBuilder: (context, index) {
//                             Map<String, dynamic> ad = advertisements[index];
//                             String imagePath = ad['image'];
//                             String adText = ad['caption'];
//                             String updatedTime = ad['updated'];
//                             String validUntil = ad['valid_until'];
//                             String postedBy = ad['posted_by'];
//                             int? adId = ad['id'];

//                             return Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 15.0, vertical: 15.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                                 children: [
//                                   Container(
//                                     height: screenSize.height / 3,
//                                     width: screenSize.width,
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(16),
//                                         topRight: Radius.circular(16),
//                                       ),
//                                       child: Material(
//                                         elevation: 5,
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             // Display image in dialog
//                                             showDialog(
//                                               context: context,
//                                               builder: (BuildContext context) {
//                                                 return Dialog(
//                                                   child: Container(
//                                                     child: Image.network(
//                                                       imagePath,
//                                                       fit: BoxFit.contain,
//                                                       errorBuilder:
//                                                           (BuildContext context,
//                                                               Object exception,
//                                                               StackTrace?
//                                                                   stackTrace) {
//                                                         return const Text(
//                                                             'Could not load image');
//                                                       },
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                             );
//                                           },
//                                           child: Image.network(
//                                             imagePath,
//                                             fit: BoxFit.cover,
//                                             errorBuilder: (BuildContext context,
//                                                 Object exception,
//                                                 StackTrace? stackTrace) {
//                                               return const Text(
//                                                   'Could not load image');
//                                             },
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 10),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.white60,
//                                       borderRadius: BorderRadius.only(
//                                         bottomLeft: Radius.circular(16),
//                                         bottomRight: Radius.circular(16),
//                                       ),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             adText,
//                                             style: GoogleFonts.catamaran(
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white,
//                                               fontSize: 16,
//                                             ),
//                                           ),
//                                           SizedBox(height: 10),
//                                           Text(
//                                             'Last Updated: $updatedTime',
//                                             style: GoogleFonts.catamaran(
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.grey[200],
//                                               fontStyle: FontStyle.italic,
//                                               fontSize: 14,
//                                             ),
//                                           ),
//                                           Text(
//                                             'Valid Until: $validUntil',
//                                             style: GoogleFonts.catamaran(
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.grey[200],
//                                               fontStyle: FontStyle.italic,
//                                               fontSize: 14,
//                                             ),
//                                           ),
//                                           Text(
//                                             'Posted By: $postedBy',
//                                             style: GoogleFonts.catamaran(
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.grey[200],
//                                               fontStyle: FontStyle.italic,
//                                               fontSize: 14,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:tigas_application/providers/url_manager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class CommercialPage extends StatefulWidget {
  final int selectedTab;
  final ScrollController scrollController;
  CommercialPage({
    Key? key,
    required this.selectedTab,
    required this.scrollController,
  }) : super(key: key);

  @override
  _CommercialPageState createState() => _CommercialPageState();
}

class _CommercialPageState extends State<CommercialPage> {
  List<Map<String, dynamic>> advertisements = [];
  final urlManager = UrlManager();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: SizedBox(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text(
                    "Loading Posts",
                    style: GoogleFonts.signika(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      fetchAdvertisements().then((_) {
        Navigator.pop(context); // close the dialog after fetchAdvertisements completes
      }).catchError((error) {
        // Handle any errors here
        Navigator.pop(context); // close the dialog
      });
    });
  }

  Future<void> fetchAdvertisements() async {
    String url = await urlManager.getValidBaseUrl();
    final response = await http.get(Uri.parse('$url/images/')); //used for external device

    if (response.statusCode == 200) {
      List<dynamic> ads = json.decode(response.body);
      setState(() {
        advertisements = ads
            .map<Map<String, dynamic>>((ad) => {
                  'image': '$url${ad['image']}', //used for external device
                  'caption': ad['caption'],
                  'updated': convertTime(ad['updated']),
                  'valid_until': ad['valid_until'] != null
                      ? convertTime(ad['valid_until'])
                      : 'Not specified',
                  'posted_by': ad['posted_by'] ?? 'Unknown',
                })
            .toList();
      });
    } else {
      throw Exception('Failed to load advertisements');
    }
  }

  String convertTime(String time) {
    DateTime updatedUtc = DateTime.parse(time); // Parse the updated time in UTC
    tz.TZDateTime updated = tz.TZDateTime.from(
        updatedUtc, tz.getLocation('Asia/Manila')); // Convert to Manila time

    return DateFormat('yyyy-MM-dd - hh:mm a').format(updated); // format updated time
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              expandedHeight: 270,
              floating: false,
              pinned: true,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                collapseMode: CollapseMode.pin,
                title: Text(
                  'PARTNERS',
                  style: GoogleFonts.signika(fontWeight: FontWeight.bold),
                ),
                background: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              backgroundColor: Color(0xFF609966),
            )
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Color(0xFF609966),
                Color(0xFF175124),
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: fetchAdvertisements,
                  child: ListView.builder(
                    itemCount: advertisements.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> ad = advertisements[index];
                      String imagePath = ad['image'];
                      String adText = ad['caption'];
                      String updatedTime = ad['updated'];
                      String validUntil = ad['valid_until'];
                      String postedBy = ad['posted_by'];
                      return Container(
                        padding: const EdgeInsets.all(15.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: Container(
                                          child: Image.network(
                                            imagePath,
                                            fit: BoxFit.contain,
                                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                              return Center(
                                                child: Text(
                                                  'Could not load image',
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    imagePath,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: screenSize.height / 3,
                                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                      return Center(
                                        child: Text(
                                          'Could not load image',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      adText,
                                      style: GoogleFonts.catamaran(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Last Updated: $updatedTime',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(
                                      'Valid Until: $validUntil',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(
                                      'Posted By: $postedBy',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
