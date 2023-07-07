import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

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
              Color(0xFF609966), // Start color
              Color(0xFF175124), // End color
            ],
          ),
        ),
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            return Stack(
              children: [
                //Show camera feed behind everything
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

      final file = File(pictureFile.path);

      final inputImage = InputImage.fromFile(file);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      await navigator.push(
        MaterialPageRoute(
          builder: (context) => ResultScreen(text: recognizedText.text),
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

// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:tigas_application/widgets/bottom_navbar.dart';
// import 'package:image_cropper/image_cropper.dart';

// import 'result_screen.dart';

// class CameraScreen extends StatefulWidget {
//   const CameraScreen({Key? key}) : super(key: key);

//   @override
//   State<CameraScreen> createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen>
//     with WidgetsBindingObserver {
//   final int selectedTab = 1;
//   bool _isPermissionGranted = false;

//   late final Future<void> _future;

//   CameraController? _cameraController;

//   final _textRecognizer = GoogleMlKit.vision.textDetector();
//   File? _imageFile;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance?.addObserver(this);

//     _future = _requestCameraPermission();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance?.removeObserver(this);
//     _stopCamera();
//     _textRecognizer.close();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (_cameraController == null || !_cameraController!.value.isInitialized) {
//       return;
//     }

//     if (state == AppLifecycleState.inactive) {
//       _stopCamera();
//     } else if (state == AppLifecycleState.resumed &&
//         _cameraController != null &&
//         _cameraController!.value.isInitialized) {
//       _startCamera();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<void>(
//       future: _future,
//       builder: (context, snapshot) {
//         return Stack(
//           children: [
//             // Show camera feed behind everything
//             if (_isPermissionGranted)
//               FutureBuilder<List<CameraDescription>>(
//                 future: availableCameras(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     _initCameraController(snapshot.data!);

//                     return Center(
//                       child: CameraPreview(_cameraController!),
//                     );
//                   } else {
//                     return const LinearProgressIndicator();
//                   }
//                 },
//               ),
//             Scaffold(
//               appBar: AppBar(
//                 backgroundColor: Color(0xFF609966),
//                 title: const Text('Scan Gasoline Price'),
//                 centerTitle: true,
//                 automaticallyImplyLeading: false,
//               ),
//               backgroundColor: _isPermissionGranted ? Colors.transparent : null,
//               body: _isPermissionGranted
//                   ? Column(
//                       children: [
//                         Expanded(
//                           child: Container(),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.only(bottom: 30.0),
//                           child: Center(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 _captureAndCropImage();
//                               },
//                               child: Text("Submit"),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Color(0xFF175124),
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     )
//                   : Center(
//                       child: Container(
//                         padding: const EdgeInsets.only(left: 24.0, right: 24.0),
//                         child: const Text(
//                           'Camera permission denied',
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//             )
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _requestCameraPermission() async {
//     final status = await Permission.camera.request();
//     _isPermissionGranted = status == PermissionStatus.granted;
//   }

//   void _startCamera() {
//     if (_cameraController != null) {
//       _cameraSelected(_cameraController!.description);
//     }
//   }

//   void _stopCamera() {
//     if (_cameraController != null) {
//       _cameraController?.dispose();
//     }
//   }

//   void _initCameraController(List<CameraDescription> cameras) {
//     if (_cameraController != null) {
//       return;
//     }

//     CameraDescription? camera;
//     for (var i = 0; i < cameras.length; i++) {
//       final CameraDescription current = cameras[i];
//       if (current.lensDirection == CameraLensDirection.back) {
//         camera = current;
//         break;
//       }
//     }

//     if (camera != null) {
//       _cameraSelected(camera);
//     }
//   }

//   Future<void> _cameraSelected(CameraDescription camera) async {
//     _cameraController = CameraController(
//       camera,
//       ResolutionPreset.max,
//       enableAudio: false,
//     );

//     await _cameraController?.initialize();

//     if (!mounted) {
//       return;
//     }
//     setState(() {});
//   }

//   Future<void> _captureAndCropImage() async {
//     if (_cameraController == null) return;

//     try {
//       final pictureFile = await _cameraController!.takePicture();

//       setState(() {
//         _imageFile = File(pictureFile.path);
//       });

//       if (_imageFile != null) {
//         final croppedFile = await ImageCropper().cropImage(
//             sourcePath: _imageFile!.path,
//             aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
//             compressQuality: 100,
//             maxWidth: 800,
//             maxHeight: 800,
//             uiSettings: [
//               AndroidUiSettings(
//                 toolbarTitle: 'Crop Image',
//                 toolbarColor: Color(0xFF609966),
//                 toolbarWidgetColor: Colors.white,
//                 statusBarColor: Color(0xFF609966),
//                 backgroundColor: Colors.white,
//               ),
//             ]);

//         if (croppedFile != null) {
//           _processImage(croppedFile as File);
//         }
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('An error occurred while capturing image'),
//         ),
//       );
//     }
//   }

//   Future<void> _processImage(File imageFile) async {
//     final inputImage = InputImage.fromFile(imageFile);
//     final recognizedText = await _textRecognizer.processImage(inputImage);

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ResultScreen(text: recognizedText.text),
//       ),
//     );
//   }
// }
