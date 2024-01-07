import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String locationText = "Current Location";
  late String lat;
  late String long;

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled.");
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(
          "Location permissions are denied",
        );
      }
      if (permission == LocationPermission.deniedForever) {
        return Future.error("Location permissions are permanently denied, we cannot request permissions.");
      }      
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Location Plus"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                locationText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _getCurrentLocation().then((value) {
                    lat = '${value.latitude}';
                    long = '${value.longitude}';
                    setState(() {
                      locationText = "Latitude: $lat\nLongitude: $long";
                    });
                  });
                },
                child: const Text("Update Location"),
              ),
            ],
          ),
        ),
      );
}
