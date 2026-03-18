import 'dart:convert';
import 'package:rfh/app_utils/alert_widget.dart';
import '../app_config/app_end_points.dart';
import '../app_storage/secure_storage.dart';
import 'connection.dart';

class DeliveryListService {
  Future<Map<String, dynamic>?> deliveryListService() async {
    try {
      // Get token
      String userToken = await BoxStorage().getLoginToken();

      // Generate request body
      Map<String, dynamic> requestData = {
        'usertoken': userToken,
      };

      // Required Header components
      final encodedToken = base64Encode(utf8.encode(userToken));
      final customHeaders = {
        'Authorization': 'Bearer $encodedToken',
      };

      // Create connection and make request
      Connection connection = Connection();
      var url = EndPoints.deliveryList;
      var response =
          await connection.post(url, requestData, customHeaders: customHeaders);
      // print('delivery list response ${response}');
      // Return response
      return response;
    } catch (e) {
      AlertService().errorToast('error while delivery list call $e');
      print('An error occurred delivery service: $e');
      return null;
    }
  }
}
