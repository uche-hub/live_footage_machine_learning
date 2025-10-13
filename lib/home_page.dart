import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    // Initialize the camera controller
    super.initState();
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
