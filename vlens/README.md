# VLens Flutter SDK Documentation

## Overview
VLens Flutter SDK provides seamless integration for biometric verification and identity scanning in your Flutter applications. This SDK supports National ID scanning and liveness detection.

## Installation
To install VLens, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  vlens: latest_version
```

Run the following command to fetch the package:

```sh
flutter pub get
```

## Usage

### Import the Package

```dart
import 'package:vlens/vlens.dart';
```

### Initialize the SDK
To initialize VLens, configure the SDK settings and call `VLensManager().init()`.

```dart
final sdkConfig = SdkConfig(
  transactionId: 'your_transaction_id',
  isLivenessOnly: false,
  isNationalIdOnly: false,
  env: EnvironmentConfig(
    apiBaseUrl: "https://api.vlenseg.com",
    accessToken: "your_access_token",
    refreshToken: "your_refresh_token",
    apiKey: "your_api_key",
    tenancyName: "your_tenancy_name",
  ),
  defaultLocale: "en",
  colors: ColorsConfig(
    light: ColorConfig(
      accent: "#4E5A78",
      primary: "#397374",
      secondary: "#FF4081",
      background: "#FEFEFE",
      dark: "#000000",
      light: "#FFFFFF",
    ),
    dark: ColorConfig(
      accent: "#FFC107",
      primary: "#2196F3",
      secondary: "#FF4081",
      background: "#000000",
      dark: "#FFFFFF",
      light: "#000000",
    ),
  ),
  errorMessages: [
    ApiError(
      errorCode: 101,
      errorMessageEn: "Network error",
      errorMessageAr: "\u062E\u0637\u0623 \u0641\u064A \u0627\u0644\u0634\u0628\u0643\u0629",
    ),
  ],
);

VLensManager().init(context, sdkConfig);
```

### Example Project

```dart
import 'package:flutter/material.dart';
import 'package:vlens/vlens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VLens Flutter SDK Demo',
      home: const VLensDemoScreen(),
    );
  }
}

class VLensDemoScreen extends StatefulWidget {
  const VLensDemoScreen({super.key});

  @override
  State<VLensDemoScreen> createState() => _VLensDemoScreenState();
}

class _VLensDemoScreenState extends State<VLensDemoScreen> {
  final TextEditingController _transactionIdController = TextEditingController();
  final TextEditingController _accessTokenController = TextEditingController();
  bool _isDataComplete = false;

  void _getStarted() {
    final sdkConfig = SdkConfig(
      transactionId: _transactionIdController.text,
      isLivenessOnly: false,
      isNationalIdOnly: false,
      env: EnvironmentConfig(
        apiBaseUrl: "https://api.vlenseg.com",
        accessToken: _accessTokenController.text,
        refreshToken: "your-refresh-token",
        apiKey: "your-api-key",
        tenancyName: "your-tenancy-name",
      ),
      defaultLocale: "en",
    );
    VLensManager().init(context, sdkConfig);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VLens Flutter SDK Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: _isDataComplete ? _getStarted : null,
          child: const Text('Get Started'),
        ),
      ),
    );
  }
}
```

## Configuration Options
### `SdkConfig`
- `transactionId` (String) – Unique identifier for the transaction.
- `isLivenessOnly` (bool) – Whether to enable liveness detection only.
- `isNationalIdOnly` (bool) – Whether to enable national ID scanning only.
- `env` (EnvironmentConfig) – API configuration.
- `defaultLocale` (String) – Default language.
- `colors` (ColorsConfig) – UI theme colors.
- `errorMessages` (List<ApiError>) – Custom error messages.

## Error Handling
Define custom error messages using `ApiError`:

```dart
ApiError(
  errorCode: 101,
  errorMessageEn: "Network error",
  errorMessageAr: "\u062E\u0637\u0623 \u0641\u064A \u0627\u0644\u0634\u0628\u0643\u0629",
);
```

## Support
For questions and support, contact the VLens team at `support@vlens.com`.
