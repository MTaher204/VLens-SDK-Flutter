import 'package:flutter/material.dart';
import 'package:vlens/src/language/language_manager.dart';
import 'package:vlens/src/utilities/image_path_helper.dart';

import '../custom_views/custom_button.dart';
import '../data/cached_data.dart';
import '../utilities/colors.dart';

class StartFaceValidation extends StatelessWidget {
  final VoidCallback onNext;

  const StartFaceValidation({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor(CachedData.sdkConfig.colors.light.background),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo
                        Image.asset(ImagePathHelper.logoImage),

                        const SizedBox(height: 20),

                        // Scan Your ID Text
                        Text(
                          LanguageManager.get("lets_verify_your_face"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            color: hexToColor(CachedData.sdkConfig.colors.light.primary),
                            fontWeight: FontWeight.bold,
                          ),
                        ),


                        // GIF Container Takes Remaining Space
                        Expanded(
                          child: SizedBox(
                            width: 243,
                            child: Center(
                              child: Image.asset(
                                ImagePathHelper.faceProcessingImage,
                                height: 230,
                                width: 230,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),

                        // Instructions Text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            LanguageManager.get("face_instructions"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: hexToColor(CachedData.sdkConfig.colors.light.accent),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Tips Container
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: UIColors.infoBlue50,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: UIColors.infoBlue,
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      color: UIColors.infoBlue500, size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    LanguageManager.get("tip_title"),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: UIColors.infoBlue900,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildTip(LanguageManager.get("face_tip_1")),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Scan ID Button
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            backgroundColor: UIColors.teal,
                            text: LanguageManager.get("start_scanning"),
                            onPressed: onNext,
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Powered by
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
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ',
              style: TextStyle(
                fontSize: 14,
                color: UIColors.infoBlue500,
                fontWeight: FontWeight.w400,
              )),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: UIColors.infoBlue500,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
