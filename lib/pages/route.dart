import 'dart:math';

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
  late double _blockLatitude;
  late double _blockLongitude;
  late String _blockDesc;
  List<PolylineResult> _suggestions = [];
  int _selected = -1;
  List<Marker> _markers = [];

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
            FirebaseFirestore.instance
                .collection('blocks')
                .orderBy('time', descending: true)
                .get()
                .then(
              (blocks) {
                // TODO: Handle all blockages dynamically, currently just handles the most recently added block.
                _blockLatitude = blocks.docs[0].get('location').latitude;
                _blockLongitude = blocks.docs[0].get('location').longitude;
                _blockDesc = blocks.docs[0].get('description');
              },
            );
            FirebaseFirestore.instance.collection('stations').get().then(
              (stations) {
                List<PolylineWayPoint> _waypoints = [];
                stations.docs.forEach(
                  (station) {
                    double lat = station.get('location').latitude;
                    double lng = station.get('location').longitude;
                    bool check = (lat == _startStationLatitude &&
                            lng == _startStationLongitude) ||
                        (lat == _destinationStationLatitude &&
                            lng == _destinationStationLongitude);
                    if (check) {
                      _waypoints.add(
                        PolylineWayPoint(
                            location: "${lat},${lng}", stopOver: true),
                      );
                    }
                  },
                );
                PolylinePoints()
                    .getRouteWithAlternatives(
                  request: PolylineRequest(
                    apiKey: dotenv.env["MAPS_API_KEY"]!,
                    origin: PointLatLng(
                      startLatitude,
                      startLongitude,
                    ),
                    destination: PointLatLng(
                      destinationLatitude,
                      destinationLongitude,
                    ),
                    mode: TravelMode.driving,
                    wayPoints: _waypoints,
                    avoidHighways: false,
                    avoidTolls: false,
                    avoidFerries: false,
                    optimizeWaypoints: false,
                    alternatives: true,
                  ),
                )
                    .then(
                  (results) {
                    setState(
                      () {
                        _suggestions = results;
                        _markers.addAll(
                          [
                            Marker(
                              icon: BitmapDescriptor.defaultMarker,
                              markerId: MarkerId("ID"),
                              position: LatLng(
                                  destinationLatitude, destinationLongitude),
                            ),
                            Marker(
                              markerId: MarkerId('abc'),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueBlue),
                              position: const LatLng(13.0433, 77.5518),
                              onTap: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image(
                                            image:
                                                AssetImage('images/belc.jpg')),
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
                              markerId: MarkerId('ID1'),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueBlue),
                              position: const LatLng(13.0421, 77.5482),
                              onTap: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image(
                                            image:
                                                AssetImage('images/belc2.jpg')),
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
                              markerId: MarkerId('ID2'),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueBlue),
                              position: const LatLng(12.9769, 77.5140),
                              onTap: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image(
                                            image: AssetImage(
                                                'images/nagar1.jpg')),
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
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueYellow),
                              markerId: MarkerId("Block1"),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    insetPadding: EdgeInsets.only(
                                        right: 50,
                                        left: 50,
                                        top: 150,
                                        bottom: 150),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          color: Colors.yellow,
                                          size: 38,
                                        ),
                                        Text(
                                          _blockDesc,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 30),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              position: LatLng(_blockLatitude, _blockLongitude),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
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
    double minDist = 1e10;
    querySnap.docs.forEach((doc) {
      double lat = doc.get('location').latitude;
      double lng = doc.get('location').longitude;
      double p = 0.017453292519943295;
      var c = cos;
      double a = 0.5 -
          c((lat - latitude).abs() * p) / 2 +
          c(latitude * p) *
              c(lat * p) *
              (1 - c((lng - longitude).abs() * p)) /
              2;
      double dist = 12742 * asin(sqrt(a)); // Distance in km.
      if (dist <= minDist) {
        minDist = dist;
        closestLat = lat;
        closestLng = lng;
      }
    });
    return LatLng(closestLat, closestLng);
  }

  _getPolylines() async {
    List<LatLng> polylineCoordinates = [];
    Map<PolylineId, Polyline> polylines = {};
    _suggestions[_selected].points.asMap().forEach(
      (idx, point) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
        PolylineId id = PolylineId('poly${idx}');
        Polyline polyline = Polyline(
            polylineId: id,
            color: Colors.blue,
            points: polylineCoordinates,
            width: 3);
        polylines[id] = polyline;
      },
    );
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
    List<ListTile> tiles = [];
    _suggestions.asMap().forEach(
      (idx, suggestion) {
        tiles.add(
          ListTile(
            horizontalTitleGap: 20,
            title: Text(
              "${suggestion.endAddress!} ${(suggestion.durationText == null) ? '' : suggestion.durationText} ",
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onTap: () {
              setState(
                () async {
                  _selected = idx;
                  await _getPolylines();
                },
              );
            },
          ),
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: (_selected == -1)
            ? Text(
                'Suggested Routes',
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
            : Text(
                'Route',
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
      backgroundColor: Color.fromARGB(255, 168, 187, 219),
      body: (_selected == -1)
          ? Padding(
              padding: EdgeInsets.all(8),
              child: ListView(
                children: tiles,
              ),
            )
          : MapView(
              Set<Polyline>.of(_polylines.values),
              Set<Marker>.of(_markers),
              LatLngBounds(
                northeast: LatLng(_northEastLatitude, _northEastLongitude),
                southwest: LatLng(_southWestLatitude, _southWestLongitude),
              ),
            ),
    );
  }
}
