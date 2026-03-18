import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import '../../../../app_config/app_end_points.dart';
import '../../../../app_services/index_services.dart';
import '../../../../app_storage/secure_storage.dart';
import '../../../../app_utils/index_app_util.dart';

class ForgotController {
  AlertService alertService = AlertService();
  Future<bool> hasInternet = InternetConnectivity().hasInternetConnection;
  // Check Internet connectivity before sending OTP
  Future<bool> sentOtp({String? mobileNo, String? vehicleNo}) async {
    if (!await hasInternet) {
      alertService.hideLoading();
      alertService.errorToast('Please check your internet connection');
      return false;
    }

    var value = {"Vehicleno": vehicleNo, "Mobileno": mobileNo};

    var response =
        await Connection().post(EndPoints.sentForgotPasswordOtp, value);

    switch (response['message']) {
      case 'password Otp send successfully':
        await BoxStorage().deleteLoginInfo();
        alertService.hideLoading();
        alertService.successToast('Otp sent successfully');
        return true;
      case 'Mobile number not found':
        alertService.hideLoading();
        alertService.errorToast('Entered Mobile number not found');
        return false;
      case 'vehicle Number Not Match':
        alertService.hideLoading();
        alertService.errorToast('Vehicle Number Not Match');
        return false;
      default:
        alertService.hideLoading();
        alertService.errorToast('An error occurred. Please try again.');
        return false;
    }
  }

  Future<String> verifyPasswordOtp(
      {required mobileNo, required otp, required vehicleNo}) async {
    if (!await hasInternet) {
      alertService.hideLoading();
      alertService.errorToast('Please check your internet connection');
      return '';
    }
    var value = {"vehicleno": vehicleNo, "Mobileno": mobileNo, "otp": otp};
    var response =
        await Connection().post(EndPoints.forgotPasswordVerification, value);
    switch (response['message']) {
      case 'Success':
        return 'Otp Verified';
      case 'Otp Not Match':
        return "Otp Not Match, Please check";
      case 'Mobile Number Not Found':
        return "Entered Mobile number not found";
      case 'vehicle Number Not Match':
        return "Vehicle Number Not Match";

      default:
        return 'An error occurred. Please try again.';
    }
  }

  Future<String> resetPassword(
      {required mobileNo, required password, required vehicleNo}) async {
    if (!await hasInternet) {
      alertService.hideLoading();
      alertService.errorToast('Please check your internet connection');
      return '';
    }

    var value = {
      "vehicleno": vehicleNo,
      "Mobileno": mobileNo,
      "Password": password
    };
    var response = await Connection().post(EndPoints.resetPassword, value);

    switch (response['message']) {
      case 'Password Reset Successfully':
        return 'Password Reset Successfully';
      case 'mobilenumber Not Found':
        return "Entered Mobile number not found";
      case 'vehicle Number Not Match':
        return "Vehicle Number Not Match";
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
