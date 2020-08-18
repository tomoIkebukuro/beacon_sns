import 'dart:async';

import 'package:beaconsns/global_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../function/geohash.dart';



class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapSampleState();
}

class MapSampleState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {

    var location=Provider.of<GlobalModel>(context,listen:false).location;

    var initialCameraPosition=CameraPosition(
      target: LatLng(location.latitude,location.longitude),
    );

    var g=GeoSection(latitude:location.latitude,longitude:location.longitude,zoomLevel: 10);
    var e=g.getNeighbors();
    var markers=<Marker>[
      Marker(
        markerId: MarkerId("A"),
        position: LatLng(location.latitude,location.longitude),
      )
    ];

    for(int i=0; i<e.length; i+=1){
      var a=e[i].toLatLng();
      markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(a[0],a[1])
        )
      );
    }

    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markers.toSet(),
      ),
    );
  }
}