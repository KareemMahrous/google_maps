import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_implementation/presentation/widget/buttons.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  static const LatLng _initialPosition = LatLng(31.23, 30.06);
  LatLng _currentPosition = _initialPosition;
  final Set<Polyline> _polylines = {};

  Timer? _debounce;

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

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _currentPosition = position.target;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
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
        body: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: _initialPosition,
                      zoom: 13.0,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                    onCameraMove: _onCameraMove,
                    polylines: _polylines,
                  ),
                  const Positioned(
                    top: 0,
                    bottom: 25,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            DefaultButton(
              onPressed: () {
                log("Current Position: ${_currentPosition.latitude}, ${_currentPosition.longitude}");
              },
              text: "Print Current Position",
            ),
          ],
        ),
      ),
    );
  }
}
