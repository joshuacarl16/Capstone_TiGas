import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_cropper/image_cropper.dart';

import 'result_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

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
                                  child: Text("Submit"),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF175124)),
                                ),
                              ),
                            )
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
                )
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
      ResolutionPreset.max,
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

      StringBuffer buffer = StringBuffer();

      for (var block in blocks) {
        buffer.writeln(block.text);
      }

      String text = buffer.toString();

      await navigator.push(
        MaterialPageRoute(
          builder: (context) => ResultScreen(text: text),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occured while scanning text'),
        ),
      );
    }
  }
}
