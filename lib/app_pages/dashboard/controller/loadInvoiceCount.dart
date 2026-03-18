// Function to get all delivery details
import 'package:flutter/material.dart';
import 'package:rfh/app_services/invoiceCount_service.dart';

import '../../../app_utils/index_app_util.dart';

class InvoiceCount {
  Future getInvoiceCount(BuildContext context) async {
    InvoiceCountService invoiceCountService = InvoiceCountService();
    AlertService alertService = AlertService();
    var response = await invoiceCountService.invoiceCountService();
    if (response != null) {
      switch (response['message']) {
        case 'Success':
          return response['InvoiceCountdtls'];
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
