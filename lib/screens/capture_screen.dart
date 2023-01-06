import 'package:breaker_pro/dataclass/image_list.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({Key? key, required this.cameras}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late CameraDescription camera;
  late List<CameraDescription> _availableCameras;

  List<String> imgList = [];
  FlashMode? _currentFlashMode;
  int currentCameraIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _availableCameras = widget.cameras;
    super.initState();
    _currentFlashMode = FlashMode.off;
    camera = _availableCameras.first;
    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    // _getAvailableCameras();
  }

  Future<void> _getAvailableCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    _availableCameras = await availableCameras();
    _initCamera(_availableCameras.first);
  }

  Future<void> _initCamera(CameraDescription description) async {
    _controller =
        CameraController(description, ResolutionPreset.max, enableAudio: true);

    try {
      await _controller.initialize();
      // to notify the widgets that camera has been initialized and now camera preview can be done
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  // void toggleCamera() {
  //   // If the current camera is the first camera (front), set the current camera index to the second camera (back).
  //   // Otherwise, set the current camera index to the first camera (front).
  //   currentCameraIndex = currentCameraIndex == 0 ? 1 : 0;
  //
  //   // Dispose of the current camera controller and initialize a new one with the selected camera.
  //   _controller.dispose();
  //   _controller = CameraController(camera, ResolutionPreset.medium);
  //   _controller.initialize().then((_) {
  //     if (!mounted) {
  //       return;
  //     }
  //     setState(() {});
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
                height: MediaQuery.of(context).size.height,
                child: CameraPreview(
                  _controller,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FloatingActionButton(
                            // Provide an onPressed callback.
                            onPressed: () async {
                              try {
                                // await _initializeControllerFuture;
                                final image = await _controller.takePicture();
                                if (!mounted) return;

                                print(image.path);
                                imgList.add(image.path);
                                ImageList.vehicleImgList.add(image.path);
                                setState(() {});
                              } catch (e) {
                                // If an error occurs, log the error to the console.
                                print(e);
                              }
                            },
                            child: const Icon(Icons.camera_alt),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 8, 20, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    print('object');
                                    if (_currentFlashMode == FlashMode.off) {
                                      _currentFlashMode = FlashMode.torch;
                                    } else {
                                      _currentFlashMode = FlashMode.off;
                                    }
                                    setState(() {
                                      _controller
                                          .setFlashMode(_currentFlashMode!);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.flash_on,
                                    size: 40,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _toggleCameraLens,
                                  icon: const Icon(
                                    Icons.flip_camera_android,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            width: 60,
                            height: 80,
                            color: Colors.grey,
                            child: imgList.isNotEmpty
                                ? Image.file(File(imgList.last))
                                : SizedBox(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _toggleCameraLens() {
    final lensDirection = _controller.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = _availableCameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = _availableCameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    if (newDescription != null) {
      _initCamera(newDescription);
    } else {
      print('Asked camera not available');
    }
  }
}
