import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:vlens/src/data/cached_data.dart';
import 'package:vlens/src/data/models/face_validations_types.dart';
import 'package:vlens/src/language/language_manager.dart';
import '../../vlens.dart';
import '../custom_views/custom_camera_header.dart';
import '../utilities/colors.dart';
import '../utilities/face/camera_service.dart';
import '../utilities/face/face_detector_service.dart';
import '../utilities/image_path_helper.dart';
import '../view_model/flow_controller_view_model.dart';

class FaceValidationScreen extends StatefulWidget {
  final VoidCallback onBack;

  const FaceValidationScreen({super.key, required this.onBack});

  @override
  State<FaceValidationScreen> createState() => _FaceValidationScreenState();
}

class _FaceValidationScreenState extends State<FaceValidationScreen> {
  late FlowControllerViewModel viewModel;
  final CameraService _cameraService = CameraService();
  final FaceDetectionService _faceDetectionService = FaceDetectionService();
  List<FaceValidationTypes> randomFaces = [];
  int currentFaceIndex = 0;

  bool _isInitialized = false;
  late FaceValidationTypes _currentFace;
  bool _isLoading = false;
  bool _shouldFlipPreview = false;
  Timer? _timer;

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    randomFaces = List.from(FaceValidationTypes.predefinedFlows[
        Random().nextInt(FaceValidationTypes.predefinedFlows.length)]);
    _currentFace = randomFaces[currentFaceIndex];
  }

  Future<void> _verifyFaces() async {
    await viewModel.verifyFaces(onSuccess: () {
      setState(() {
        _isLoading = false;
      });
      VLensManager().notifySuccess();
    }, onFailure: (error) {
      setState(() {
        _isLoading = false;
      });
      VLensManager().notifyFailure("Failed to verify $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    String instructionText;
    String imagePath;
    viewModel = Provider.of<FlowControllerViewModel>(context, listen: false);

    switch (_currentFace) {
      case FaceValidationTypes.smile:
        instructionText = LanguageManager.get("smile");
        imagePath = ImagePathHelper.smileFaceImage;
        break;
      case FaceValidationTypes.blink:
        instructionText = LanguageManager.get("blinking");
        imagePath = ImagePathHelper.blinkFaceImage;
        break;
      case FaceValidationTypes.turnHeadRight:
        instructionText = LanguageManager.get("turned_right");
        imagePath = ImagePathHelper.rightFaceImage;
        break;
      case FaceValidationTypes.turnHeadLeft:
        instructionText = LanguageManager.get("turned_left");
        imagePath = ImagePathHelper.leftFaceImage;
        break;
      case FaceValidationTypes.headStraight:
        instructionText = LanguageManager.get("looking_straight");
        imagePath = ImagePathHelper.straightFaceImage;
        break;
    }

    return Scaffold(
      backgroundColor: _isLoading
          ? hexToColor(CachedData.sdkConfig.colors.light.background)
          : Colors.black,
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingScreen()
            : Column(
                children: [
                  // Header fixed at top
                  Container(
                    color: Colors.black,
                    child: CameraHeader(
                      onBackTap: widget.onBack,
                      onFlashToggle: () {},
                      isFlashOn: false,
                      hideFlash: true,
                    ),
                  ),
                  // Camera preview and instructions taking remaining space
                  Expanded(
                    child: Stack(
                      children: [
                        _buildCameraPreview(),
                        _buildInstructionPreview(instructionText, imagePath),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_cameraService.controller == null) {
      return const Center(
        child: Text("Failed to initialize camera",
            style: TextStyle(color: Colors.white)),
      );
    }

    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width,
      height: double.infinity,
      child: RotatedBox(
        quarterTurns: 3,
        child: AspectRatio(
          aspectRatio: screenSize.width / screenSize.height,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: screenSize.width,
              height: screenSize.width /
                  _cameraService.controller!.value.aspectRatio,
              child: Transform(
                alignment: Alignment.center,
                transform: _shouldFlipPreview
                    ? Matrix4.diagonal3Values(1.0, -1.0, 1.0)
                    :(Platform.isIOS
                    ? Matrix4.diagonal3Values(-1.0, -1.0, 1.0)
                    : Matrix4.diagonal3Values(-1.0, 1.0, 1.0)),
                  child: CameraPreview(_cameraService.controller!),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionPreview(String instructionText, String imagePath) {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: UIColors.midnightBlue.withAlpha(80),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.transparent,
                width: 1.0,
              ),
            ),
            child: Text(
              instructionText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: UIColors.white50,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.fromLTRB(3, 6, 3, 0),
            decoration: BoxDecoration(
              color: UIColors.midnightBlue.withAlpha(80),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.transparent,
                width: 1.0,
              ),
            ),
            child: Image.asset(imagePath),
          ),
        ],
      ),
    );
  }

  // ... rest of the code remains the same (loading screen, camera initialization, etc.)

  Widget _buildLoadingScreen() {
    return Column(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Image.asset(ImagePathHelper.logoImage),
              const SizedBox(height: 20),
              Text(
                LanguageManager.get("verifying_your_identity"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: hexToColor(CachedData.sdkConfig.colors.light.primary),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: 243,
                height: 243,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImagePathHelper.gifBackgroundImage),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    ImagePathHelper.faceValidationGif,
                    height: 200,
                    width: 200,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  LanguageManager.get("processing_facial_recognition"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: hexToColor(CachedData.sdkConfig.colors.light.accent),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LanguageManager.get("powered_by"),
              style: TextStyle(
                fontSize: 16,
                color: UIColors.stormy,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 4),
            Image.asset(ImagePathHelper.smallLogoImage),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraService.initialize(defaultCamera: CameraType.front);

      if (_cameraService.controller != null) {
        final CameraDescription cameraDescription =
            _cameraService.controller!.description;

        // Check camera sensor orientation
        bool shouldFlip = cameraDescription.sensorOrientation == 270;
        logger.d(
            'Camera sensor orientation: ${cameraDescription.sensorOrientation}');

        if (mounted) {
          setState(() {
            _isInitialized = true;
            _shouldFlipPreview = shouldFlip; // Store the flag
          });
          _startFaceDetection();
        }
      }
    } catch (e) {
      logger.d('Error initializing camera: $e');
    }
  }

  Future<void> _startFaceDetection() async {
    if (_cameraService.controller == null) return;

    bool isProcessing = false; // Prevent overlapping detections

    if (Platform.isAndroid) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        if (_cameraService.controller != null &&
            _cameraService.controller!.value.isInitialized) {
          final XFile photo = await _cameraService.controller!.takePicture();
          final detectedGesture =
          await _faceDetectionService.detectFaceGestureForAndroid(photo.path);
          if (detectedGesture == _currentFace) {
            await _addFaceDataForAndroid(photo.path);
            if (currentFaceIndex < randomFaces.length - 1) {
              setState(() {
                currentFaceIndex++;
                _currentFace = randomFaces[currentFaceIndex];
              });
            } else {
              setState(() {
                _isLoading = true;
              });
              _verifyFaces();
              _cameraService.controller!.stopImageStream(); // Stop streaming
            }
          }
        }});
    } else if (Platform.isIOS) {
      _cameraService.controller!
          .startImageStream((CameraImage cameraImage) async {
        if (isProcessing) return;

        isProcessing = true;
        Timer(Duration(seconds: 1), () async {
          try {
            final detectedGesture =
                await _faceDetectionService.detectFaceGesture(
              cameraImage,
              _cameraService.controller!.description,
            );

            if (detectedGesture == _currentFace) {
              final inputImage =
                  _faceDetectionService.convertCameraImageToInputImage(
                      cameraImage, _cameraService.controller!.description);
              await _addFaceData(inputImage!);
              if (currentFaceIndex < randomFaces.length - 1) {
                setState(() {
                  currentFaceIndex++;
                  _currentFace = randomFaces[currentFaceIndex];
                });
              } else {
                setState(() {
                  _isLoading = true;
                });
                _verifyFaces();
                _cameraService.controller!.stopImageStream(); // Stop streaming
              }
            }
          } catch (e) {
            logger.d("🐛 Error processing camera stream: $e");
          } finally {
            isProcessing = false; // Allow next detection
          }
        });
      });
    }
  }

  Future<void> _addFaceDataForAndroid(String imagePath) async {
    final File imageFile = File(imagePath);
    final List<int> compressedBytes =
        await _cameraService.compressImage(imageFile);
    viewModel.facesData.add(base64Encode(compressedBytes));
  }

  Future<void> _addFaceData(InputImage inputImage) async {
    if (inputImage.bytes == null) {
      debugPrint("❌ Error: InputImage bytes are null.");
      return;
    }

    final List<int> compressedBytes =
        await _cameraService.compressImageFromBytes(inputImage.bytes!);

    viewModel.facesData.add(base64Encode(compressedBytes));
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _faceDetectionService.dispose();
    super.dispose();
  }
}
