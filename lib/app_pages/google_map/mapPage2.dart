import 'package:rfh/app_utils/alert_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenMapButton {
  Future<void> openGoogleMaps({
    required double currentLat,
    required double currentLng,
    required double destinationLat,
    required double destinationLng,
  }) async {
    final Uri googleMapsUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=$currentLat,$currentLng&destination=$destinationLat,$destinationLng&travelmode=driving',
    );
    AlertService alertService = AlertService();
    try {
      if (await canLaunchUrl(googleMapsUri)) {
        await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
      } else {
        alertService.errorToast('Error launch map url');
        alertService.hideLoading();
        throw 'Could not open the map.';
      }
    } catch (e) {
      alertService.errorToast('Error :${e}');
      alertService.hideLoading();
      print('Error opening Google Maps: $e');
    } finally {
      alertService.hideLoading(); // Hide loading after the process completes
    }
  }
}
