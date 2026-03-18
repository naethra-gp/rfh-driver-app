class EndPoints {
  //live api
  // static const baseApi = 'https://www.rathnafanhouse.co.in/R4X_live_api/api';
  // static const baseApi = 'https://www.rathnafanhouse.in/R4X_live_API/api';
  static const baseApi = 'https://rathnafanhouse.in/R4X_live_API/api';

  //test api
  // static const baseApi =
  //     'https://www.rathnafanhouse.co.in/DeliveryTestWebapi/api';

  static const Google_Map_Api = 'Google API Key';
  static const Google_Map_Api2 = 'Google API Key';
  static const login = "$baseApi/Login/getlogin";
  static const deliveryList = "$baseApi/delivery/getdeliveryList";
  static const deliveryOtpSent = "$baseApi/Otp/Deliveryotp";
  static const deliveryOtpVerify = '$baseApi/Otp/DeliveryOtpverification';
  static const cancelReason = '$baseApi/Cancelstatus/loadcancelreason';
  static const updateCancelStatus = "$baseApi/Cancelstatus/UpdateCancelstatus";
  static const sentForgotPasswordOtp = "$baseApi/Passwordotp/Passwordotp";
  static const forgotPasswordVerification =
      "$baseApi/Passwordotp/passwordverification";
  static const resetPassword = "$baseApi/Passwordotp/Resetpassword";
  static const invoiceCount = "$baseApi/Delivery/InvoiceCount";
}
