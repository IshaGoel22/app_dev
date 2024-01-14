import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/places.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation intialocation;
  final bool isSelecting;

  MapScreen([
    this.isSelecting = false,
    this.intialocation =
        const PlaceLocation(latitude: 37.422, longitude: -122.4, address: ''),
  ]);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLoaction;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLoaction = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Map'),
          actions: [
            if (widget.isSelecting)
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(_pickedLoaction);
                  },
                  icon: Icon(Icons.check))
          ],
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(widget.intialocation.latitude,
                  widget.intialocation.longitude),
              zoom: 16),
          onTap: widget.isSelecting ? _selectLocation : null,
          markers: (_pickedLoaction == null && widget.isSelecting)
              ? <Marker>[].toSet()
              : {
                  Marker(
                    markerId: MarkerId('m1'),
                    position: _pickedLoaction ??
                        LatLng(
                          widget.intialocation.latitude,
                          widget.intialocation.longitude,
                        ),
                  ),
                },
        ));
  }
}
