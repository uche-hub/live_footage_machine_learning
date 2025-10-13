import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:live_footage_ml/home_page.dart';

late List<CameraDescription> cameras;

Future<void> main() async{
  // Ensure that plugin services are initialized so that `availableCameras()`
  WidgetsFlutterBinding.ensureInitialized();
  // Obtain a list of the available cameras on the device.
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(title: 'Real Time Footage'),
    );
  }
}
