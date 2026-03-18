import 'package:rfh/app_config/app_end_points.dart';
import 'package:rfh/app_services/connection.dart';
import 'package:rfh/app_utils/alert_widget.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';

class OtpController {
  AlertService alertService = AlertService();
  Future<bool> hasInternet = InternetConnectivity().hasInternetConnection;

  Future<String> verifyOtp({
    String? otp,
    String? invoiceid,
    String? deliverythruid,
  }) async {
    if (!await hasInternet) {
      alertService.hideLoading();
      alertService.errorToast('Please check your internet connection');
      return '';
    }
    if (otp == null || otp.isEmpty) {
      alertService.hideLoading();
      return ('DC Code is required');
    }

    var value = {
      "otp": otp,
      "invoiceid": invoiceid,
      "deliverythruid": deliverythruid
    };
    Map<String, dynamic> response = {"message": ""};

    response = await Connection().post(EndPoints.deliveryOtpVerify, value);

    switch (response['message']) {
      case 'Delivery update successfully':
        return 'Success';
      case 'Delivery Update failed Wrong Dccode':
        return ('Dc-Code Not Match, Please verify or resend the code');
      case 'Invoiceno not found':
        return ('Invoice no not found');
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
