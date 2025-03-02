class LanguageManager {
  static String lang = "en"; // Default language

  static void setLanguage(String newLang) {
    lang = newLang;
  }

  static String get(String key) {
    return _localizedStrings[lang]?[key] ?? key;
  }

  static const Map<String, Map<String, String>> _localizedStrings = {
    "en": {
      "camera_permission_msg": "Camera permission is required to use this feature.",
      "align_id_front_side_msg": "Place Front Id inside the rectangle",
      "align_id_back_side_msg": "Place Back Id inside the rectangle",
      "uploading_msg": "Uploading…",
      "success": "Success",
      "error": "Error",
      "failed_to_capture_image": "Failed to capture image.",
      "back_image_captured": "Back image captured.",
      "front_image_captured": "Front image captured.",
      "internet_connection_error": "Internet connection error.",
      "no_camera_device_found": "No camera device found.",
      "div_failed": "Digital Identity verification failed.",
      "div_success": "Digital Identity verification success.",
      "smile": "Show us your best smile!",
      "blinking": "Give us a quick blink!",
      "turned_right": "Turn face a bit to the right",
      "turned_left": "Now, turn face a bit to the left",
      "looking_straight": "Look directly into the camera.",
      "verifying_your_identity": "Verifying your identity",
      "processing_facial_recognition": "Processing facial recognition… \n Hold still!",
      "powered_by": "Powered By",
      "camera": "Camera",
      "scanning_your_id": "Scanning your ID",
      "processing_your_id": "Processing your ID… This may take a moment.",
      "lets_verify_your_face": "Let’s Verify Your Face 👨🏽",
      "face_instructions": "You’ll be asked to do a random 3 out of these 5 fun movements",
      "tip_title": "A Few Tips for Success:",
      "face_tip_1": "Keep your camera steady to make sure the pictures come out sharp.",
      "start_scanning": "Start Scanning",
      "scanning_your_id_title": "Scan Your ID 🪪",
      "national_id_instructions": "To get started, we need to verify your identity. Please take a clear photo of both the front and back of your ID.",
      "national_id_tip_1": "Make sure you’re in a well-lit area so your ID and face are clearly visible.",
      "national_id_tip_2": "Make sure it's easy to read!",
      "scan_id": "Scan ID",
      "dot": "•",
      "retake": "Retake",
      "continue_word": "Continue",
      "flip_your_id": "Flip your ID"
    },
    "ar": {
      "camera_permission_msg": "يتطلب إذن الكاميرا لاستخدام هذه الميزة.",
      "align_id_front_side_msg": "ضع الوجه الأمامي للبطاقة داخل المستطيل.",
      "align_id_back_side_msg": "ضع الوجه الخلفي للبطاقة داخل المستطيل.",
      "uploading_msg": "جارٍ التحميل…",
      "success": "تم بنجاح",
      "error": "خطأ",
      "failed_to_capture_image": "فشل في التقاط الصورة.",
      "back_image_captured": "تم التقاط صورة الوجه الخلفي.",
      "front_image_captured": "تم التقاط صورة الوجه الأمامي.",
      "internet_connection_error": "خطأ في اتصال الإنترنت.",
      "no_camera_device_found": "لم يتم العثور على جهاز كاميرا.",
      "div_failed": "فشل التحقق من الهوية الرقمية.",
      "div_success": "نجاح التحقق من الهوية الرقمية.",
      "smile": "أرنا أفضل ابتسامة لديك!",
      "blinking": "امنحنا غمضة سريعة!",
      "turned_right": "قم بتحريك وجهك قليلاً إلى اليمين.",
      "turned_left": "الآن، حرك وجهك قليلاً إلى اليسار.",
      "looking_straight": "انظر مباشرة إلى الكاميرا.",
      "verifying_your_identity": "جارٍ التحقق من هويتك",
      "processing_facial_recognition": "جارٍ معالجة التعرف على الوجه…\n الرجاء الثبات!",
      "powered_by": "مدعوم من",
      "camera": "كاميرا",
      "scanning_your_id": "جارٍ مسح بطاقتك الشخصية",
      "processing_your_id": "جارٍ معالجة بطاقتك… قد يستغرق الأمر بعض الوقت.",
      "lets_verify_your_face": "دعنا نتحقق من وجهك 👨🏽",
      "face_instructions": "سيُطلب منك أداء 3 حركات عشوائية من بين هذه الحركات الممتعة الخمس.",
      "tip_title": "بعض النصائح للنجاح:",
      "face_tip_1": "حافظ على ثبات الكاميرا لضمان وضوح الصور.",
      "start_scanning": "ابدأ المسح",
      "scanning_your_id_title": "مسح بطاقتك 🪪",
      "national_id_instructions": "للبدء، نحتاج إلى التحقق من هويتك. يُرجى التقاط صورة واضحة للوجه الأمامي والخلفي لبطاقتك.",
      "national_id_tip_1": "تأكد من أنك في مكان مضاء جيداً بحيث تكون بطاقتك ووجهك مرئيين بوضوح.",
      "national_id_tip_2": "تأكد من أن النص واضح وسهل القراءة!",
      "scan_id": "مسح البطاقة",
      "dot": "•",
      "retake": "إعادة التصوير",
      "continue_word": "متابعة",
      "flip_your_id": "اقلب البطاقة"
    }
  };
}
