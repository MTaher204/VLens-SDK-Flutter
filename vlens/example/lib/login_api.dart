import 'dart:convert'; // For JSON encoding/decoding
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

Future<String?> loginApi() async {

  var logger = Logger();

  logger.d('Call Log in API ...');
  const url = 'https://api.vlenseg.com/api/DigitalIdentity/Login';

  // Request body
  const requestBody = {
    "geoLocation": {
      "latitude": 30.193033,
      "longitude": 31.463339,
    },
    "imsi": null,
    "imei": "123456789",
    "phoneNumber": "+201556005675",
    "password": "P@ssword123",
  };

  // Headers
  const headers = {
    "Content-Type": "application/json",
    "Accept": "text/plain",
    "ApiKey": "W70qYFzumZYn9nPqZXdZ39eRjpW5qRPrZ4jlxlG6c",
    "TenancyName": "silverkey2",
  };

  logger.d('Request Body: $requestBody');
  // Make the POST request
  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(requestBody),
  );

  logger.d('Response Body: ${response.body}');

  if (response.statusCode == 200) {
    // Decode the response
    final responseData = jsonDecode(response.body);
    final accessToken = responseData['data']?['accessToken'];

    if (accessToken != null) {
      logger.d('Access Token: $accessToken');
      return accessToken;
    } else {
      logger.d('Access Token not found in the response');
      return null;
    }
  } else {
    logger.d('Failed to login. Status code: ${response.statusCode}');
    logger.d('Failed to login. Response: ${response.body}');
    return null;
  }
}