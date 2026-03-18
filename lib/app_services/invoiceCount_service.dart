import 'dart:convert';
import 'package:rfh/app_utils/alert_widget.dart';
import '../app_config/app_end_points.dart';
import '../app_storage/secure_storage.dart';
import 'connection.dart';

class InvoiceCountService {
  Future<Map<String, dynamic>?> invoiceCountService() async {
    try {
      // Get token
      String userToken = await BoxStorage().getLoginToken();
      String deliverythruid = await BoxStorage().getDeliveryThrustId();
      // Generate request body
      Map<String, dynamic> requestData = {
        'usertoken': userToken,
        "deliveryThruid": deliverythruid
      };

      // Required Header components
      final encodedToken = base64Encode(utf8.encode(userToken));
      final customHeaders = {
        'Authorization': 'Bearer $encodedToken',
      };

      // Create connection and make request
      Connection connection = Connection();
      var url = EndPoints.invoiceCount;
      var response =
          await connection.post(url, requestData, customHeaders: customHeaders);

      // Return response
      return response;
    } catch (e) {
      AlertService().errorToast('error while delivery list call $e');
      print('An error occurred delivery service: $e');
      return null;
    }
  }
}
