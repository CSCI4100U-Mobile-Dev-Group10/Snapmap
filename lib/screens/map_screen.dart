import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:snapmap/models/exceptions/permissions_exception.dart';
import 'package:snapmap/services/geo_service.dart';
import 'package:snapmap/utils/logger.dart';

const double zoom = 15.0;
const Key mapKey = Key('map');

class MapScreen extends StatefulWidget {
  static const String routeId = '/map';
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

//This portion creates the map to show where this picture was taken
class _MapScreenState extends State<MapScreen> {
  LatLng? coords; // acquire coords of post
  bool isPostLocation = true;
  MapController controller = MapControllerImpl();

  @override
  void initState() {
    _currLocation();
    super.initState();
  }

  Future<void> _currLocation() async {
    try {
      LatLng latlng = await getCurrentLocation();
      if (mounted) {
        setState(() {
          coords = latlng;
        });
      }
    } on PermissionsException {
      logger.w('Location Permissons denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng? postLocation =
        ModalRoute.of(context)!.settings.arguments as LatLng?;
    LatLng? center = postLocation ?? coords;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posted From'),
        actions: [
          if (postLocation != null && coords != null)
            IconButton(
              icon: Icon(
                (isPostLocation) ? Icons.attribution : Icons.location_on_sharp,
              ),
              onPressed: () async {
                await controller.onReady;
                if (isPostLocation) {
                  setState(() {
                    isPostLocation = false;
                  });
                  controller.move(coords!, zoom);
                } else {
                  setState(() {
                    isPostLocation = true;
                  });
                  controller.move(postLocation, zoom);
                }
              },
            ),
        ],
      ),
      body: FlutterMap(
        key: mapKey,
        options: MapOptions(
          zoom: 15.0,
          center: center,
          controller: controller,
          onMapCreated: (c) => controller = c,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/aforbes918/ckwmdijqt153q14nl8d25co18/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWZvcmJlczkxOCIsImEiOiJja3djemlxYjcwNWd1MnhwaTJ3a252YjR1In0.Bg4yEPvnwU1VJsdZmS2dFA",
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1IjoiYWZvcmJlczkxOCIsImEiOiJja3djemlxYjcwNWd1MnhwaTJ3a252YjR1In0.Bg4yEPvnwU1VJsdZmS2dFA',
              'id': 'mapbox.mapbox-streets-v8'
            },
          ),
          PolylineLayerOptions(polylines: [
            Polyline(
              strokeWidth: 1.0,
              color: const Color(0xFF0EA47A),
              isDotted: true,
              points: [
                if (postLocation != null) postLocation,
                if (coords != null) coords!,
              ],
            )
          ]),
          MarkerLayerOptions(
            markers: [
              if (postLocation != null)
                Marker(
                  point: postLocation,
                  builder: (context) {
                    return const Icon(
                      Icons.location_on_sharp,
                      color: Colors.redAccent,
                      size: 40,
                    );
                  },
                ),
              if (coords != null)
                Marker(
                  point: coords!,
                  builder: (context) {
                    return const Icon(
                      Icons.attribution,
                      color: Colors.blueAccent,
                      size: 40,
                    );
                  },
                ),
            ],
          )
        ],
      ),
    );
  }
}
