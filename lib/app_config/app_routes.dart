import 'package:flutter/material.dart';
import 'package:rfh/app_pages/users/forgotPassword/otp_verification.dart';
import '../app_model/delivery_list_model.dart';
import '../app_pages/index.dart';

class AppRoute {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) {
      switch (settings.name) {
        case "splash":
          return const SplashScreen();
        case "login":
          return const LoginPage();
        case "forgotPassword":
          return const ForgotPassword();
        case "otpVerification":
          final Map<String, String> value =
              settings.arguments as Map<String, String>;
          return OtpVerification(
            value: value,
          );
        case "deliveryDashboard":
          return const DeliveryDashboard();
        case "invoiceView":
          // Extract invoiceNo from settings arguments
          final DeliveryListModel item =
              settings.arguments as DeliveryListModel;
          return InvoiceView(item: item);

        case "cancelDelivery":
          final Map<String, String> value =
              settings.arguments as Map<String, String>;
          // Pass invoiceNo to InvoiceView
          return CancelDelivery(
            value: value,
          );
        case "sentOtp":
          final Map<String, String> value =
              settings.arguments as Map<String, String>;
          return SentOtp(
            value: value,
          );

        case "successOtp":
          return const SuccessOtp();
        case "mapPage":
          final Map<String, String>? deliveryCoordinate =
              settings.arguments as Map<String, String>?;
          return MapPage(deliveryCoordinate: deliveryCoordinate);
      }
      return const LoginPage();
    });
  }
}
