import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:logger/logger.dart';

enum CameraType { front, back }

class CameraService {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  CameraType _currentType = CameraType.back;

  bool get isInitialized => _controller?.value.isInitialized ?? false;
  CameraType get currentType => _currentType;

  Future<void> initialize({CameraType defaultCamera = CameraType.back}) async {
    try {
      _cameras = await availableCameras();
      if (_cameras?.isEmpty ?? true) {
        throw CameraException('no_cameras', 'No cameras available');
      }

      await switchCamera(defaultCamera);
    } on CameraException catch (e) {
      debugPrint('Camera initialization error: ${e.description}');
      rethrow;
    }
  }

  Future<void> switchCamera(CameraType type) async {
    if (_cameras == null) return;

    // Find the requested camera
    final camera = _cameras!.firstWhere(
      (camera) => type == CameraType.back
          ? camera.lensDirection == CameraLensDirection.back
          : camera.lensDirection == CameraLensDirection.front,
      orElse: () => _cameras!.first,
    );

    // Dispose of the current controller if it exists
    await _controller?.dispose();

    // Create and initialize new controller
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _controller!.initialize();
      if (Platform.isAndroid) {
        await _controller!.lockCaptureOrientation(DeviceOrientation.portraitUp);
      } else {
        await _controller!
            .lockCaptureOrientation(DeviceOrientation.landscapeLeft);
      }
      _currentType = type;
    } on CameraException catch (e) {
      debugPrint('Camera switch error: ${e.description}');
      rethrow;
    }
  }

  Future<String?> takePicture() async {
    if (_controller == null || !isInitialized) {
      throw CameraException(
          'camera_uninitialized', 'Camera is not initialized');
    }

    if (_controller!.value.isTakingPicture) {
      return null;
    }

    try {
      final XFile photo = await _controller!.takePicture();

      final File imageFile = File(photo.path);
      final List<int> compressedBytes = await compressImage(imageFile);
      return base64Encode(compressedBytes);
    } on CameraException catch (e) {
      debugPrint('Error taking picture: ${e.description}');
      rethrow;
    }
  }

  Future<List<int>> compressImage(File file) async {
    final List<int>? compressed = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 50,
      format: CompressFormat.jpeg,
    );

    return compressed ?? await file.readAsBytes();
  }

  Future<List<int>> compressImageFromBytes(Uint8List bytes) async {
    try {
      final List<int> compressed = await FlutterImageCompress.compressWithList(
        bytes,
        quality: 50,
      );

      if (compressed.isEmpty) {
        Logger().d("Compression failed, returning original bytes.");
        return bytes;
      }

      return compressed;
    } catch (e) {
      Logger().d("Compression failed1 : $e");
      return bytes;
    }
  }

  Future<void> toggleFlash(bool isOn) async {
    if (!isInitialized) return;

    try {
      await _controller?.setFlashMode(
        isOn ? FlashMode.torch : FlashMode.off,
      );
    } on CameraException catch (e) {
      debugPrint('Error toggling flash: ${e.description}');
      rethrow;
    }
  }

  CameraController? get controller => _controller;

  void dispose() {
    _controller?.dispose();
    _controller = null;
    _cameras = null;
  }
}
