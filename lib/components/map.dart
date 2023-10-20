import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/material.dart';

class MapView extends StatefulWidget {
  late Set<Polyline> polylines;
  late Set<Marker> markers;
  late LatLngBounds? latlngBounds;
  MapView(
    Set<Polyline> this.polylines,
    Set<Marker> this.markers,
    LatLngBounds? this.latlngBounds, {
    super.key,
  });

  @override
  State<MapView> createState() =>
      MapViewState(polylines, markers, latlngBounds);
}

class MapViewState extends State<MapView> {
  late Set<Polyline> polylines;
  late Set<Marker> markers;
  late LatLngBounds? latlngBounds;
  MapViewState(Set<Polyline> this.polylines, Set<Marker> this.markers,
      LatLngBounds? this.latlngBounds);

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Position?>(
        stream: Geolocator.getPositionStream(),
        builder: (context, AsyncSnapshot<Position?> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          Position pos = snapshot.data!;
          CameraPosition camPos = CameraPosition(
              target: LatLng(pos.latitude, pos.longitude), zoom: 14.735);
          if (latlngBounds == null) {
            latlngBounds = LatLngBounds(
                southwest: LatLng(pos.latitude, pos.longitude - 0.004735),
                northeast: LatLng(pos.latitude, pos.longitude + 0.004735));
          }
          _controller.future.then((GoogleMapController controller) {
            controller.animateCamera(
                CameraUpdate.newLatLngBounds(latlngBounds!, 100.0));
          });
          return StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('buses').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Set<Marker> buses = {};
                  snapshot.data?.docs.forEach(
                    (doc) {
                      LatLng bus = LatLng(
                        doc.get("current_location").latitude,
                        doc.get("current_location").longitude,
                      );
                      buses.add(
                        Marker(
                          markerId: MarkerId("${doc.get('bus_no')}"),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueAzure,
                          ),
                          position: bus,
                        ),
                      );
                    },
                  );
                  buses.forEach(
                    (marker) {
                      markers.add(marker);
                    },
                  );
                }
                return GoogleMap(
                  markers: markers,
                  polylines: polylines,
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: camPos,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                );
              });
        },
      ),
    );
  }
}
