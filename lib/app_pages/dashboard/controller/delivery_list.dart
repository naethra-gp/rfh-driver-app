import 'package:flutter/widgets.dart';
import 'package:rfh/app_utils/alert_widget.dart';
import 'package:rfh/app_utils/constants/helper_function.dart';
import '../../../app_model/delivery_list_model.dart';
import '../../../app_services/index_services.dart';
import '../../../app_storage/secure_storage.dart';
import 'loadDropDown.dart';

class DeliveryList {
  final AlertService alertService = AlertService();

  // Function to parse JSON and extract delivery details
  Future<List<DeliveryListModel>> _parseDeliveryDetails(
      Map<String, dynamic> jsonResponse) async {
    try {
      List<dynamic> deliveryDetailsJson = jsonResponse['deliveryDetails'];
      return deliveryDetailsJson
          .map((json) => DeliveryListModel.fromJson(json))
          .toList();
    } catch (e) {
      // alertService.errorToast('Failed to parse delivery details');
      return []; // or throw an error if necessary
    }
  }

  // Function to get all delivery details
  Future<List<DeliveryListModel>> getAllDeliveryList(
      BuildContext context) async {
    DeliveryListService deliveryListService = DeliveryListService();

    var response = await deliveryListService.deliveryListService();
    //Load cancel drop down values from the api for cancel reason screen
    var dropdown = await LoadCancelDropDown().loadDropDown();
    await BoxStorage().save('dropDown', dropdown);

    if (response != null) {
      switch (response['message']) {
        case 'Success':
          var deliveryDetails = await _parseDeliveryDetails(response);
          return deliveryDetails;
        case 'No data found':
          return [];
        case 'Token Invalid':
          alertService.toast('Token Expired. Please login again');
          RHelperFunction.navigateToLoginPage(context);
          return [];
        default:
          alertService.hideLoading();
          alertService.errorToast('Response Message -Failed');
          RHelperFunction.navigateToLoginPage(context);
          return [];
      }
    } else {
      alertService.hideLoading();
      RHelperFunction.navigateToLoginPage(context);
      return [];
    }
  }
}
