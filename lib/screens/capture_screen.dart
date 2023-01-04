import 'package:breaker_pro/dataclass/image_list.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late CameraDescription camera;
  List<CameraDescription> _availableCameras=[];

  List<String> imgList = [];
  FlashMode? _currentFlashMode;
  int _selectedCameraIndex = 0;
  int currentCameraIndex = 0;



  @override
  void initState() {
    super.initState();
    _currentFlashMode = FlashMode.off;
    camera = widget.camera;
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    _getAvailableCameras();
  }
  Future<void> _getAvailableCameras() async{
    WidgetsFlutterBinding.ensureInitialized();
    _availableCameras = await availableCameras();
    _initCamera(_availableCameras.first);
  }
  Future<void> _initCamera(CameraDescription description) async{
    _controller = CameraController(description, ResolutionPreset.max, enableAudio: true);

    try{
      await _controller.initialize();
      // to notify the widgets that camera has been initialized and now camera preview can be done
      setState((){});
    }
    catch(e){
      print(e);
    }
  }

  void toggleCamera() {
    // If the current camera is the first camera (front), set the current camera index to the second camera (back).
    // Otherwise, set the current camera index to the first camera (front).
    currentCameraIndex = currentCameraIndex == 0 ? 1 : 0;

    // Dispose of the current camera controller and initialize a new one with the selected camera.
    _controller.dispose();
    _controller = CameraController(camera, ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
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
                              // Take the Picture in a try / catch block. If anything goes wrong,
                              // catch the error.
                              try {
                                // Ensure that the camera is initialized.
                                await _initializeControllerFuture;

                                // Attempt to take a picture and get the file `image`
                                // where it was saved.
                                final image = await _controller.takePicture();

                                if (!mounted) return;
                                print(image.path);
                                imgList.add(image.path);
                                ImageList.imgList.add(image.path);
                                setState(() {});

                                // If the picture was taken, display it on a new screen.
                                // await Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) => DisplayPictureScreen(
                                //       // Pass the automatically generated path to
                                //       // the DisplayPictureScreen widget.
                                //       imagePath: image.path,
                                //     ),
                                //   ),
                                // );
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
  void _toggleCameraLens(){
    final lensDirection =  _controller.description.lensDirection;
    CameraDescription newDescription;
    if(lensDirection == CameraLensDirection.front){
      newDescription = _availableCameras.firstWhere((description) => description.lensDirection == CameraLensDirection.back);
    }
    else{
      newDescription = _availableCameras.firstWhere((description) => description.lensDirection == CameraLensDirection.front);
    }

    if(newDescription != null){
      _initCamera(newDescription);
    }
    else{
      print('Asked camera not available');
    }
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
