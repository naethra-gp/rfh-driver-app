import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:location/location.dart';
import 'package:rfh/app_config/app_end_points.dart';
import '../../app_utils/index_app_util.dart';

class MapPage extends StatefulWidget {
  final Map<String, String>? deliveryCoordinate;

  const MapPage({super.key, required this.deliveryCoordinate});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  final Location _locationController = Location();
  LatLng? destination;
  LatLng? _currentPosition;
  Map<PolylineId, Polyline> polylines = {};

  bool _isMapMoving = false;
  bool _shouldAutoCenter = true;
  double _currentZoom = 10.5;
  BitmapDescriptor? _carIcon;
  StreamSubscription<LocationData>? _locationSubscription;

  String _duration = '';
  String _distance = '';

  @override
  void initState() {
    super.initState();
    _loadCarIcon();
    if (widget.deliveryCoordinate != null) {
      double lat = double.parse(widget.deliveryCoordinate!['latitude']!);
      double lng = double.parse(widget.deliveryCoordinate!['longitude']!);
      destination = LatLng(lat, lng);
    } else {
      print('Error: deliveryCoordinate is null');
    }

    _startLocationUpdates();
    _fetchDistanceAndTime(); // Fetch distance and time
  }

  Future<void> _loadCarIcon() async {
    ByteData data = await rootBundle.load(RImages.mapCurrentLocationLogo);
    List<int> bytes = data.buffer.asUint8List();
    img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    img.Image resizedImage =
        img.copyResize(image, width: 150, height: 150); // Resize the image
    Uint8List resizedBytes = Uint8List.fromList(img.encodePng(resizedImage));
    final BitmapDescriptor carIcon = BitmapDescriptor.fromBytes(resizedBytes);

    setState(() {
      _carIcon = carIcon;
    });
  }

  Future<void> _fetchDistanceAndTime() async {
    if (_currentPosition != null && destination != null) {
      try {
        const apiKey = EndPoints.Google_Map_Api2; // Replace with your API key
        final result =
            await getDistanceAndTime(_currentPosition!, destination!, apiKey);
        setState(() {
          _distance = result['distance'];
          _duration = result['duration'];
        });
      } catch (e) {
        print('Error fetching distance and time: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _currentPosition == null || destination == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: _currentZoom,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('Current Location'),
                      position: _currentPosition!,
                      icon: _carIcon!,
                    ),
                    Marker(
                      markerId: const MarkerId('Destination'),
                      position: destination!,
                      icon: BitmapDescriptor.defaultMarker,
                    ),
                  },
                  polylines: Set<Polyline>.of(polylines.values),
                  onCameraMoveStarted: () {
                    setState(() {
                      _isMapMoving = true;
                      _shouldAutoCenter = false;
                    });
                  },
                  onCameraMove: (CameraPosition position) {
                    _currentZoom = position.zoom;
                  },
                  onCameraIdle: () {
                    setState(() {
                      _isMapMoving = false;
                    });
                  },
                  myLocationButtonEnabled: false,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                ),
          // Custom buttons (back and refresh)
          Positioned(
            top: 40.0,
            left: 10.0,
            child: IconButton(
              icon: const CircleAvatar(
                backgroundColor: RColors.grey,
                child: Icon(
                  Icons.arrow_back,
                  size: RSizes.iconLg,
                  color: RColors.primary,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            top: 40.0,
            right: 10.0,
            child: IconButton(
              icon: const CircleAvatar(
                backgroundColor: RColors.grey,
                child: Icon(
                  Icons.refresh,
                  size: RSizes.iconLg,
                  color: RColors.primary,
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(
                      deliveryCoordinate: widget.deliveryCoordinate,
                    ),
                  ),
                );
              },
            ),
          ),
          // Display distance and duration at the bottom
          Positioned(
            bottom: 2.0,
            left: 2.0,
            right: 2.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                      12.0), // Inner padding of the container
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Space between elements
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Distance',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    color: RColors.black), // Styling text
                          ),
                          Text(
                            _distance,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    color: RColors.black), // Styling text
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Duration',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    color: RColors.black), // Styling text
                          ),
                          Text(
                            _duration,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    color: RColors.black), // Styling text
                          ),
                        ],
                      ),
                      IconButton.filled(
                        icon: const Icon(Icons.person_pin_circle_sharp),
                        onPressed: () {
                          _cameraToPosition(_currentPosition!, _currentZoom);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos, double zoom) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: zoom, // Use passed zoom level
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
  }

  void _startLocationUpdates() {
    _locationSubscription = _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          if (_currentPosition != null) {
            _updatePolyline();
            if (_shouldAutoCenter && !_isMapMoving) {
              _cameraToPosition(
                  _currentPosition!, _currentZoom); // Pass current zoom level
            }
            _fetchDistanceAndTime();
          }
        });
      }
    });
  }

  Future<void> _updatePolyline() async {
    if (_currentPosition == null || destination == null) return;

    List<LatLng> polylineCoordinates = await getPolylinePoints();
    generatePolyLineFromPoints(polylineCoordinates);
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        EndPoints.Google_Map_Api2,
        PointLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        PointLatLng(destination!.latitude, destination!.longitude),
        travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      } else {
        print('Error from polyline: ${result.errorMessage}');
      }
    } catch (e) {
      print('Error fetching polyline points: $e');
    }

    return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: const Color.fromARGB(255, 23, 53, 78),
      points: polylineCoordinates,
      width: 4,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  Future<Map<String, dynamic>> getDistanceAndTime(
      LatLng origin, LatLng destination, String apiKey) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final routes = data['routes'] as List;
      if (routes.isNotEmpty) {
        final duration = routes[0]['legs'][0]['duration']['text'];
        final distance = routes[0]['legs'][0]['distance']['text'];
        return {
          'duration': duration,
          'distance': distance,
        };
      } else {
        throw Exception('No route found');
      }
    } else {
      throw Exception('Failed to fetch directions');
    }
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
}
