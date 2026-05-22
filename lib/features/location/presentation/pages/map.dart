import 'dart:async';
import 'dart:typed_data';

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttershop/constants/images_constans.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mp;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  mp.MapboxMap? mapboxMapController;
  StreamSubscription? userPositionSubscription;
  mp.PointAnnotationManager? pointAnnotationManager;

  @override
  void initState() {
    super.initState();
    // _setupPositionTracking();
  }

  @override
  void dispose() {
    userPositionSubscription?.cancel();
    super.dispose();
  }

  LocationUIState locationState = LocationUIState.loading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          mp.MapWidget(
            onMapCreated: _onMapCreated,
            styleUri: mp.MapboxStyles.MAPBOX_STREETS,
            onTapListener: _onMapTapped,
            onStyleLoadedListener: _onStyleLoaded,
          ),
          _buildLocationOverlay(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "move_camera_btn",
            onPressed: () {
              mapboxMapController?.setCamera(
                mp.CameraOptions(
                  center: mp.Point(
                    coordinates: mp.Position(
                      35.954779459570794, // Longitude
                      31.967994413975198, // Latitude
                    ),
                  ),
                  zoom: 16.0,
                ),
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.location_searching, color: Colors.white),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "credit_card_btn",
            onPressed: () {
              Navigator.pushNamed(context, '/credit');
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.credit_card, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Future<void> _onStyleLoaded(mp.StyleLoadedEventData data) async {
    await _addCustomMarkerImage();
    _setupPositionTracking();
  }

  Widget _buildLocationOverlay() {
    switch (locationState) {
      case LocationUIState.denied:
        return _PermissionMessage(
          text: 'Location permission denied',
          actionText: 'Try again',
          onPressed: _setupPositionTracking,
        );

      case LocationUIState.deniedForever:
        return _PermissionMessage(
          text: 'Location permission permanently denied',
          actionText: 'Go to settings',
          onPressed: gl.Geolocator.openAppSettings,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _onMapCreated(mp.MapboxMap controller) async {
    mapboxMapController = controller;

    mapboxMapController?.location.updateSettings(
      mp.LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        pulsingColor: const Color.fromARGB(255, 252, 119, 221).value,
      ),
    );
    pointAnnotationManager = await mapboxMapController!.annotations
        .createPointAnnotationManager();
  }

  void _onMapTapped(mp.MapContentGestureContext context) {
    debugPrint(
      "Map tapped at: ${context.point.coordinates.lat}, ${context.point.coordinates.lng}",
    );
    pointAnnotationManager?.deleteAll();
    pointAnnotationManager?.create(
      mp.PointAnnotationOptions(
        geometry: context.point,
        iconImage: "custom-pin",
        iconSize: 1.5,
        iconAnchor: mp.IconAnchor.BOTTOM,
      ),
    );
  }

  Future<void> _setupPositionTracking() async {
    bool serviceEnabled;
    gl.LocationPermission permission;
    serviceEnabled = await gl.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        locationState = LocationUIState.denied;
      });
      return;
    }
    permission = await gl.Geolocator.checkPermission();
    if (permission == gl.LocationPermission.denied) {
      permission = await gl.Geolocator.requestPermission();
      if (permission == gl.LocationPermission.denied) {
        setState(() {
          locationState = LocationUIState.denied;
        });
        return;
      }
    }
    if (permission == gl.LocationPermission.deniedForever) {
      setState(() {
        locationState = LocationUIState.deniedForever;
      });
      return;
    }
    // just a ui
    setState(() {
      locationState = LocationUIState.granted;
    });

    gl.LocationSettings locationSettings = gl.LocationSettings(
      accuracy: gl.LocationAccuracy.best,
      distanceFilter: 100,
    );

    // Get current position immediately and move camera
    try {
      final position = await gl.Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
      if (mapboxMapController != null) {
        final point = mp.Point(
          coordinates: mp.Position(position.longitude, position.latitude),
        );
        mapboxMapController!.setCamera(
          mp.CameraOptions(center: point, zoom: 15.0),
        );
        pointAnnotationManager?.deleteAll();
        pointAnnotationManager?.create(
          mp.PointAnnotationOptions(
            geometry: point,
            iconImage: "custom-pin",
            iconSize: 1.5,
            iconAnchor: mp.IconAnchor.BOTTOM,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error getting current location: $e");
    }
    userPositionSubscription?.pause();
    userPositionSubscription?.cancel();
    userPositionSubscription =
        gl.Geolocator.getPositionStream(
          locationSettings: locationSettings,
        ).listen((gl.Position position) {
          if (mapboxMapController != null) {
            mapboxMapController!.setCamera(
              mp.CameraOptions(
                center: mp.Point(
                  coordinates: mp.Position(
                    position.longitude,
                    position.latitude,
                  ),
                ),
                zoom: 15.0,
              ),
            );
          }
        });
  }

  Future<void> _addCustomMarkerImage() async {
    try {
      final ByteData bytes = await rootBundle.load(ImagesConstans.pinmap);
      final Uint8List list = bytes.buffer.asUint8List();
      final ui.Codec codec = await ui.instantiateImageCodec(list);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ByteData? byteData = await frameInfo.image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );

      if (byteData != null) {
        final Uint8List rawBytes = byteData.buffer.asUint8List();
        await mapboxMapController?.style.addStyleImage(
          "custom-pin",
          2.0,
          mp.MbxImage(
            width: frameInfo.image.width,
            height: frameInfo.image.height,
            data: rawBytes,
          ),
          false,
          [],
          [],
          null,
        );
      }
    } catch (e) {
      debugPrint("Error adding custom marker image: $e");
    }
  }
}

class _PermissionMessage extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onPressed;

  const _PermissionMessage({
    required this.text,
    required this.actionText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.9),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_disabled, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            text,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onPressed, child: Text(actionText)),
        ],
      ),
    );
  }
}

enum LocationUIState { loading, granted, denied, deniedForever }
