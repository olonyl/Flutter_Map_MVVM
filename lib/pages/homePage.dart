import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:place_finder/viewmodels/placeListViewModel.dart';
import 'package:place_finder/viewmodels/placeViewModel.dart';
import 'package:place_finder/widgets/placeList.dart';
import 'package:provider/provider.dart';
import 'package:map_launcher/map_launcher.dart' as prefix0;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();
  Position _currentPosition;

  Future<void> _onMapCrated(GoogleMapController controller) async {
    _controller.complete(controller);
    _currentPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        zoom: 14)));
  }

  Set<Marker> _getPlaceMarkers(List<PlaceViewModel> places) {
    return places.map((place) {
      return Marker(
        markerId: MarkerId(place.placeId),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: place.name),
        position: LatLng(place.latitude, place.longitude),
      );
    }).toSet();
  }

  Future<void> _openMapsFor(PlaceViewModel viewModel) async {
    if (await MapLauncher.isMapAvailable(prefix0.MapType.google)) {
      await MapLauncher.showMarker(
        mapType: prefix0.MapType.google,
        coords: Coords(viewModel.latitude, viewModel.longitude),
        title: viewModel.name,
        description: viewModel.name,
      );
    } else if (await MapLauncher.isMapAvailable(prefix0.MapType.apple)) {
      await MapLauncher.showMarker(
        mapType: prefix0.MapType.apple,
        coords: Coords(viewModel.latitude, viewModel.longitude),
        title: viewModel.name,
        description: viewModel.name,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PlaceListViewModel>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: vm.mapType,
            markers: _getPlaceMarkers(vm.places),
            myLocationEnabled: true,
            onMapCreated: _onMapCrated,
            initialCameraPosition: CameraPosition(
              target: LatLng(12.122658, -86.303391),
              zoom: 15,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onSubmitted: (value) {
                  vm.fetchPlacesByKeywordAndPosition(value,
                      _currentPosition.latitude, _currentPosition.longitude);
                },
                decoration: InputDecoration(
                  labelText: "Search here",
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
          ),
          Visibility(
            visible: vm.places.length > 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: FlatButton(
                    child: Text("Show List"),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => PlaceList(
                          places: vm.places,
                          onSelected: _openMapsFor,
                        ),
                      );
                    },
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 150,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                vm.toggleMapType();
              },
              child: Icon(Icons.map),
            ),
          )
        ],
      ),
    );
  }
}
