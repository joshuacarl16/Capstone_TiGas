// ignoreforfile: publicmemberapidocs, sortconstructorsfirst
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:tigas_application/models/station_model.dart';
import 'package:tigas_application/screens/result_screen.dart';
import 'package:tigas_application/styles/styles.dart';

class CameraScreen extends StatefulWidget {
  final Station selectedStation;
  const CameraScreen({
    Key? key,
    required this.selectedStation,
  }) : super(key: key);

  @override
  State<CameraScreen> createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  final int selectedTab = 1;
  bool isPermissionGranted = false;

  late final Future<void> future;

  CameraController? cameraController;

  final textRecognizer = TextRecognizer();

  Map<String, List<String>> brandGasTypes = {
    'Shell': [
      'FuelSave Diesel',
      'V-Power Diesel',
      'V-Power Gasoline',
      'FuelSave Unleaded',
    ],
    'Caltex': ['Diesel', 'Silver', 'Platinum'],
    'Petron': [
      'Blaze 100 Euro 6',
      'XCS',
      'Xtra Advance',
      'Turbo Diesel',
      'Diesel Max'
    ],
    'Phoenix': ['Diesel', 'Super', 'Premium 95', 'Premium 98'],
    'Jetti': ['DieselMaster', 'Accelrate', 'JX Premium'],
    'Total': ['Excellium Unleaded', 'Excellium Diesel'],
    'Seaoil': ['Extreme 97', 'Extreme 95', 'Extreme U', 'Extreme Diesel'],
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    future = requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        cameraController != null &&
        cameraController!.value.isInitialized) {
      startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: getGradientDecoration(),
        child: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            return Stack(
              children: [
                if (isPermissionGranted)
                  FutureBuilder<List<CameraDescription>>(
                    future: availableCameras(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        initCameraController(snapshot.data!);

                        return Center(
                          child: CameraPreview(cameraController!),
                        );
                      } else {
                        return const LinearProgressIndicator();
                      }
                    },
                  ),
                Scaffold(
                  backgroundColor:
                      isPermissionGranted ? Colors.transparent : null,
                  body: isPermissionGranted
                      ? Column(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 30.0),
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: scanImage,
                                  child: Text("Scan Image"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[400],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Container(
                            padding:
                                const EdgeInsets.only(left: 24.0, right: 24.0),
                            child: const Text(
                              'Camera permission denied',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                ),
                Positioned(
                  top: 70,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.selectedStation.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 60,
                    left: 10,
                    child: IconButton(
                      onPressed: Navigator.of(context).pop,
                      icon: FaIcon(FontAwesomeIcons.arrowLeft,
                          color: Colors.white),
                    )),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    isPermissionGranted = status == PermissionStatus.granted;
  }

  void startCamera() {
    if (cameraController != null) {
      cameraSelected(cameraController!.description);
    }
  }

  void stopCamera() {
    if (cameraController != null) {
      cameraController?.dispose();
    }
  }

  void initCameraController(List<CameraDescription> cameras) {
    if (cameraController != null) {
      return;
    }

    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      cameraSelected(camera);
    }
  }

  Future<void> cameraSelected(CameraDescription camera) async {
    cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await cameraController?.initialize();

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> scanImage() async {
    if (cameraController == null) return;

    final navigator = Navigator.of(context);
    String stationName = widget.selectedStation.name;
    List<String> processLogs = [];

    String brand = brandGasTypes.keys.firstWhere(
      (brand) => stationName.contains(brand),
      orElse: () => '',
    );

    if (brand.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No gas types found for this station: $stationName'),
        ),
      );
      return;
    }

    List<String> gasTypes = brandGasTypes[brand]!;

    try {
      final pictureFile = await cameraController!.takePicture();

      final croppedFile = await ImageCropper().cropImage(
          sourcePath: pictureFile.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Confirm Submission',
                toolbarColor: Color(0xFF609966),
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Confirm Submission',
            ),
          ]);

      if (croppedFile == null) {
        return;
      }

      final file = File(croppedFile.path);

      final inputImage = InputImage.fromFile(file);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      List<TextBlock> blocks = recognizedText.blocks
        ..sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));

      Map<String, String> gasTypePrices = {};

      for (var block in blocks) {
        double bestMatchRating = 0.0;
        String bestMatchType = '';
        String blockTextLower = block.text.toLowerCase();

        bool gasTypeFound = false;

        // Direct matching with gas types.
        for (var type in gasTypes) {
          if (blockTextLower.contains(type.toLowerCase())) {
            bestMatchType = type;
            gasTypeFound = true;
            break;
          }
        }

        if (!gasTypeFound) {
          continue;
        }

        // If no match is found, use string similarity.
        if (bestMatchType.isEmpty) {
          for (var type in gasTypes) {
            double similarity =
                StringSimilarity.compareTwoStrings(type, block.text);

            if (similarity > bestMatchRating) {
              bestMatchRating = similarity;
              bestMatchType = type;
            }
          }

          // Continue with next block if similarity is too low.
          if (bestMatchRating < 0.2) {
            processLogs
                .add('Block "${block.text}" does not match any gas type');
            continue;
          }
        }

        List<RegExp> expressions = [
          RegExp('$bestMatchType\\s(\\d+(\\.\\d+)?)'), // original expression
          RegExp(
              '$bestMatchType\\s.*?(\\d+(\\.\\d+)?)'), // expression handling allowing characters in between
          RegExp(
              '$bestMatchType\\s(\\d{1,3}(\\d{2}))'), // expression handling for missed decimal point
          RegExp(
              '$bestMatchType\\s(\\d+(,\\d+)?)'), // expression handling decimal point recognized as comma
          RegExp(
              '$bestMatchType\\s*\\n\\s*(\\d+(\\.\\d+)?)'), // expression handling price below the name
          RegExp(
              '$bestMatchType\\s+(\\d+(\\.\\d+)?)'), //expression handling price beside gas type but lower
          RegExp(
              '$bestMatchType\\s+(\\d{2,5}(\\.\\d+)?)'), //expression handling price contains more digit
          RegExp(
              '$bestMatchType\\s+\\s*(\\d+(\\.\\d+)?)'), //expression handling for space between type and price
          RegExp(
              '$bestMatchType[\\s\\n]*(\\d+(\\.\\d+)?)') //expression handling multiple spaces
        ];

        // String textToSearch = block.text;
        // if (blocks.indexOf(block) < blocks.length - 1) {
        //   textToSearch += ' ' + blocks[blocks.indexOf(block) + 1].text;
        // }

        for (var exp in expressions) {
          var matches = exp.allMatches(block.text);
          if (matches.isNotEmpty) {
            String price = matches.first.group(1)!;

            // Replace comma with a decimal point
            if (price.contains(',')) {
              price = price.replaceAll(',', '.');
            }

            // If the matched string has 4 or 5 characters and the expression is for missed decimal point
            // Insert a decimal point before the last two digits
            if (price.length > 3 && exp.pattern == '\\b(\\d{1,3}(\\d{2}))\\b') {
              price = price.substring(0, price.length - 2) +
                  '.' +
                  price.substring(price.length - 2);
            }

            gasTypePrices[bestMatchType] = price;
            processLogs.add(
                'Match found. Type: $bestMatchType, Price: ${gasTypePrices[bestMatchType]}');
            break; // exit the loop if a match is found
          }
        }
      }

      await navigator.push(
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            selectedStation: widget.selectedStation,
            scannedGasPrices: gasTypePrices,
            processLogs: processLogs,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occured while scanning text: $e'),
        ),
      );
    }
  }

  // Future<void> scanImage() async {
  //   if (cameraController == null) return;

  //   final navigator = Navigator.of(context);
  //   String stationName = widget.selectedStation.name;
  //   List<String> processLogs = [];

  //   String brand = brandGasTypes.keys.firstWhere(
  //     (brand) => stationName.contains(brand),
  //     orElse: () => '',
  //   );

  //   if (brand.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('No gas types found for this station: $stationName'),
  //       ),
  //     );
  //     return;
  //   }

  //   List<String> gasTypes = brandGasTypes[brand]!;

  //   try {
  //     final pictureFile = await cameraController!.takePicture();

  //     final croppedFile = await ImageCropper().cropImage(
  //         sourcePath: pictureFile.path,
  //         compressFormat: ImageCompressFormat.jpg,
  //         compressQuality: 100,
  //         uiSettings: [
  //           AndroidUiSettings(
  //               toolbarTitle: 'Confirm Submission',
  //               toolbarColor: Color(0xFF609966),
  //               toolbarWidgetColor: Colors.white,
  //               initAspectRatio: CropAspectRatioPreset.original,
  //               lockAspectRatio: false),
  //           IOSUiSettings(
  //             title: 'Confirm Submission',
  //           ),
  //         ]);

  //     if (croppedFile == null) {
  //       return;
  //     }

  //     final file = File(croppedFile.path);

  //     final inputImage = InputImage.fromFile(file);
  //     final RecognizedText recognizedText =
  //         await textRecognizer.processImage(inputImage);

  //     List<TextBlock> blocks = recognizedText.blocks
  //       ..sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));

  //     Map<String, String> gasTypePrices = {};

  //     for (var block in blocks) {
  //       double bestMatchRating = 0.0;
  //       String bestMatchType = '';

  //       for (var type in gasTypes) {
  //         // check if block text contains part of the gas type
  //         if (type.split(' ').any((word) => block.text.contains(word))) {
  //           bestMatchType = type;
  //           break;
  //         }
  //       }

  //       processLogs.add('Best match type: $bestMatchType');

  //       for (var type in gasTypes) {
  //         // calculate similarity between type and block text
  //         double similarity =
  //             StringSimilarity.compareTwoStrings(type, block.text);
  //         processLogs.add(
  //             'Comparing type: $type with block text: ${block.text}. Similarity: $similarity');

  //         // check if similarity is the best so far
  //         if (similarity > bestMatchRating) {
  //           bestMatchRating = similarity;
  //           bestMatchType = type;
  //         }
  //       }

  //       processLogs.add(
  //           'Best match type: $bestMatchType with similarity: $bestMatchRating');

  //       // check if a good match was found
  //       if (bestMatchType.isNotEmpty && bestMatchRating > 0.2 ||
  //           bestMatchRating == 1.0) {
  //         // Define list of expressions to check
  //         List<RegExp> expressions = [
  //           RegExp('$bestMatchType\\s(\\d+(\\.\\d+)?)'), // original expression
  //           RegExp(
  //               '$bestMatchType\\s.*?(\\d+(\\.\\d+)?)'), // expression handling allowing characters in between
  //           RegExp(
  //               '$bestMatchType\\s(\\d{1,3}(\\d{2}))'), // expression handling for missed decimal point
  //           RegExp(
  //               '$bestMatchType\\s(\\d+(,\\d+)?)'), // expression handling decimal point recognized as comma
  //           RegExp(
  //               '$bestMatchType\\s*\\n\\s*(\\d+(\\.\\d+)?)'), // expression handling price below the name
  //           RegExp(
  //               '$bestMatchType\\s+(\\d+(\\.\\d+)?)'), //expression handling price beside gas type but lower
  //           RegExp(
  //               '$bestMatchType\\s+(\\d{2,5}(\\.\\d+)?)'), //expression handling price contains more digit
  //           RegExp(
  //               '$bestMatchType\\s+\\s*(\\d+(\\.\\d+)?)'), //expression handling for space between type and price
  //           RegExp(
  //               '$bestMatchType[\\s\\n]*(\\d+(\\.\\d+)?)') //expression handling multiple spaces
  //         ];

  //         String textToSearch = block.text;
  //         if (blocks.indexOf(block) < blocks.length - 1) {
  //           textToSearch += ' ' + blocks[blocks.indexOf(block) + 1].text;
  //         }

  // for (var exp in expressions) {
  //   var matches = exp.allMatches(block.text);
  //   if (matches.isNotEmpty) {
  //     String price = matches.first.group(1)!;

  //     // Replace comma with a decimal point
  //     if (price.contains(',')) {
  //       price = price.replaceAll(',', '.');
  //     }

  //     // If the matched string has 4 or 5 characters and the expression is for missed decimal point
  //     // Insert a decimal point before the last two digits
  //     if (price.length > 3 &&
  //         exp.pattern == '\\b(\\d{1,3}(\\d{2}))\\b') {
  //       price = price.substring(0, price.length - 2) +
  //           '.' +
  //           price.substring(price.length - 2);
  //     }

  //     gasTypePrices[bestMatchType] = price;
  //     processLogs.add(
  //         'Match found. Type: $bestMatchType, Price: ${gasTypePrices[bestMatchType]}');
  //     break; // exit the loop if a match is found
  //   }
  // }

  //         if (!gasTypePrices.containsKey(bestMatchType)) {
  //           processLogs.add(
  //               'No match found or similarity below threshold for block: ${block.text}');
  //         }
  //       }
  //     }

  //     await navigator.push(
  //       MaterialPageRoute(
  //         builder: (context) => ResultScreen(
  //           selectedStation: widget.selectedStation,
  //           scannedGasPrices: gasTypePrices,
  //           processLogs: processLogs,
  //         ),
  //       ),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('An error occured while scanning text: $e'),
  //       ),
  //     );
  //   }
  // }
}
