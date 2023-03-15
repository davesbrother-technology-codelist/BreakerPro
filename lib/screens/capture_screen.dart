import 'package:breaker_pro/app_config.dart';
import 'package:breaker_pro/dataclass/image_list.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({Key? key, required this.cameras, required this.type})
      : super(key: key);
  final List<CameraDescription> cameras;
  final String type;

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
  Map<String, IconData> flashMap = {
    'off': Icons.flash_off_sharp,
    'on': Icons.flash_on_sharp,
    'auto': Icons.flash_auto_sharp
  };
  late XFile image;
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
      initialiseCamera();
    // _getAvailableCameras();
  }

  Future<void> initialiseCamera() async {
     _initializeControllerFuture = _controller.initialize().then((value) => {_controller.setFlashMode(FlashMode.off)
     });

  }

  Future<void> _initCamera(CameraDescription description) async {
    _controller =
        CameraController(description, ResolutionPreset.max, enableAudio: true);

    try {
      await _controller.initialize();
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(
          Icons.close,
          size: 30,
          color: Colors.red,
        ),
      ),
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Center(
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: orientation == Orientation.portrait ? AppConfig.aspectMap[AppConfig.imageAspectRatio] : 1/AppConfig.aspectMap[AppConfig.imageAspectRatio],
                    child: CameraPreview(
                      _controller,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: imgList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.file(File(imgList.last)),
                                    )
                                  : const SizedBox(),
                            ),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      if (imgList.isEmpty) return;
                                      print('image first');
                                      CroppedFile? croppedImage =
                                          await ImageCropper().cropImage(
                                              sourcePath:
                                                  imgList.last);
                                      print('image after');
                                      if (croppedImage == null) return;
                                      // img=croppedImage.path as File?;
                                      print('image after');
                                      setState(() {
                                        imgList.last = croppedImage.path;
                                        if (widget.type == 'Vehicle') {
                                          ImageList.vehicleImgList
                                              .remove(image.path);
                                          ImageList.vehicleImgList
                                              .add(croppedImage.path);
                                        } else if (widget.type ==
                                            'ScanImaging') {
                                          ImageList.scanImagingList
                                              .remove(image.path);
                                          ImageList.scanImagingList
                                              .add(croppedImage.path);
                                        } else {
                                          ImageList.partImageList
                                              .remove(image.path);
                                          ImageList.partImageList
                                              .add(croppedImage.path);
                                        }

                                        Navigator.of(context).pop();
                                      });
                                    } on PlatformException catch (e) {
                                      print(e);
                                      Navigator.of(context).pop();
                                    }
                                  },
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
                                    image = await _controller.takePicture();
                                    File imgFile = File(image.path);
                                    imgFile = await FlutterExifRotation.rotateAndSaveImage(path: imgFile.path);
                                    // imgFile = imgFile.renameSync(
                                    //     image.path.replaceAll('.jpg', '.png'));

                                    if (!mounted) return;
                                    setState(() {
                                      if (widget.type == 'Vehicle') {
                                        // int count = PartsList.vehicleCount;
                                        // String newPath = path.join(dir,
                                        //     'IMGVHC${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${count.toString().padLeft(4, '0')}$count${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.jpg');
                                        // imgFile = imgFile.renameSync(newPath);
                                        imgList.add(imgFile.path);
                                        ImageList.vehicleImgList
                                            .add(imgFile.path);
                                        print(imgFile.path);
                                      } else if (widget.type == 'ScanImaging') {
                                        // int count = PartsList.vehicleCount;
                                        // String newPath = path.join(dir,
                                        //     'IMGVHC${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${count.toString().padLeft(4, '0')}$count${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.jpg');
                                        // imgFile = imgFile.renameSync(newPath);
                                        imgList.add(imgFile.path);
                                        ImageList.scanImagingList
                                            .add(imgFile.path);
                                        print(imgFile.path);
                                      } else if (widget.type == 'ManagePart') {
                                        // String newPath = path.join(dir,
                                        //     'IMG${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.jpg');
                                        // imgFile = imgFile.renameSync(newPath);
                                        imgList.add(imgFile.path);
                                        ImageList.managePartImageList
                                            .add(imgFile.path);
                                        print(imgFile.path);
                                      } else {
                                        // int count = PartsList.partCount;
                                        // String newPath = path.join(dir,
                                        //     'IMGPRT${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${count.toString().padLeft(4, '0')}$count${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.jpg');
                                        // imgFile = imgFile.renameSync(newPath);
                                        imgList.add(imgFile.path);
                                        ImageList.partImageList
                                            .add(imgFile.path);
                                        print(imgFile.path);
                                      }
                                      image = XFile(imgFile.path);
                                    });
                                  } catch (e) {
                                    // If an error occurs, log the error to the console.
                                    print("Error capturing $e");
                                  }
                                },
                                icon: const Icon(
                                  Icons.camera,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (isFlashed == 'off') {
                                        isFlashed = 'on';
                                        _controller
                                            .setFlashMode(FlashMode.torch);
                                      } else if (isFlashed == 'on') {
                                        isFlashed = 'auto';
                                        _controller
                                            .setFlashMode(FlashMode.auto);
                                      } else {
                                        isFlashed = 'off';
                                        _controller.setFlashMode(FlashMode.off);
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    flashMap[isFlashed],
                                    size: 35,
                                    color: Colors.white,
                                  )),
                            ),
                            Expanded(
                              child: IconButton(
                                onPressed: () {
                                  print('object');
                                  if (_currentFlashMode == FlashMode.off) {
                                    _currentFlashMode = FlashMode.torch;
                                    isFlashed = "on";
                                  } else {
                                    _currentFlashMode = FlashMode.off;
                                    isFlashed = "off";
                                  }
                                  setState(() {
                                    _controller
                                        .setFlashMode(_currentFlashMode!);
                                  });
                                },
                                icon: const Icon(
                                  Icons.flashlight_on,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                onPressed: _toggleCameraLens,
                                icon: const Icon(
                                  Icons.flip_camera_android,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          },
        ),
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
