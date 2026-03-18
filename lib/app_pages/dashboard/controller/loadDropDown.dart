import 'dart:convert';

import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:http/http.dart' as http;
import '../../../app_config/app_end_points.dart';
import '../../../app_utils/index_app_util.dart';

class LoadCancelDropDown {
  AlertService alertService = AlertService();
  Future<bool> hasInternet = InternetConnectivity().hasInternetConnection;

  //Load Drop Down
  Future<List<Map<String, dynamic>>> loadDropDown() async {
    if (!await hasInternet) {
      alertService.errorToast('Please check your internet connection');
      return [];
    }

    try {
      const url = EndPoints.cancelReason;
      final headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Extracting the list of reasons from the "cancel" key
        List<Map<String, dynamic>> reasonsList =
            List<Map<String, dynamic>>.from(data['cancel']);
        alertService.hideLoading();
        return reasonsList;
      } else {
        alertService.hideLoading();
        alertService.errorToast('HTTP Error: ${response.statusCode}');
        print(
            'HTTP Error ${response.statusCode} from cancel_controller.dart: $response');
        return []; // Return an empty list in case of error
      }
    } catch (e) {
      alertService.hideLoading();
      alertService.errorToast('Error: ${e.toString()}');
      print("Error from connection.dart: ${e.toString()}");
      return []; // Return an empty list in case of error
    }
  }
}
