import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vlens/src/data/cached_data.dart';
import 'package:vlens/src/language/language_manager.dart';
import 'package:vlens/src/ui/start_face_validation.dart';
import '../view_model/flow_controller_view_model.dart';
import 'start_national_id.dart';
import 'national_id_screen.dart';
import 'face_validation_screen.dart';

class FlowController extends StatefulWidget {
  const FlowController({super.key});

  @override
  State<FlowController> createState() => _FlowControllerState();
}

class _FlowControllerState extends State<FlowController> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _goToNext() {
    setState(() {
      _currentIndex++;
    });
  }

  void _goToPrevious() {
    setState(() {
      _currentIndex--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FlowControllerViewModel(),
      child: Builder(
        builder: (context) {
          final screens = CachedData.sdkConfig.isLivenessOnly
              ? [
                  StartFaceValidation(onNext: _goToNext),
                  FaceValidationScreen(onBack: _goToPrevious),
                ]
              : [
                  StartNationalId(onNext: _goToNext),
                  NationalIdScreen(onNext: _goToNext, onBack: _goToPrevious),
                  StartFaceValidation(onNext: _goToNext),
                  FaceValidationScreen(onBack: _goToPrevious),
                ];

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: Locale(LanguageManager.lang),
            supportedLocales: const [Locale("en"), Locale("ar")],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              fontFamily: 'poppins',
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: Colors.black,
                  ),
            ),
            // Add these properties
            builder: (context, child) {
              return Directionality(
                textDirection: LanguageManager.lang == "ar"
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: child!,
              );
            },
            home: screens[_currentIndex],
          );
        },
      ),
    );
  }
}
