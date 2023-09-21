import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:vidyutkranti/components/map.dart';
import 'package:vidyutkranti/pages/route.dart';
import 'package:vidyutkranti/components/search_card.dart';
import '../components/app_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Position _curPos;
  @override
  void initState() {
    super.initState();
    _handleLocationPermission();
    Geolocator.getCurrentPosition().then((Position pos) => this._curPos = pos);
  }

  TextEditingController _textController = TextEditingController();

  Future<bool> _handleLocationPermission() async {
    LocationPermission permission;
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
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

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      // extendBodyBehindAppBar: true,
      bottomSheet: null,
      primary: true,
      extendBody: true,
      drawer: AppDrawer(),
      key: scaffoldKey,

      body: Stack(
        children: [
          //Map Area

          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) =>
                SizedBox(
              height: constraints.maxHeight * 0.62,
              //Place Map widget here
              child: Container(
                // height: size.height * 0.55,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 204, 245, 184),
                ),
                margin: const EdgeInsets.all(0),
                child: MapView(Set<Polyline>(), Set<Marker>(), null),
              ),
            ),
          ),

          //Drawer Icon button

          SafeArea(
            child: IconButton(
              icon: const Icon(
                Icons.menu_rounded,
                color: Colors.black,
                size: 28,
              ),
              onPressed: () {
                //Open drawer
                scaffoldKey.currentState!.openDrawer();
              },
              highlightColor: Colors.blueGrey,
              // splashColor: Colors.grey,
            ),
          ),

          //Draggable Search List

          DraggableScrollableSheet(
            initialChildSize: 0.44,
            // maxChildSize: 0.72,
            maxChildSize: 0.6,
            minChildSize: 0.385,
            builder: (context, scrollController) => Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
                color: Color(0xFF394867),
              ),
              child: ListView(
                controller: scrollController,

                //Search Cards
                children: [
                  GooglePlaceAutoCompleteTextField(
                    textEditingController: _textController,
                    googleAPIKey: dotenv.env["PLACES_API_KEY"]!,
                    isLatLngRequired: true,
                    getPlaceDetailWithLatLng: (Prediction prediction) async {
                      _getClosestBusStation(_curPos.latitude, _curPos.longitude)
                          .then((startLatLng) {
                        _getClosestBusStation(double.parse(prediction.lat!),
                                double.parse(prediction.lng!))
                            .then((destinationLatLng) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RoutePage(
                                  startLatLng.latitude,
                                  startLatLng.longitude,
                                  destinationLatLng.latitude,
                                  destinationLatLng.longitude)));
                        });
                      });
                    },
                    itemClick: (Prediction prediction) {
                      _textController.text = prediction.description!;
                    },
                    itemBuilder: (context, index, Prediction prediction) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(Icons.location_on),
                            SizedBox(
                              width: 7,
                            ),
                            Expanded(
                                child: Text("${prediction.description ?? ""}"))
                          ],
                        ),
                      );
                    },
                    isCrossBtnShown: true,
                  ),
                  Divider(
                    color: Color(0xFFF1F6F9),
                    thickness: 5,
                    endIndent: 80,
                    indent: 80,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SearchCard(
                    searchTitle: 'Enter Destination',
                    inputHintText: 'Search by Destination...',
                    dropdownController: () {},
                    optionList: [
                      'Destination-1',
                      'Destination-2',
                      'Destination-3',
                      'Destination-4',
                      'Destination-5',
                    ],
                  ),
                  SearchCard(
                    searchTitle: 'Enter Route',
                    inputHintText: 'Search by Route...',
                    dropdownController: () {},
                    optionList: [
                      'Route-1',
                      'Route-2',
                      'Route-3',
                      'Route-4',
                      'Route-5',
                    ],
                  ),
                  SearchCard(
                    searchTitle: 'Enter Bus-Stop',
                    inputHintText: 'Find available buses at a stop',
                    dropdownController: () {},
                    optionList: [
                      'Stop-1',
                      'Stop-2',
                      'Stop-3',
                      'Stop-4',
                      'Stop-5',
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
