import 'package:vidyutkranti/components/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RoutePage extends StatefulWidget {
  late final double startLatitude;
  late final double destinationLatitude;
  late final double startLongitude;
  late final double destinationLongitude;
  RoutePage(double this.startLatitude, double this.startLongitude,
      double this.destinationLatitude, double this.destinationLongitude,
      {super.key});
  @override
  State<RoutePage> createState() => RoutePageState(
      startLatitude, startLongitude, destinationLatitude, destinationLongitude);
}

class RoutePageState extends State<RoutePage> {
  late double startLatitude;
  late double startLongitude;
  late double destinationLatitude;
  late double destinationLongitude;
  RoutePageState(double this.startLatitude, double this.startLongitude,
      double this.destinationLatitude, double this.destinationLongitude);

  Map<PolylineId, Polyline> _polylines = {};
  late double _southWestLatitude;
  late double _southWestLongitude;
  late double _northEastLatitude;
  late double _northEastLongitude;
  _getPolylines() async {
    List<LatLng> polylineCoordinates = [];
    Map<PolylineId, Polyline> polylines = {};
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
      dotenv.env["MAPS_API_KEY"]!,
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
    setState(() {
      _polylines = polylines;
      double miny = (startLatitude <= destinationLatitude)
          ? startLatitude
          : destinationLatitude;
      double minx = (startLongitude <= destinationLongitude)
          ? startLongitude
          : destinationLongitude;
      double maxy = (startLatitude <= destinationLatitude)
          ? destinationLatitude
          : startLatitude;
      double maxx = (startLongitude <= destinationLongitude)
          ? destinationLongitude
          : startLongitude;
      _southWestLatitude = miny;
      _southWestLongitude = minx;
      _northEastLatitude = maxy;
      _northEastLongitude = maxx;
    });
  }

  @override
  void initState() {
    super.initState();
    _getPolylines();
  }

  @override
  Widget build(BuildContext context) {
    if (_polylines.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return MapView(
        Set<Polyline>.of(_polylines.values),
        {
          Marker(
              icon: BitmapDescriptor.defaultMarker,
              markerId: MarkerId("ID"),
              position: LatLng(destinationLatitude, destinationLongitude))
        },
        LatLngBounds(
          northeast: LatLng(_northEastLatitude, _northEastLongitude),
          southwest: LatLng(_southWestLatitude, _southWestLongitude),
        ));
  }
}
