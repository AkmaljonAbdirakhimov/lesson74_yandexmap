import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class YandexMapService {
  static Future<List<MapObject>> getDirection(
    Point from,
    Point to,
  ) async {
    final result = await YandexDriving.requestRoutes(
      points: [
        RequestPoint(point: from, requestPointType: RequestPointType.wayPoint),
        RequestPoint(point: to, requestPointType: RequestPointType.wayPoint),
      ],
      drivingOptions: DrivingOptions(
        initialAzimuth: 1,
        routesCount: 1,
        avoidTolls: true,
      ),
    );

    final drivingResults = await result.$2;

    if (drivingResults.error != null) {
      print("Joylashuv olinmadi");
      return [];
    }

    final points = drivingResults.routes!.map((route) {
      return PolylineMapObject(
        mapId: MapObjectId(UniqueKey().toString()),
        polyline: route.geometry,
      );
    }).toList();

    return points;
  }
}
