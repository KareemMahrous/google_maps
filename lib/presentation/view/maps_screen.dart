import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  static const LatLng _initialPosition = LatLng(31.23, 30.06);
  LatLng _currentPosition = _initialPosition;
  LatLng? _startPoint;
  LatLng? _endPoint;
  final Set<Polyline> _polylines = {};

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied.';
        }
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _mapController
              .animateCamera(CameraUpdate.newLatLng(_currentPosition));
        });
      } else {
        throw 'Location permissions are denied.';
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  // Future<void> _getDirections(LatLng start, LatLng end) async {
  //   final String url =
  //       'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$_googleApiKey';
  //   final response = await getIt<BaseDio>().get(url);
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = response.data;
  //     final String encodedPolyline =
  //         data['routes'][0]['overview_polyline']['points'];
  //     final List<PointLatLng> polylinePoints = _decodePolyline(encodedPolyline);
  //     setState(() {
  //       _polylines.add(Polyline(
  //         polylineId: const PolylineId('route'),
  //         points: polylinePoints
  //             .map((point) => LatLng(point.latitude, point.longitude))
  //             .toList(),
  //         color: Colors.blue,
  //         width: 5,
  //       ));
  //     });
  //   } else {
  //     throw Exception('Failed to load directions');
  //   }
  // }

  // List<PointLatLng> _decodePolyline(String encoded) {
  //   List<PointLatLng> polyline = [];
  //   int index = 0, len = encoded.length;
  //   int lat = 0, lng = 0;

  //   while (index < len) {
  //     int b, shift = 0, result = 0;
  //     do {
  //       b = encoded.codeUnitAt(index++) - 63;
  //       result |= (b & 0x1F) << shift;
  //       shift += 5;
  //     } while (b >= 0x20);
  //     int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
  //     lat += dlat;

  //     shift = 0;
  //     result = 0;
  //     do {
  //       b = encoded.codeUnitAt(index++) - 63;
  //       result |= (b & 0x1F) << shift;
  //       shift += 5;
  //     } while (b >= 0x20);
  //     int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
  //     lng += dlng;

  //     polyline.add(PointLatLng(lat / 1E5, lng / 1E5));
  //   }
  //   return polyline;
  // }

  // void _onMapTapped(LatLng position) {
  //   setState(() {
  //     if (_startPoint == null || (_startPoint != null && _endPoint != null)) {
  //       _startPoint = position;
  //       _endPoint = null;
  //       _polylines.clear();
  //     } else {
  //       _endPoint = position;
  //       _getDirections(_startPoint!, _endPoint!);
  //     }
  //   });
  //   _mapController.animateCamera(CameraUpdate.newLatLng(position));
  // }
  void _onMapTapped(LatLng position) {
    setState(() {
      if (_startPoint == null || (_startPoint != null && _endPoint != null)) {
        _startPoint = position;
        _endPoint = null;
        _polylines.clear();
      } else {
        _endPoint = position;
        _polylines.add(Polyline(
          polylineId: const PolylineId('route'),
          points: [_startPoint!, _endPoint!],
          color: Colors.blue,
          width: 5,
        ));
      }
    });
    _mapController.animateCamera(CameraUpdate.newLatLng(position));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Maps Example'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _getCurrentLocation,
          child: const Icon(Icons.my_location),
        ),
        body: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: _initialPosition,
            zoom: 13.0,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          onTap: _onMapTapped,
          markers: {
            if (_startPoint != null)
              Marker(
                markerId: const MarkerId('startPoint'),
                position: _startPoint!,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              ),
            if (_endPoint != null)
              Marker(
                markerId: const MarkerId('endPoint'),
                position: _endPoint!,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
              ),
          },
          polylines: _polylines,
        ),
      ),
    );
  }
}
