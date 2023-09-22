import 'package:cloud_firestore/cloud_firestore.dart';
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
  late double _startStationLatitude;
  late double _startStationLongitude;
  late double _destinationStationLatitude;
  late double _destinationStationLongitude;

  @override
  void initState() {
    super.initState();
    _getClosestBusStation(startLatitude, startLongitude).then(
      (startStation) {
        _startStationLatitude = startStation.latitude;
        _startStationLongitude = startStation.longitude;
        _getClosestBusStation(destinationLatitude, destinationLongitude).then(
          (destinationStation) {
            _destinationStationLatitude = destinationStation.latitude;
            _destinationStationLongitude = destinationStation.longitude;
            _getPolylines();
          },
        );
      },
    );
  }

  Future<LatLng> _getClosestBusStation(
      double latitude, double longitude) async {
    QuerySnapshot querySnap =
        await FirebaseFirestore.instance.collection('stations').get();
    double closestLat = 0;
    double closestLng = 0;
    String closestName = "";
    querySnap.docs.forEach((doc) {
      double lat = doc.get('location').latitude;
      double lng = doc.get('location').longitude;
      if ((latitude - lat).abs() <= (latitude - closestLat).abs() &&
          (longitude - lng).abs() <= (longitude - closestLng).abs()) {
        closestLat = lat;
        closestName = doc.get('station_name');
        closestLng = lng;
      }
    });
    return LatLng(closestLat, closestLng);
  }

  _getPolylines() async {
    List<LatLng> polylineCoordinates = [];
    Map<PolylineId, Polyline> polylines = {};
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
      dotenv.env["MAPS_API_KEY"]!,
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(_startStationLatitude, _startStationLongitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    PolylineId id1 = PolylineId('poly1');
    Polyline polyline1 = Polyline(
      polylineId: id1,
      jointType: JointType.mitered,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id1] = polyline1;
    result = await PolylinePoints().getRouteBetweenCoordinates(
      dotenv.env["MAPS_API_KEY"]!,
      PointLatLng(_startStationLatitude, _startStationLongitude),
      PointLatLng(_destinationStationLatitude, _destinationStationLongitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        },
      );
    }
    PolylineId id2 = PolylineId('poly2');
    Polyline polyline2 = Polyline(
      polylineId: id2,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id2] = polyline2;
    result = await PolylinePoints().getRouteBetweenCoordinates(
      dotenv.env["MAPS_API_KEY"]!,
      PointLatLng(_destinationStationLatitude, _destinationStationLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        },
      );
    }
    PolylineId id3 = PolylineId('poly3');
    Polyline polyline3 = Polyline(
      polylineId: id3,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id3] = polyline3;
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
              position: LatLng(destinationLatitude, destinationLongitude)),
          Marker(
            markerId: MarkerId("image1"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            position: const LatLng(13.0433, 77.5518),
            onTap: () =>showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image(image: AssetImage('images/belc.jpg')),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
        ),
          Marker(
            markerId: MarkerId("image2"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            position: const LatLng(13.0421, 77.5482),
            onTap: () =>showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image(image: AssetImage('images/belc2.jpg')),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Marker(
            markerId: MarkerId("image3"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            position: const LatLng(12.9769, 77.5140),
            onTap: () =>showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image(image: AssetImage('images/nagar1.jpg')),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        },
        LatLngBounds(
          northeast: LatLng(_northEastLatitude, _northEastLongitude),
          southwest: LatLng(_southWestLatitude, _southWestLongitude),
        ));
  }
}
