import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:live_footage_ml/main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Camera controller
  late CameraController controller;
  //Image Labeler
  late ImageLabeler imageLabeler;
  //Busy flag
  bool isBusy = false;

  @override
  void initState() {
    // Initialize the camera controller
    super.initState();
    // Initialize the image labeler
    final ImageLabelerOptions options = ImageLabelerOptions(
      confidenceThreshold: 0.5, // Adjust the confidence threshold as needed
    );
    final imageLabeler = ImageLabeler(
      options: options,
    ); // Create an image labeler with the specified options
    //Will use the first camera found
    controller = CameraController(
      // change to 1 for front camera
      cameras[1], //
      ResolutionPreset.max,
    ); // Define the camera to use
    controller
        .initialize()
        .then((_) {
          // If the mounted is not true, then the widget was removed from the tree.
          if (!mounted) {
            return;
          }
          // Start the image frame from the camera
          controller.startImageStream((image) {
            // Handle the image frame here
            // Check if the model is busy
            if (isBusy == false) {
              // If not busy, set the flag to true and perform image labeling
              isBusy = true;
              doImageLabeling(image); // Call the image labeling function
            }
            debugPrint("${image.width} ${image.height}");
          });
          // Update the state to reflect the changes.
          setState(() {});
        })
        // If an error occurs, log the error to the console.
        .catchError((Object e) {
          if (e is CameraException) {
            switch (e.code) {
              case 'CameraAccessDenied':
                // Handle access errors here.
                break;
              default:
                // Handle other errors here.
                break;
            }
          }
        });
  }

  // Image labeling function
  doImageLabeling(CameraImage img) {
    InputImage? inputImage = _inputImageFromCameraImage(img);
    // If the input image is null, return
    setState(() {
      isBusy = false;
    });
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas
    final camera = cameras[1];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        // If the controller is initialized, display the preview.
        child: controller.value.isInitialized
            ? CameraPreview(controller)
            : Container(),
      ),
    );
  }
}
