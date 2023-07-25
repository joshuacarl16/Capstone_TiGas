import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tigas_application/gmaps/autocomplete_prediction.dart';
import 'package:tigas_application/gmaps/network_utility.dart';
import 'package:tigas_application/gmaps/place_auto_complete_response.dart';
import 'package:tigas_application/widgets/location_list_tile.dart';

class SetLocationScreen extends StatefulWidget {
  const SetLocationScreen({super.key});

  @override
  State<SetLocationScreen> createState() => _SetLocationScreenState();
}

class _SetLocationScreenState extends State<SetLocationScreen> {
  List<AutocompletePrediction> placePredictions = [];

  void placeAutoComplete(String query) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        "/maps/api/place/autocomplete/json", //unencoder path
        {
          "input": query,
          "key": 'AIzaSyCvx_bpq17DFPNuW9yNU4EvAo_oXFybnfo',
        });
    String? response = await NetworkUtility.fetchUrl(uri);

    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF609966),
        // automaticallyImplyLeading: false,
      ),
      body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Form(
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: TextFormField(
                    onChanged: (value) {
                      placeAutoComplete(value);
                    },
                    textInputAction: TextInputAction.search,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    LocationPermission permission =
                        await Geolocator.checkPermission();
                    if (permission == LocationPermission.denied) {
                      permission = await Geolocator.requestPermission();
                      if (permission == LocationPermission.denied) {
                        openAppSettings();
                      }
                    }
                    if (permission == LocationPermission.deniedForever) {
                      return Future.error(
                          'Location permissions permanently denied');
                    }
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                        position.latitude, position.longitude);
                    Placemark place = placemarks[0];
                    String placeName = '${place.locality}, ${place.country}';
                    // String latLng =
                    //     "${position.latitude}, ${position.longitude}";
                    Navigator.pop(context, placeName);
                  },
                  icon: Icon(Icons.my_location),
                  label: Text('Use my Current Location'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.grey[800],
                      elevation: 0,
                      fixedSize: Size(350, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )),
                ),
              ),
              Divider(
                height: 4,
                thickness: 2,
                color: Colors.grey[800],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: placePredictions.length,
                  itemBuilder: (context, index) => LocationListTile(
                      location: placePredictions[index].description!,
                      press: () {
                        Navigator.pop(
                            context, placePredictions[index].description);
                      }),
                ),
              )
            ],
          )),
    );
  }
}
