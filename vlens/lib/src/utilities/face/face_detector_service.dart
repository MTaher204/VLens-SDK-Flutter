import 'dart:io';

import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../data/models/face_validations_types.dart';

class FaceDetectionService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      enableClassification: true,
      enableTracking: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  bool _isProcessing = false;
  DateTime? _lastDetectionTime;
  static const detectionCooldown = Duration(milliseconds: 500);


  InputImage? convertCameraImageToInputImage(
      CameraImage image, CameraDescription camera) {
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.rotation0deg;

    if (Platform.isAndroid) {
      final bytes = _concatenatePlanes(image.planes);
      final Size imageSize =
      Size(image.width.toDouble(), image.height.toDouble());

      final metadata = InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes[0].bytesPerRow,
      );

      return InputImage.fromBytes(
        bytes: bytes,
        metadata: metadata,
      );
    } else if (Platform.isIOS) {
      final bytes = image.planes[0].bytes;
      final Size imageSize =
      Size(image.width.toDouble(), image.height.toDouble());

      final metadata = InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: InputImageFormat.bgra8888,
        bytesPerRow: image.planes[0].bytesPerRow,
      );

      return InputImage.fromBytes(
        bytes: bytes,
        metadata: metadata,
      );
    }

    return null;
  }

  Uint8List _concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    for (var plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  Future<FaceValidationTypes?> _processFaceDetection(InputImage inputImage) async {
    if (_isProcessing) {
      Logger().d('Skipping processing - already in progress');
      return null;
    }

    if (_lastDetectionTime != null &&
        DateTime.now().difference(_lastDetectionTime!) < detectionCooldown) {
      Logger().d('Skipping processing - within cooldown period');
      return null;
    }

    _isProcessing = true;
    _lastDetectionTime = DateTime.now();

    try {
      Logger().d('Processing image with ML Kit...');
      final List<Face> faces = await _faceDetector.processImage(inputImage);
      Logger().d('Face detection completed. Found ${faces.length} faces');

      if (faces.isEmpty) return null;

      final Face face = faces.first;
      Logger().d('Face properties: Smiling: ${face.smilingProbability}, Left Eye: ${face.leftEyeOpenProbability}, Right Eye: ${face.rightEyeOpenProbability}, Euler Y: ${face.headEulerAngleY}');

      if (face.smilingProbability != null && face.smilingProbability! > 0.5) {
        Logger().d('Smile detected');
        return FaceValidationTypes.smile;
      }

      if (face.leftEyeOpenProbability != null &&
          face.rightEyeOpenProbability != null &&
          face.leftEyeOpenProbability! < 0.2 &&
          face.rightEyeOpenProbability! < 0.2){
        Logger().d('Blink detected');
        return FaceValidationTypes.blink;
      }

      if (face.headEulerAngleY != null) {
        if (face.headEulerAngleY! > 20) {
          Logger().d('Turn head left detected');
          if(Platform.isIOS) {
            return FaceValidationTypes.turnHeadRight;
          } else {
            return FaceValidationTypes.turnHeadLeft;
          }
        } else if (face.headEulerAngleY! < -20) {
          Logger().d('Turn head right detected');
          if(Platform.isIOS) {
            return FaceValidationTypes.turnHeadLeft;
          } else {
            return FaceValidationTypes.turnHeadRight;
          }
        } else if (face.headEulerAngleY!.abs() < 10) {
          return FaceValidationTypes.headStraight;
        }
      }

      return null;
    } catch (e, stackTrace) {
      Logger().e('Error in face detection: $e', error: e, stackTrace: stackTrace);
      return null;
    } finally {
      _isProcessing = false;
    }
  }

  Future<FaceValidationTypes?> detectFaceGestureForAndroid(String path) async {
    try {
      final inputImage = InputImage.fromFilePath(path);
      return await _processFaceDetection(inputImage);
    } catch (e) {
      Logger().e('Error converting file to InputImage: $e');
      return null;
    }
  }

  Future<FaceValidationTypes?> detectFaceGesture(
      CameraImage image, CameraDescription camera) async {
    final inputImage = convertCameraImageToInputImage(image, camera);
    if (inputImage == null) {
      Logger().d('Failed to convert camera image to InputImage');
      return null;
    }
    return await _processFaceDetection(inputImage);
  }

  void dispose() {
    _faceDetector.close();
  }
}
