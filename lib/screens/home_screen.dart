import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lesson74_yandexmap/services/yandex_map_service.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late YandexMapController mapController;
  List<MapObject>? polylines;

  Point myCurrentLocation = const Point(
    latitude: 41.2856806,
    longitude: 69.9034646,
  );

  Point najotTalim = const Point(
    latitude: 41.2856806,
    longitude: 69.2034646,
  );

  void onMapCreated(YandexMapController controller) {
    mapController = controller;
    mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: najotTalim,
          zoom: 20,
        ),
      ),
    );
    setState(() {});
  }

  void onCameraPositionChanged(
    CameraPosition position,
    CameraUpdateReason reason,
    bool finished,
  ) async {
    myCurrentLocation = position.target;

    if (finished) {
      polylines =
          await YandexMapService.getDirection(najotTalim, myCurrentLocation);
    }

    setState(() {});
  }

  void getDirection() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              final res = await mapController.getUserCameraPosition();
              mapController.moveCamera(
                CameraUpdate.zoomOut(),
              );
            },
            icon: Icon(Icons.remove_circle),
          ),
          IconButton(
            onPressed: () {
              mapController.moveCamera(
                CameraUpdate.zoomIn(),
              );
            },
            icon: Icon(Icons.add_circle),
          ),
        ],
      ),
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: onMapCreated,
            onCameraPositionChanged: onCameraPositionChanged,
            mapType: MapType.map,
            mapObjects: [
              PlacemarkMapObject(
                mapId: const MapObjectId("najotTalim"),
                point: najotTalim,
                icon: PlacemarkIcon.single(
                  PlacemarkIconStyle(
                    image: BitmapDescriptor.fromAssetImage(
                      "assets/route_start.png",
                    ),
                  ),
                ),
              ),
              PlacemarkMapObject(
                mapId: const MapObjectId("myCurrentLocation"),
                point: myCurrentLocation ?? najotTalim,
                icon: PlacemarkIcon.single(
                  PlacemarkIconStyle(
                    image: BitmapDescriptor.fromAssetImage(
                      "assets/place.png",
                    ),
                  ),
                ),
              ),
              ...?polylines,
              // PolylineMapObject(
              //   mapId: const MapObjectId("birinchiJoy"),
              //   strokeColor: Colors.blue,
              //   strokeWidth: 5,
              //   polyline: Polyline(
              //     points: [
              //       najotTalim,
              //       myCurrentLocation,
              //     ],
              //   ),
              // ),
            ],
          ),
          // const Align(
          //   child: Icon(
          //     Icons.place,
          //     size: 60,
          //     color: Colors.red,
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
