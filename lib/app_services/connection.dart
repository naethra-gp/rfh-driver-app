import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import '../app_utils/index_app_util.dart';

class Connection {
  final alertService = AlertService();

  Future<dynamic> post(String url, Map<String, dynamic>? body,
      {Map<String, String>? customHeaders}) async {
    bool hasInternet = await InternetConnectivity().hasInternetConnection;
    if (hasInternet) {
      try {
        // Default headers
        final headers = {
          'Content-Type': 'application/json',
        };

        // Add custom headers if provided
        if (customHeaders != null) {
          headers.addAll(customHeaders);
        }

        /// API CALLS
        final response = await http.post(
          Uri.parse(url),
          body: jsonEncode(body),
          headers: headers,
          encoding: Encoding.getByName('utf-8'),
        );

        /// ERROR HANDLING
        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          alertService.hideLoading();
          if (response.statusCode == 500) {
            alertService
                .errorToast('${response.statusCode} -Internal server error');
            return null;
          } else {
            alertService.errorToast('HTTP Error: ${response.statusCode}');
            print(
                'HTTP Error ${response.statusCode} from connection.dart: $response');
            return null; // Return null or handle the error response as needed
          }
        }
      } catch (e) {
        alertService.hideLoading();
        alertService.errorToast('Error: ${e.toString()}');
        print("Error from connection.dart: ${e.toString()}");
        return null; // Return null or handle the error response as needed
      }
    } else {
      alertService.errorToast('Please check your internet connection..');
    }
  }
}
