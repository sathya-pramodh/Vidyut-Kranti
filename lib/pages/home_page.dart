import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
                  Divider(
                    color: Color(0xFFF1F6F9),
                    thickness: 5,
                    endIndent: 80,
                    indent: 80,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GooglePlaceAutoCompleteTextField(
                    textEditingController: _textController,
                    googleAPIKey: dotenv.env["PLACES_API_KEY"]!,
                    isLatLngRequired: true,
                    getPlaceDetailWithLatLng: (Prediction prediction) async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RoutePage(
                            _curPos.latitude,
                            _curPos.longitude,
                            double.parse(prediction.lat!),
                            double.parse(prediction.lng!),
                          ),
                        ),
                      );
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SearchCard(
                                    searchTitle: 'Enter Bus-Stop',
                                    inputHintText:
                                        'Find available buses at a stop',
                                    dropdownController: () {},
                                    optionList: [
                                      'Stop-1',
                                      'Stop-2',
                                      'Stop-3',
                                      'Stop-4',
                                      'Stop-5',
                                    ],
                                  ),
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
                        icon: Icon(
                          Icons.alt_route,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SearchCard(
                                    searchTitle: 'Enter Bus-Stop',
                                    inputHintText:
                                        'Find available buses at a stop',
                                    dropdownController: () {},
                                    optionList: [
                                      'Stop-1',
                                      'Stop-2',
                                      'Stop-3',
                                      'Stop-4',
                                      'Stop-5',
                                    ],
                                  ),
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
                        icon: Icon(
                          Icons.bus_alert_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  const Column(
                    children: [
                      const Text(
                        "Latest in the Area:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Multiple reports of blockage near Nagarbhavi.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
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
