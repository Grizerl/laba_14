import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NativeFeaturesScreen(),
    );
  }
}

class NativeFeaturesScreen extends StatefulWidget {
  const NativeFeaturesScreen({super.key});

  @override
  _NativeFeaturesScreenState createState() => _NativeFeaturesScreenState();
}

class _NativeFeaturesScreenState extends State<NativeFeaturesScreen> {
  static const platform = MethodChannel('com.example.native/time');
  File? _image;

  Future<void> _getCurrentTime() async {
    try {
      final String currentTime = await platform.invokeMethod('getCurrentTime');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Поточний час'),
            content: Text(currentTime),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Закрити'),
              ),
            ],
          );
        },
      );
    } on PlatformException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Помилка'),
            content: Text("Не вдалося отримати час: ${e.message}"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Закрити'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flutter Demo Home Page",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _image != null
                    ? Image.file(_image!, height: 300)
                    : const SizedBox(),
                const SizedBox(height: 20),
                _image == null
                    ? const Text("Фото ще не зроблено", style: TextStyle(fontSize: 16))
                    : const SizedBox(),
              ],
            ),
          ),
          Positioned(
            top: 15,
            left: 5,
            child: ElevatedButton(
              onPressed: _getCurrentTime,
              child: const Text("Отримати час"),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePhoto,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
