// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:tigas_application/models/station_model.dart';
import 'package:tigas_application/styles/styles.dart';
import 'package:string_similarity/string_similarity.dart';
import 'result_screen.dart';

class CameraScreen extends StatefulWidget {
  final Station selectedStation;
  const CameraScreen({
    Key? key,
    required this.selectedStation,
  }) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  final int selectedTab = 1;
  bool _isPermissionGranted = false;

  late final Future<void> _future;

  CameraController? _cameraController;

  final _textRecognizer = TextRecognizer();

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

    _future = _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: getGradientDecoration(),
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            return Stack(
              children: [
                if (_isPermissionGranted)
                  FutureBuilder<List<CameraDescription>>(
                    future: availableCameras(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _initCameraController(snapshot.data!);

                        return Center(
                          child: CameraPreview(_cameraController!),
                        );
                      } else {
                        return const LinearProgressIndicator();
                      }
                    },
                  ),
                Scaffold(
                  backgroundColor:
                      _isPermissionGranted ? Colors.transparent : null,
                  body: _isPermissionGranted
                      ? Column(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 30.0),
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: _scanImage,
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

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
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
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController?.initialize();

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _scanImage() async {
    if (_cameraController == null) return;

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
      final pictureFile = await _cameraController!.takePicture();

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
          await _textRecognizer.processImage(inputImage);

      List<TextBlock> blocks = recognizedText.blocks
        ..sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));

      Map<String, String> gasTypePrices = {};

      for (var block in blocks) {
        // best match variables
        double bestMatchRating = 0.0;
        String bestMatchType = '';

        for (var type in gasTypes) {
          // calculate similarity between type and block text
          double similarity =
              StringSimilarity.compareTwoStrings(type, block.text);
          processLogs.add(
              'Comparing type: $type with block text: ${block.text}. Similarity: $similarity');

          // check if similarity is the best so far
          if (similarity > bestMatchRating) {
            bestMatchRating = similarity;
            bestMatchType = type;
          }
        }

        processLogs.add(
            'Best match type: $bestMatchType with similarity: $bestMatchRating');

        // check if a good match was found
        if (bestMatchType.isNotEmpty && bestMatchRating > 0.6) {
          // threshold
          RegExp exp = RegExp('$bestMatchType\\s(\\d+\\.\\d+)');
          var matches = exp.allMatches(block.text);

          if (matches.isNotEmpty) {
            gasTypePrices[bestMatchType] = matches.first.group(1)!;
            processLogs.add(
                'Match found. Type: $bestMatchType, Price: ${gasTypePrices[bestMatchType]}');
          }
        } else {
          processLogs.add(
              'No match found or similarity below threshold for block: ${block.text}');
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
}
