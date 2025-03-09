class ApiUrls {
  static const baseURL = "https://agriflow-backend.onrender.com/";
  // static const baseURL = "http://10.42.0.155:3000/";

  static const apiV = "api/v1/";

  static const signin = "$baseURL${apiV}auth/signin";
  static const signup = "$baseURL${apiV}auth/signup";

  static const sendOTP = "$baseURL${apiV}auth/send-otp";
  static const verifyOTP = "$baseURL${apiV}auth/verify-otp";

  static const forgotPassword = "$baseURL${apiV}auth/forgot-password";
  static const resetPassword = "$baseURL${apiV}auth/reset-password";

  static const addField = "$baseURL${apiV}field/add";

  static const fetchFields = "$baseURL${apiV}field/";
  static const deleteField = "$baseURL${apiV}field/remove/";
  static const predictCropRecommendation = "$baseURL${apiV}field/predict-crop/";
  static const setCurrentCrop = "$baseURL${apiV}field/set-current-crop/";
}
