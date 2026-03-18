import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import '../../app_pages/google_map/mapPage2.dart';
import '../index_app_util.dart';
import 'package:location/location.dart' as Location2;

class RHelperFunction {
  //check dark mode
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

//Navigate to login
  static navigateToLoginPage(context) {
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }

//Convert address to coordinates and navigate to MapPage
  AlertService alertService = AlertService();

  Future<Map<String, String>> getLocation(String address) async {
    try {
      List locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return {
          'latitude': locations.first.latitude.toString(),
          'longitude': locations.first.longitude.toString(),
        };
      } else {
        return {'error': 'No locations found'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  void handleLocation(context, address) async {
    // print('in-app map called');
    bool hasInternet = await InternetConnectivity().hasInternetConnection;
    if (hasInternet) {
      Map<String, String>? deliveryCoordinate = await getLocation(address);
      if (!deliveryCoordinate.containsKey('error')) {
        Navigator.pushNamed(context, 'mapPage', arguments: deliveryCoordinate);
      } else {
        alertService.errorToast(
            "The coordinate for the given address is not found $deliveryCoordinate");
      }
    } else {
      alertService.errorToast('Please check your internet connection..');
    }
  }

  void handleLocation2(BuildContext context, String address) async {
    bool hasInternet = await InternetConnectivity().hasInternetConnection;

    if (hasInternet) {
      // Fetch the destination location
      Map<String, String>? deliveryCoordinate = await getLocation(address);

      if (!deliveryCoordinate.containsKey('error')) {
        double destinationLat = double.parse(deliveryCoordinate['latitude']!);
        double destinationLng = double.parse(deliveryCoordinate['longitude']!);

        // Fetch the current location
        Location2.Location location = Location2.Location();
        bool serviceEnabled = await location.serviceEnabled();
        if (!serviceEnabled) {
          serviceEnabled = await location.requestService();
          if (!serviceEnabled) {
            alertService.errorToast('Location services are disabled.');
            return;
          }
        }

        Location2.PermissionStatus permissionGranted =
            await location.hasPermission();
        if (permissionGranted == Location2.PermissionStatus.denied) {
          permissionGranted = await location.requestPermission();
          if (permissionGranted != Location2.PermissionStatus.granted) {
            alertService.errorToast('Location permissions are denied.');
            return;
          }
        }

        Location2.LocationData currentLocation = await location.getLocation();

        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          double currentLat = currentLocation.latitude!;
          double currentLng = currentLocation.longitude!;

          // Open Google Maps with both current and destination locations
          OpenMapButton().openGoogleMaps(
              currentLat: currentLat,
              currentLng: currentLng,
              destinationLat: destinationLat,
              destinationLng: destinationLng);
        } else {
          alertService.errorToast('Unable to fetch current location.');
        }
      } else {
        alertService.errorToast(
          "The coordinate for the given address is not found $deliveryCoordinate",
        );
      }
    } else {
      alertService.errorToast('Please check your internet connection.');
    }
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    } else {
      return true;
    }
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(), // Converts input to uppercase
      selection: newValue.selection,
    );
  }
}
