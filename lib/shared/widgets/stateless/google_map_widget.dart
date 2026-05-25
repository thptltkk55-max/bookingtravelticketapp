import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({
    Key? key,
    this.location,
    this.idCity,
    this.onDirectionsTap,
  }) : super(key: key);

  final String? location;
  final String? idCity;
  final VoidCallback? onDirectionsTap;

  @override
  Widget build(BuildContext context) {
    final target = resolveLatLng(idCity: idCity, location: location);
    final title = location?.trim().isNotEmpty == true
        ? location!.trim()
        : 'Tour location';

    debugPrint(
      '[LOCATION] Embedded GoogleMap preview: '
      'idCity=$idCity, location=$location, '
      'lat=${target.latitude}, lng=${target.longitude}',
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 175,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _MapPreviewPainter(),
              ),
            ),
            Positioned.fill(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: target,
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('tour_destination'),
                    position: target,
                    infoWindow: InfoWindow(title: title),
                  ),
                },
                mapType: MapType.normal,
                zoomControlsEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                rotateGesturesEnabled: true,
                tiltGesturesEnabled: true,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                },
                onMapCreated: (_) {
                  debugPrint(
                    '[LOCATION] Embedded GoogleMap created: '
                    'lat=${target.latitude}, lng=${target.longitude}',
                  );
                },
              ),
            ),
            Positioned(
              left: 10,
              right: 96,
              bottom: 10,
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.92),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.10),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Material(
                color: Colors.white.withOpacity(.94),
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: onDirectionsTap,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    child: Text(
                      'Chỉ đường',
                      style: TextStyle(
                        color: Color(0xff1a73e8),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static LatLng resolveLatLng({String? idCity, String? location}) {
    final cityId = idCity?.trim().toLowerCase() ?? '';
    final text = location?.trim().toLowerCase() ?? '';

    if (cityId == 'city_01' || text.contains('đà lạt')) {
      return const LatLng(11.9404, 108.4583);
    }
    if (cityId == 'city_02' || text.contains('đà nẵng')) {
      return const LatLng(16.0544, 108.2022);
    }
    if (cityId == 'city_03' || text.contains('nha trang')) {
      return const LatLng(12.2388, 109.1967);
    }
    if (cityId == 'city_04' || text.contains('phú quốc')) {
      return const LatLng(10.2899, 103.9840);
    }
    if (cityId == 'city_05' || text.contains('hội an')) {
      return const LatLng(15.8801, 108.3380);
    }
    if (cityId == 'city_06' || text.contains('hà nội')) {
      return const LatLng(21.0278, 105.8342);
    }
    if (cityId == 'city_07' || text.contains('huế')) {
      return const LatLng(16.4637, 107.5909);
    }
    if (cityId == 'city_08' ||
        text.contains('sapa') ||
        text.contains('sa pa')) {
      return const LatLng(22.3364, 103.8438);
    }
    if (text.contains('hồ chí minh') || text.contains('tp.hcm')) {
      return const LatLng(10.7769, 106.7009);
    }

    return const LatLng(16.0544, 108.2022);
  }
}

class _MapPreviewPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final landPaint = Paint()..color = const Color(0xffdfeadf);
    final parkPaint = Paint()..color = const Color(0xffc8e2c8);
    final waterPaint = Paint()..color = const Color(0xffc9e6f5);
    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(.88)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final mainRoadPaint = Paint()
      ..color = const Color(0xfffff1b8)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final smallRoadPaint = Paint()
      ..color = Colors.white.withOpacity(.70)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawRect(Offset.zero & size, landPaint);

    final waterPath = Path()
      ..moveTo(size.width * .62, 0)
      ..cubicTo(
        size.width * .78,
        size.height * .18,
        size.width * .70,
        size.height * .48,
        size.width,
        size.height * .62,
      )
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(waterPath, waterPaint);

    canvas.drawOval(
      Rect.fromLTWH(
        -size.width * .10,
        size.height * .10,
        size.width * .42,
        size.height * .45,
      ),
      parkPaint,
    );
    canvas.drawOval(
      Rect.fromLTWH(
        size.width * .58,
        size.height * .62,
        size.width * .36,
        size.height * .34,
      ),
      parkPaint,
    );

    _drawRoad(
      canvas,
      mainRoadPaint..strokeWidth = 12,
      [
        Offset(-20, size.height * .72),
        Offset(size.width * .18, size.height * .52),
        Offset(size.width * .42, size.height * .48),
        Offset(size.width * .72, size.height * .30),
        Offset(size.width + 20, size.height * .28),
      ],
    );
    _drawRoad(
      canvas,
      roadPaint..strokeWidth = 7,
      [
        Offset(size.width * .08, -10),
        Offset(size.width * .22, size.height * .32),
        Offset(size.width * .34, size.height * .68),
        Offset(size.width * .52, size.height + 10),
      ],
    );
    _drawRoad(
      canvas,
      roadPaint..strokeWidth = 6,
      [
        Offset(-10, size.height * .22),
        Offset(size.width * .30, size.height * .25),
        Offset(size.width * .58, size.height * .44),
        Offset(size.width + 10, size.height * .50),
      ],
    );
    _drawRoad(
      canvas,
      smallRoadPaint..strokeWidth = 4,
      [
        Offset(size.width * .70, -10),
        Offset(size.width * .55, size.height * .30),
        Offset(size.width * .50, size.height * .75),
      ],
    );
    _drawRoad(
      canvas,
      smallRoadPaint..strokeWidth = 4,
      [
        Offset(size.width * .02, size.height * .92),
        Offset(size.width * .28, size.height * .80),
        Offset(size.width * .78, size.height * .84),
      ],
    );
  }

  void _drawRoad(Canvas canvas, Paint paint, List<Offset> points) {
    if (points.length < 2) return;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      final control = Offset(
        (previous.dx + current.dx) / 2,
        (previous.dy + current.dy) / 2,
      );
      path.quadraticBezierTo(
        previous.dx,
        previous.dy,
        control.dx,
        control.dy,
      );
    }
    path.lineTo(points.last.dx, points.last.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
