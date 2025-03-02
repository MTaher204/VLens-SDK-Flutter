import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:vlens/src/data/cached_data.dart';
import 'package:vlens/src/language/language_manager.dart';

import '../ui/national_id_screen.dart';

class FlowControllerViewModel extends ChangeNotifier {

  var logger = Logger();

  String frontImage = "";
  String backImage = "";
  List<String> facesData = [];

  void setImage({required String base64Image, required CapturePhase phase}) {
    if (phase == CapturePhase.front) {
      frontImage = base64Image;
    } else if (phase == CapturePhase.back) {
      backImage = base64Image;
    }
    notifyListeners(); // Update UI if needed
  }

  /// Generic API request function
  Future<Map<String, dynamic>?> _makeApiRequest({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    final String url = '${CachedData.sdkConfig.env.apiBaseUrl}$endpoint';
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept_Language": LanguageManager.lang,
      "ApiKey": CachedData.sdkConfig.env.apiKey,
      "TenancyName": CachedData.sdkConfig.env.tenancyName,
      "Authorization": "Bearer ${CachedData.sdkConfig.env.accessToken}"
    };

    logger.d('Sending API Request: $url');
    logger.d('Request Headers: $headers');
    logger.d('Request Body: $body');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      logger.d('Response Status: ${response.statusCode}');
      logger.d('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorMessage = jsonDecode(response.body)['error_message'] ??
            'Unknown error occurred';
        logger.d('Error: ${response.statusCode} - $errorMessage');
        return {'error': errorMessage};
      }
    } catch (e) {
      logger.d('Request failed: $e');
      return {'error': 'Request failed: $e'};
    }
  }

  /// Verifies the front side of the ID
  Future<void> verifyFrontId() async {
    logger.d("Verifying front ID");
    final Map<String, dynamic> requestBody = {
      "transaction_id": CachedData.sdkConfig.transactionId,
      "image": frontImage,
    };

    final response = await _makeApiRequest(
      endpoint: "/api/DigitalIdentity/verify/id/front",
      body: requestBody,
    );

    if (response != null && !response.containsKey('error')) {
      logger.d('Front ID verification success: $response');
    } else {
      final errorMessage = response?['error'] ?? 'Unknown error occurred';
      logger.d('Front ID verification failed: $errorMessage');
    }
  }

  /// Verifies the back side of the ID
  Future<void> verifyBackId({
    required VoidCallback onSuccess,
    required Function(String) onFailure,
  }) async {
    logger.d("Verifying back ID");
    final Map<String, dynamic> requestBody = {
      "transaction_id": CachedData.sdkConfig.transactionId,
      "image": backImage,
    };

    final response = await _makeApiRequest(
      endpoint: "/api/DigitalIdentity/verify/id/back",
      body: requestBody,
    );

    if (response != null && !response.containsKey('error')) {
      logger.d('Back ID verification success: $response');
      final validationErrors =
          response['services']?['Validations']?['validation_errors'];

      if (validationErrors != null && validationErrors.isNotEmpty) {
        final firstError = validationErrors[0]?['errors']?.first;
        final errorMessage = firstError?['message'];
        onFailure(errorMessage);
      } else {
        onSuccess();
      }
    } else {
      final errorMessage = response?['error'] ?? 'Unknown error occurred';
      logger.d('Back ID verification success: $response');
      logger.d(errorMessage);
      onFailure(errorMessage);
    }
  }

  /// Verifies the faces of the ID
  Future<void> verifyFaces({
    required VoidCallback onSuccess,
    required Function(String) onFailure,
  }) async {
    logger.d("Verifying Faces");
    logger.d("Faces Data: ${facesData.length}");
    final Map<String, dynamic> requestBody = {
      "transaction_id": CachedData.sdkConfig.transactionId,
      "face_1": facesData[0],
      "face_2": facesData[1],
      "face_3": facesData[2],
    };

    final response = await _makeApiRequest(
      endpoint: "/api/DigitalIdentity/verify/liveness/multi",
      body: requestBody,
    );

    if (response != null && !response.containsKey('error')) {
      logger.d('Back ID verification success: $response');
      final validationErrors =
      response['services']?['Validations']?['validation_errors'];

      if (validationErrors != null && validationErrors.isNotEmpty) {
        final firstError = validationErrors[0]?['errors']?.first;
        final errorMessage = firstError?['message'];
        onFailure(errorMessage);
      }
      else if (response['data']?['isVerificationProcessCompleted'] == false ||
          response['data']?['isDigitalIdentityVerified'] == false){
        onFailure("");
      } else {
        onSuccess();
      }
    } else {
      final errorMessage = response?['error'] ?? 'Unknown error occurred';
      logger.d('Back ID verification success: $response');
      logger.d(errorMessage);
      onFailure(errorMessage);
    }
  }
}
