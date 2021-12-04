import 'dart:math';

import 'package:latlong2/latlong.dart';

double kmToLatitude(double km) {
  return (km / 111.574).abs();
}

double kmToLongitude(double km, double latitude) {
  return (km / (111.320 * cos(degToRadian(latitude)))).abs();
}
