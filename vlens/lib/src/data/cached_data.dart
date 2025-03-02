import '../vlens_manager.dart';

class CachedData {
  // init with initialize data
  static SdkConfig sdkConfig = SdkConfig(
    transactionId: "",
    isLivenessOnly: true,
    isNationalIdOnly: false,
    env: EnvironmentConfig(
      apiBaseUrl: "https://api.vlenseg.com",
      accessToken: "",
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
}
