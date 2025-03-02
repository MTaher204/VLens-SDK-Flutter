import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vlens/src/ui/flow_controller.dart';

import 'data/cached_data.dart';
import 'language/language_manager.dart';

class VLensManager {
  static final VLensManager _instance = VLensManager._internal();

  factory VLensManager() => _instance;

  var logger = Logger();

  VLensManager._internal();

  late SdkConfig sdkConfig;
  Function()? onSuccess;
  Function(String error)? onFailure;

  void init(BuildContext context, SdkConfig config) {
    sdkConfig = config;
    onSuccess = () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Success Verified!")),
      );
      logger.d("VLensManager initialized successfully!");
    };

    onFailure = (error) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      logger.d("VLensManager failed to initialize: $error");
    };
    CachedData.sdkConfig = sdkConfig;
    LanguageManager.setLanguage(sdkConfig.defaultLocale);

    // Navigate to FlowController
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlowController(),
      ),
    );
  }

  void notifySuccess() {
    onSuccess?.call();
  }

  void notifyFailure(String error) {
    onFailure?.call(error);
  }
}

class SdkConfig {
  final String transactionId;
  final bool isLivenessOnly;
  final bool isNationalIdOnly;
  final EnvironmentConfig env;
  final String defaultLocale;
  final ColorsConfig colors;
  final List<ApiError> errorMessages;

  SdkConfig({
    required this.transactionId,
    required this.isLivenessOnly,
    required this.isNationalIdOnly,
    required this.env,
    required this.defaultLocale,
    required this.colors,
    required this.errorMessages,
  });
}

class EnvironmentConfig {
  final String apiBaseUrl;
  final String accessToken;
  final String refreshToken;
  final String apiKey;
  final String tenancyName;

  EnvironmentConfig({
    required this.apiBaseUrl,
    required this.accessToken,
    required this.refreshToken,
    required this.apiKey,
    required this.tenancyName,
  });
}

class ColorsConfig {
  final ColorConfig light;
  final ColorConfig dark;

  ColorsConfig({required this.light, required this.dark});
}

class ColorConfig {
  final String accent;
  final String primary;
  final String secondary;
  final String background;
  final String dark;
  final String light;

  ColorConfig({
    required this.accent,
    required this.primary,
    required this.secondary,
    required this.background,
    required this.dark,
    required this.light,
  });
}

class ApiError {
  final int errorCode;
  final String errorMessageEn;
  final String errorMessageAr;

  ApiError({required this.errorCode, required this.errorMessageEn, required this.errorMessageAr});
}
