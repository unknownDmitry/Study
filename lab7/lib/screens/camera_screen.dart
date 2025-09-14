import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  CameraController? controller;
  Future<void>? initializeControllerFuture;
  bool isCameraReady = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('Камера не найдена');
      }

      final firstCamera = cameras.first;

      controller = CameraController(firstCamera, ResolutionPreset.medium);

      initializeControllerFuture = controller!.initialize().then((_) {
        if (!mounted) return;
        setState(() => isCameraReady = true);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка инициализации камеры: ${e.toString()}'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Фотография неба')),
      body: initializeControllerFuture == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<void>(
              future: initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (controller != null) {
                    return CameraPreview(controller!);
                  } else {
                    return const Center(
                      child: Text('Ошибка инициализации камеры'),
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: isCameraReady ? takePicture : null,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Future<void> takePicture() async {
    try {
      if (initializeControllerFuture == null || controller == null) {
        throw Exception('Камера не инициализирована');
      }

      await initializeControllerFuture!;
      final image = await controller!.takePicture();

      if (!mounted) return;

      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Фотография сделана'),
            content: Image.file(File(image.path)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка: ${e.toString()}')));
      }
    }
  }
}
