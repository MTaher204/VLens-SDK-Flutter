import 'package:flutter/material.dart';
import 'package:vlens/src/language/language_manager.dart';

import '../utilities/image_path_helper.dart';

class CameraHeader extends StatelessWidget {
  final VoidCallback onBackTap;
  final VoidCallback onFlashToggle;
  final bool isFlashOn;
  final bool hideFlash;

  const CameraHeader({
    super.key,
    required this.onBackTap,
    required this.onFlashToggle,
    required this.isFlashOn,
    this.hideFlash = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBackTap,
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24,
            ),
          ),
          const Spacer(),
          Text(
            LanguageManager.get("camera"),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (!hideFlash)
            GestureDetector(
              onTap: onFlashToggle,
              child: Image.asset(
                isFlashOn
                    ? ImagePathHelper.flashOnIcon
                    : ImagePathHelper.flashOffIcon,
                width: 28,
                height: 28,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }
}
