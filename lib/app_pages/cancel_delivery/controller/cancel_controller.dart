import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:rfh/app_storage/secure_storage.dart';
import '../../../app_config/app_end_points.dart';
import '../../../app_services/index_services.dart';
import '../../../app_utils/index_app_util.dart';

class CancelController {
  AlertService alertService = AlertService();
  Future<bool> hasInternet = InternetConnectivity().hasInternetConnection;

  //Load Drop Down
  Future<List<Map<String, dynamic>>> loadDropDown() async {
    List<Map<String, dynamic>>? dropDownValue =
        await BoxStorage().get('dropDown');
    return dropDownValue ??
        [
          {"Reason": "Null", "reasonsvalue": 0}
        ];
  }

  //Send OTP
  Future<bool> updateCancelStatus({
    required String invoiceid,
    required String driverid,
    String? status,
    String? text,
  }) async {
    if (!await hasInternet) {
      alertService.errorToast('Please check your internet connection');
      return false;
    }

    Map<String, Object?> value;
    if (status == '5') {
      value = {
        "invoiceid": (invoiceid),
        "status": int.parse(status!),
        "driverid": int.parse(driverid),
        "other": text
      };
    } else {
      value = {
        "invoiceid": (invoiceid),
        "status": int.parse(status!),
        "driverid": int.parse(driverid),
        "other": ""
      };
    }
    var response = await Connection().post(EndPoints.updateCancelStatus, value);
    if (response['message'] == 'Data Update successfully') {
      return true;
    } else if (response == null) {
      return false;
    } else {
      alertService.errorToast(response['message']);
      print('error response cancel  $response');
      return false;
    }
  }
}
