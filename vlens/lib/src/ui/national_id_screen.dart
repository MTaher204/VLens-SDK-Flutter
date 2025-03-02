import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:vlens/src/data/cached_data.dart';
import 'package:vlens/src/vlens_manager.dart';
import 'package:vlens/src/language/language_manager.dart';
import '../custom_views/custom_camera_header.dart';
import '../utilities/colors.dart';
import '../utilities/face/camera_service.dart';
import '../utilities/image_path_helper.dart';
import '../view_model/flow_controller_view_model.dart';

enum CapturePhase { front, flip, back }

class NationalIdScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const NationalIdScreen(
      {super.key, required this.onNext, required this.onBack});

  @override
  State<NationalIdScreen> createState() => _NationalIdScreenState();
}

class _NationalIdScreenState extends State<NationalIdScreen> {
  late FlowControllerViewModel viewModel;

  final CameraService _cameraService = CameraService();
  final GlobalKey scanningFrameKey = GlobalKey();

  bool _isFlashOn = false;
  bool _isInitialized = false;
  CapturePhase _currentPhase = CapturePhase.front;
  bool _isLoading = false;

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> verifyBackId() async {
    await viewModel.verifyBackId(onSuccess: () {
      setState(() {
        _isLoading = false;
      });
      if (!CachedData.sdkConfig.isNationalIdOnly) {
        widget.onNext();
      } else {
        VLensManager().notifySuccess();
      }
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
    switch (_currentPhase) {
      case CapturePhase.front:
        instructionText = LanguageManager.get("align_id_front_side_msg");
        imagePath = ImagePathHelper.frontIdImage;
        break;
      case CapturePhase.flip:
        instructionText = LanguageManager.get("flip_your_id");
        imagePath = ImagePathHelper.flipIdImage;
        break;
      case CapturePhase.back:
        instructionText = LanguageManager.get("align_id_back_side_msg");
        imagePath = ImagePathHelper.backIdImage;
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
                  _buildCameraHeader(),
                  Expanded(
                    child: Stack(
                      children: [
                        if (_isInitialized &&
                            _cameraService.controller != null &&
                            _currentPhase != CapturePhase.flip)
                          _buildNationalIDFrontBackPhase(
                            imagePath,
                            instructionText,
                          ),
                        if (_currentPhase == CapturePhase.flip)
                          _buildFlipPhase(imagePath, instructionText)
                      ],
                    ),
                  ),
                  if (_currentPhase != CapturePhase.flip) _buildCaptureButton()
                ],
              ),
      ),
    );
  }

  Widget _buildNationalIDFrontBackPhase(
      String imagePath, String instructionText) {
    return Stack(
      children: [
        _buildCameraPreview(),
        _buildImagePreview(imagePath),
        _buildInstructionText(instructionText),
      ],
    );
  }

  Widget _buildFlipPhase(String imagePath, String instructionText) {
    return Stack(
      children: [
        // Background image or container
        Positioned(
          top: 200,
          left: 20,
          right: 20,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImagePathHelper.idFlipBackgroundImage),
              ),
            ),
            child: Center(
              child: Image.asset(imagePath),
            ),
          ),
        ),
        _buildInstructionText(instructionText),
      ],
    );
  }

  Widget _buildCameraHeader() {
    return CameraHeader(
      onBackTap: widget.onBack,
      onFlashToggle: _toggleFlash,
      isFlashOn: _isFlashOn,
    );
  }

  Widget _buildCameraPreview() {
    return RotatedBox(
      quarterTurns: 1,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox.expand(
          child: CameraPreview(_cameraService.controller!),
        ),
      ),
    );
  }

  Widget _buildImagePreview(String imagePath) {
    return Positioned(
      top: 150,
      left: 20,
      right: 20,
      child: Center(
        child: Image.asset(imagePath),
      ),
    );
  }

  Widget _buildInstructionText(String instructionText) {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
        decoration: BoxDecoration(
          color: UIColors.indigo_50,
          borderRadius: BorderRadius.circular(16),
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
    );
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      key: scanningFrameKey,
      onTap: _takePicture,
      child: Container(
        width: double.infinity,
        height: 130,
        color: Colors.black,
        child: Image.asset(ImagePathHelper.cameraButtonImage),
      ),
    );
  }

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
                LanguageManager.get("scanning_your_id"),
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
                    ImagePathHelper.scanIdImage,
                    height: 200,
                    width: 200,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  LanguageManager.get("processing_your_id"),
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
      await _cameraService.initialize(defaultCamera: CameraType.back);
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      logger.d('Error initializing camera: $e');
    }
  }

  void _toggleFlash() async {
    try {
      await _cameraService.toggleFlash(!_isFlashOn);
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      logger.d('Error toggling flash: $e');
    }
  }

  Future<void> _takePicture() async {
    try {
      final base64Image = await _cameraService.takePicture();
      if (base64Image == null) return;

      viewModel.setImage(base64Image: base64Image, phase: _currentPhase);

      if (_currentPhase == CapturePhase.front) {
        viewModel.verifyFrontId();
        _moveToNextPhase();
      } else if (_currentPhase == CapturePhase.flip) {
        _moveToNextPhase();
      } else if (_currentPhase == CapturePhase.back) {
        setState(() {
          _isLoading = true;
        });
        verifyBackId();
      }
    } catch (e) {
      logger.d('Error taking picture: $e');
    }
  }

  void _moveToNextPhase() {
    if (_currentPhase == CapturePhase.front) {
      setState(() {
        _currentPhase = CapturePhase.flip;
      });

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _currentPhase = CapturePhase.back;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }
}
