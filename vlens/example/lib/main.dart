import 'package:flutter/material.dart';
import 'login_api.dart';
import 'id_generator.dart';
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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const VLensDemoScreen(),
    );
  }
}

class VLensDemoScreen extends StatefulWidget {
  const VLensDemoScreen({super.key});

  @override
  State<VLensDemoScreen> createState() {
    return _VLensDemoScreenState();
  }
}

class _VLensDemoScreenState extends State<VLensDemoScreen> {
  final TextEditingController _transactionIdController = TextEditingController();
  final TextEditingController _accessTokenController = TextEditingController();
  bool _isLoading = false;  // Track loading state
  bool _isDataComplete = false;
  Color primary = Color(0xFF397374);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.only(top: 14),
          child: Text(
            'VLens Flutter SDK Demo',
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset("packages/vlens/assets/images/vlens_logo.png"),
            ),
            SizedBox(height: 30),
            const Text(
              'Transaction ID',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xff204061),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _transactionIdController,
              enabled: false,
              style: TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(
                    color: Color(0xff9B9999),
                    width: 0.5,
                  ),
                ),
                hintText: 'Transaction ID',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),


            const SizedBox(height: 16),
            const Text(
              'Access Token',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xff204061),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 260,
              child: TextField(
                controller: _accessTokenController,
                maxLines: 9,
                enabled: false,
                style: TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide: BorderSide(
                      color: Color(0xff9B9999),
                      width: 0.5,
                    ),
                  ),
                  hintText: 'Access Token',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _isLoading 
            ?  Center(child:CircularProgressIndicator(color: primary) )
            : _buildButton(
              label: 'Set Default Data',
              onPressed: _setDefaultData,
              enabled: true
            ),
            const SizedBox(height: 12),
            _buildButton(
              label: 'Get Started',
              onPressed: _getStarted,
              enabled: _isDataComplete
            ),
            const SizedBox(height: 12),
            _buildButton(
              label: 'Get Started With Liveness Only',
              onPressed: _getStartedWithLivenessOnly,
              enabled: _isDataComplete
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({required String label, required VoidCallback onPressed, required bool enabled}) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: enabled ? onPressed : null,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _setDefaultData() {
    setState(() {
      _isLoading = true;  // Start loading
      _isDataComplete = false;
    });

    debugPrint('Setting default data...');
    loginApi().then((accessToken) {
      if (accessToken != null) {
        setState(() {
          _isLoading = false;  // Stop loading
          _isDataComplete = true;
          _transactionIdController.text = generateUUID();
          _accessTokenController.text = accessToken;
        });
      }
    });
  }

  void _getStarted() {
    final sdkConfig = SdkConfig(
      transactionId: _transactionIdController.text,
      isLivenessOnly: false,
      isNationalIdOnly: false,
      env: EnvironmentConfig(
        apiBaseUrl: "https://api.vlenseg.com",
        accessToken: _accessTokenController.text,
        refreshToken: "your-refresh-token",
        apiKey: "W70qYFzumZYn9nPqZXdZ39eRjpW5qRPrZ4jlxlG6c",
        tenancyName: "silverkey2",
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
          errorMessageAr: "خطأ في الشبكة",
        ),
      ],
    );

    VLensManager().init(context, sdkConfig);
  }


  void _getStartedWithLivenessOnly() {
    // Handle the 'Get Started With Liveness Only' button click
    debugPrint('Starting Liveness Only...');
    final sdkConfig = SdkConfig(
      transactionId: _transactionIdController.text,
      isLivenessOnly: true,
      isNationalIdOnly: true,
      env: EnvironmentConfig(
        apiBaseUrl: "https://api.vlenseg.com",
        accessToken: _accessTokenController.text,
        refreshToken: "your-refresh-token",
        apiKey: "W70qYFzumZYn9nPqZXdZ39eRjpW5qRPrZ4jlxlG6c",
        tenancyName: "silverkey2",
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
          errorMessageAr: "خطأ في الشبكة",
        ),
      ],
    );

    VLensManager().init(context, sdkConfig);
  }

  @override
  void dispose() {
    _transactionIdController.dispose();
    _accessTokenController.dispose();
    super.dispose();
  }
}
