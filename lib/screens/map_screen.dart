import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:snapmap/services/geo_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

//This portion creates the map to show where this picture was taken
class _MapScreenState extends State<MapScreen> {
  //TODO: get location of post(s)
  LatLng? coords; // acquire coords of post

  @override
  void initState() {
    _currLocation();
    super.initState();
  }

  Future<void> _currLocation() async {
    Position pos = await getCurrentLocation();
    setState(() {
      coords = LatLng(pos.latitude, pos.longitude);
    });
  }

  final dumbyData =
      LatLng(43.92233, -78.9409); //basic data to verify functionality

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(zoom: 15.0, center: dumbyData),
      layers: [
        TileLayerOptions(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/aforbes918/ckwmdijqt153q14nl8d25co18/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWZvcmJlczkxOCIsImEiOiJja3djemlxYjcwNWd1MnhwaTJ3a252YjR1In0.Bg4yEPvnwU1VJsdZmS2dFA",
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1IjoiYWZvcmJlczkxOCIsImEiOiJja3djemlxYjcwNWd1MnhwaTJ3a252YjR1In0.Bg4yEPvnwU1VJsdZmS2dFA',
              'id': 'mapbox.mapbox-streets-v8'
            }),
        MarkerLayerOptions(markers: [
          Marker(
              point: dumbyData,
              builder: (context) {
                return const Icon(
                  Icons.attribution,
                  color: Colors.redAccent,
                  size: 40,
                );
              }),
          if (coords != null)
            Marker(
                point: coords!,
                builder: (context) {
                  return const Icon(
                    Icons.location_on_sharp,
                    color: Colors.blueAccent,
                    size: 40,
                  );
                })
        ])
      ],
    );
  }
}
