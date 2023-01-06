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
  Map<String, IconData> map = {
    'off': Icons.flash_off_sharp,
    'on': Icons.flash_on_sharp,
    'auto': Icons.flash_auto_sharp
  };
  String isFlashed = 'off';
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
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.close,
          size: 30,
          color: Colors.red ,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Colors.transparent,

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,

      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
                height: MediaQuery.of(context).size.height,
                child: CameraPreview(
                  _controller,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    // alignment: Alignment.topRight,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: imgList.isNotEmpty
                            ? Image.file(File(imgList.last))
                            : SizedBox(),
                      ),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                            onPressed: (){},
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey),
                            ),
                            child: Text(
                              "Adjust",
                            )),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconButton(
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
                            icon: Icon(Icons.camera,
                            size: 40,),
                        ),
                      ),

                      Expanded(
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (isFlashed == 'off') {
                                  isFlashed = 'on';
                                  _controller.setFlashMode(FlashMode.torch);
                                } else if (isFlashed == 'on') {
                                  isFlashed = 'auto';
                                  _controller.setFlashMode(FlashMode.auto);
                                } else {
                                  isFlashed = 'off';
                                  _controller.setFlashMode(FlashMode.off);
                                }
                              });
                            },
                            icon: Icon(
                              map[isFlashed],
                              size: 35,
                            )),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            print('object');
                            if (_currentFlashMode == FlashMode.off) {
                              _currentFlashMode = FlashMode.torch;
                            } else {
                              _currentFlashMode = FlashMode.off;
                            }
                            setState(() {
                              _controller.setFlashMode(_currentFlashMode!);
                            });
                          },
                          icon: const Icon(
                            Icons.flashlight_on,
                            size: 30,
                          ),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: _toggleCameraLens,
                          icon: const Icon(
                            Icons.flip_camera_android,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton(
      //   // Provide an onPressed callback.
      //   onPressed: () async {
      //     // Take the Picture in a try / catch block. If anything goes wrong,
      //     // catch the error.
      //     try {
      //       // Ensure that the camera is initialized.
      //       await _initializeControllerFuture;
      //
      //       // Attempt to take a picture and get the file `image`
      //       // where it was saved.
      //       final image = await _controller.takePicture();
      //
      //       if (!mounted) return;
      //       print(image.path);
      //       imgList.add(image.path);
      //
      //       // If the picture was taken, display it on a new screen.
      //       // await Navigator.of(context).push(
      //       //   MaterialPageRoute(
      //       //     builder: (context) => DisplayPictureScreen(
      //       //       // Pass the automatically generated path to
      //       //       // the DisplayPictureScreen widget.
      //       //       imagePath: image.path,
      //       //     ),
      //       //   ),
      //       // );
      //     } catch (e) {
      //       // If an error occurs, log the error to the console.
      //       print(e);
      //     }
      //   },
      //   child: const Icon(Icons.camera_alt),
      // ),
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
