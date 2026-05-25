// ignore_for_file: use_super_parameters

import 'dart:async';

import 'package:doan_clean_achitec/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key}) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  MapType currentMapType = MapType.normal;
  LatLng destination = const LatLng(16.0544, 108.2022);
  LatLng? currentLocation;
  String destinationName = 'Location';
  String tourName = '';
  String locationText = '';
  bool isLoadingLocation = true;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  BitmapDescriptor? currentMarkerIcon;
  BitmapDescriptor? destinationMarkerIcon;

  @override
  void initState() {
    super.initState();
    _readArguments();
    _loadMarkerIcons();
    _prepareMap();
  }

  void _readArguments() {
    final args = Get.arguments;

    if (args is Map) {
      final lat = _readDouble(args['destinationLat']);
      final lng = _readDouble(args['destinationLng']);

      destination = LatLng(
        lat ?? destination.latitude,
        lng ?? destination.longitude,
      );
      destinationName =
          (args['destinationName'] ?? args['locationText'] ?? 'Location')
              .toString();
      tourName = (args['tourName'] ?? '').toString();
      locationText = (args['locationText'] ?? destinationName).toString();
    } else if (args is String && args.trim().isNotEmpty) {
      locationText = args.trim();
      destinationName = locationText;
      destination = _fallbackLatLng(locationText);
    }

    debugPrint(
      '[MAP] destination: $destinationName '
      '(${destination.latitude}, ${destination.longitude}), '
      'tour=$tourName, locationText=$locationText',
    );
  }

  double? _readDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Future<void> _prepareMap() async {
    _setDestinationMarker();

    final hasPermission = await _requestLocationPermission();
    if (!mounted) return;

    if (!hasPermission) {
      debugPrint(
        '[MAP] route status: location permission denied, '
        'show destination only',
      );
      Get.snackbar(
        StringConst.notification.tr,
        'Không có quyền vị trí nên chưa thể hiển thị đường đi từ vị trí hiện tại.',
      );
      setState(() => isLoadingLocation = false);
      await _animateToDestination();
      return;
    }

    final serviceEnabled =
        await geolocator.Geolocator.isLocationServiceEnabled();
    debugPrint('[MAP] location service enabled: $serviceEnabled');

    if (!serviceEnabled) {
      if (!mounted) return;
      Get.snackbar(
        StringConst.notification.tr,
        'Vui lòng bật dịch vụ vị trí để hiển thị đường đi.',
      );
      setState(() => isLoadingLocation = false);
      await _animateToDestination();
      return;
    }

    try {
      final position = await geolocator.Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.best,
      );

      currentLocation = LatLng(position.latitude, position.longitude);
      debugPrint(
        '[MAP] current location: '
        '${currentLocation!.latitude}, ${currentLocation!.longitude}',
      );

      _setCurrentLocationMarker();
      _drawFallbackRoute();

      if (mounted) {
        setState(() => isLoadingLocation = false);
      }

      await _fitCameraToMarkers();
    } catch (e, stackTrace) {
      debugPrint('[MAP][ERROR] get current location failed: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;
      Get.snackbar(
        StringConst.error.tr,
        'Không lấy được vị trí hiện tại. App vẫn hiển thị địa điểm tour.',
      );
      setState(() => isLoadingLocation = false);
      await _animateToDestination();
    }
  }

  Future<bool> _requestLocationPermission() async {
    final current = await Permission.location.status;
    debugPrint('[MAP] permission before request: $current');

    final status =
        current.isGranted ? current : await Permission.location.request();
    debugPrint('[MAP] permission after request: $status');

    return status.isGranted;
  }

  void _setDestinationMarker() {
    markers.removeWhere((marker) => marker.markerId.value == 'destination');
    markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        icon: destinationMarkerIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: destination,
        infoWindow: InfoWindow(
          title: destinationName.isNotEmpty ? destinationName : 'Tour location',
          snippet: tourName,
        ),
      ),
    );

    if (mounted) setState(() {});
  }

  void _setCurrentLocationMarker() {
    final current = currentLocation;
    if (current == null) return;

    markers.removeWhere((marker) => marker.markerId.value == 'current_user');
    markers.add(
      Marker(
        markerId: const MarkerId('current_user'),
        icon: currentMarkerIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: current,
        infoWindow: const InfoWindow(title: 'Vị trí của bạn'),
      ),
    );
  }

  void _drawFallbackRoute() {
    final current = currentLocation;
    if (current == null) return;

    debugPrint(
      '[MAP] route status: Directions API not requested, '
      'using straight fallback polyline',
    );

    polylines = {
      Polyline(
        polylineId: const PolylineId('fallback_route'),
        color: Colors.blue,
        width: 5,
        points: [current, destination],
      ),
    };
  }

  Future<void> _animateToDestination() async {
    if (!mapController.isCompleted) return;

    final controller = await mapController.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: destination, zoom: 13),
      ),
    );
  }

  Future<void> _fitCameraToMarkers() async {
    if (!mapController.isCompleted) return;

    final current = currentLocation;
    if (current == null) {
      await _animateToDestination();
      return;
    }

    final controller = await mapController.future;
    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            _min(current.latitude, destination.latitude),
            _min(current.longitude, destination.longitude),
          ),
          northeast: LatLng(
            _max(current.latitude, destination.latitude),
            _max(current.longitude, destination.longitude),
          ),
        ),
        80,
      ),
    );
  }

  double _min(double a, double b) => a < b ? a : b;
  double _max(double a, double b) => a > b ? a : b;

  Future<void> _loadMarkerIcons() async {
    try {
      final customCurrentMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(12, 12)),
        'assets/icons/ic_current_marker.png',
      );

      final customDestinationMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(12, 12)),
        'assets/icons/ic_marker_map.png',
      );

      if (!mounted) return;
      setState(() {
        currentMarkerIcon = customCurrentMarker;
        destinationMarkerIcon = customDestinationMarker;
      });

      _setDestinationMarker();
      _setCurrentLocationMarker();
    } catch (e) {
      debugPrint('[MAP][ERROR] load marker icon failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) async {
              if (!mapController.isCompleted) {
                mapController.complete(controller);
              }
              await _animateToDestination();
            },
            initialCameraPosition: CameraPosition(
              target: destination,
              zoom: 12,
            ),
            markers: markers,
            polylines: polylines,
            mapType: currentMapType,
            myLocationEnabled: currentLocation != null,
            myLocationButtonEnabled: currentLocation != null,
          ),
          Positioned(
            left: getSize(16),
            right: getSize(96),
            bottom: getSize(24),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.88),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getSize(12),
                  vertical: getSize(8),
                ),
                child: Text(
                  '$destinationName '
                  '(${destination.latitude.toStringAsFixed(4)}, '
                  '${destination.longitude.toStringAsFixed(4)})',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          if (isLoadingLocation)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Container(
            padding: EdgeInsets.only(
              top: getSize(36),
              right: getSize(24),
            ),
            alignment: Alignment.topRight,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "btn1",
                  backgroundColor: ColorConstants.green,
                  onPressed: () => _changeMapType(MapType.hybrid),
                  child: const Icon(
                    Icons.map,
                    size: 20,
                    color: ColorConstants.white,
                  ),
                ),
                SizedBox(height: getSize(12)),
                FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: () => _changeMapType(MapType.satellite),
                  child: const Icon(
                    Icons.maps_ugc,
                    size: 20,
                    color: ColorConstants.white,
                  ),
                ),
                SizedBox(height: getSize(12)),
                FloatingActionButton(
                  heroTag: "btn3",
                  backgroundColor: ColorConstants.secondColor,
                  onPressed: () => _changeMapType(MapType.terrain),
                  child: const Icon(
                    Icons.maps_home_work,
                    size: 20,
                    color: ColorConstants.white,
                  ),
                ),
                SizedBox(height: getSize(12)),
                FloatingActionButton(
                  heroTag: "btn4",
                  backgroundColor: ColorConstants.flights,
                  onPressed: () => _changeMapType(MapType.normal),
                  child: const Icon(
                    Icons.home,
                    size: 20,
                    color: ColorConstants.white,
                  ),
                ),
                SizedBox(height: getSize(64)),
                _roundButton(
                  onTap: _prepareMap,
                  child: Image.asset(
                    'assets/icons/ic_current_location.png',
                    color: ColorConstants.primaryButton,
                    height: getSize(32),
                    width: getSize(32),
                  ),
                ),
                SizedBox(height: getSize(12)),
                _roundButton(
                  onTap: _fitCameraToMarkers,
                  child: Icon(
                    Icons.arrow_right_alt,
                    size: getSize(32),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _roundButton({
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ColorConstants.accent2.withOpacity(.2),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: ColorConstants.darkGray,
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: 24,
          backgroundColor: ColorConstants.white,
          child: child,
        ),
      ),
    );
  }

  void _changeMapType(MapType mapType) {
    setState(() => currentMapType = mapType);
  }

  LatLng _fallbackLatLng(String value) {
    final text = value.trim().toLowerCase();
    if (text.contains('đà lạt')) return const LatLng(11.9404, 108.4583);
    if (text.contains('đà nẵng')) return const LatLng(16.0544, 108.2022);
    if (text.contains('hà nội')) return const LatLng(21.0278, 105.8342);
    if (text.contains('hồ chí minh') || text.contains('tp.hcm')) {
      return const LatLng(10.7769, 106.7009);
    }
    if (text.contains('phú quốc')) return const LatLng(10.2899, 103.9840);
    if (text.contains('nha trang')) return const LatLng(12.2388, 109.1967);
    if (text.contains('hội an')) return const LatLng(15.8801, 108.3380);
    if (text.contains('huế')) return const LatLng(16.4637, 107.5909);
    if (text.contains('sapa') || text.contains('sa pa')) {
      return const LatLng(22.3364, 103.8438);
    }
    return const LatLng(16.0544, 108.2022);
  }
}
