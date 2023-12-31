import 'package:firebase_auth/firebase_auth.dart';
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
  final User? user = FirebaseAuth.instance.currentUser;
  HomePage({super.key});

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
                child: MapView(
                    Set<Polyline>(),Set<Marker>(),null),
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
                  GooglePlaceAutoCompleteTextField(
                    textEditingController: _textController,
                    boxDecoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.transparent,
                    )),
                    googleAPIKey: dotenv.env["PLACES_API_KEY"]!,
                    isLatLngRequired: true,
                    textStyle: TextStyle(
                      color: Colors.white,
                    ),
                    inputDecoration: InputDecoration(
                      // hintText: "Search for destination",
                      labelText: 'Search destination',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
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
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SearchCard(
                                    searchTitle: 'Enter Route',
                                    inputHintText: 'Search for Routes',
                                    dropdownController: (value) => showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => Dialog(
                                        backgroundColor: Colors.white,
                                        shadowColor: Colors.transparent,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                            ),
                                            if(value == '401K')...
                                            [Text('STOPS:', style: TextStyle(fontSize: 20),),
                                            Text('Ramaiah College', style: TextStyle(fontSize: 16),),
                                            Text('BEL Circle', style: TextStyle(fontSize: 16),),
                                            Text('Yeshwanthpur'),
                                          ],
                                            if(value == '500E')...
                                            [Text('STOPS:', style: TextStyle(fontSize: 20),),
                                              Text('Ramaiah College', style: TextStyle(fontSize: 16),),
                                              Text('Marathalli', style: TextStyle(fontSize: 16),),
                                              Text('Silk Board', style: TextStyle(fontSize: 16),),
                                            ],
                                            if(value == '378')...
                                            [Text('STOPS:', style: TextStyle(fontSize: 20),),
                                              Text('Konantunte', style: TextStyle(fontSize: 16),),
                                              Text('Banshankari', style: TextStyle(fontSize: 16),),
                                              Text('Silk Institute', style: TextStyle(fontSize: 16),),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                    optionList: [
                                      '401K',
                                      '500E',
                                      '378',
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
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
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
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
                                    dropdownController: (value) => showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => Dialog(
                                        backgroundColor: Colors.white,
                                        shadowColor: Colors.transparent,
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                              ),
                                              if(value=='Ramaiah College')...
                                              [Text('next bus- 401R', style: TextStyle(fontSize: 20),),
                                              Text('ETA= 2mins', style: TextStyle(fontSize: 16),),
                                              Text('other buses:', style: TextStyle(fontSize: 20),),
                                              Text('500E', style: TextStyle(fontSize: 16),),
                                              Text('400j', style: TextStyle(fontSize: 16),)],
                                              if(value=='BEL Circle')...
                                              [Text('next bus- 401R', style: TextStyle(fontSize: 20),),
                                                Text('ETA= 10mins', style: TextStyle(fontSize: 16),),
                                                Text('other buses:', style: TextStyle(fontSize: 20),),
                                                Text('500', style: TextStyle(fontSize: 16),),
                                                Text('567', style: TextStyle(fontSize: 16),)],
                                              if(value=='Naagarbhavi')...
                                              [Text('next bus- 401R', style: TextStyle(fontSize: 20),),
                                                Text('ETA= 5mins', style: TextStyle(fontSize: 16),),
                                                Text('other buses:', style: TextStyle(fontSize: 20),),
                                                Text('897', style: TextStyle(fontSize: 16),),
                                                Text('348P', style: TextStyle(fontSize: 16),)],
                                              ],
                                        ),
                                      ),
                                    ),
                                    optionList: [
                                      'Ramaiah College',
                                      'BEL Circle ',
                                      'Naagarbhavi',

                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
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
