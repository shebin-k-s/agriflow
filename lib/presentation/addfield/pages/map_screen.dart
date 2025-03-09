import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? selectedLocation;
  String? address;
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Future<void> getAddressFromLatLong(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          address = place.subLocality;
        } else if (place.locality != null && place.locality!.isNotEmpty) {
          address = place.locality;
        } else {
          address = place.administrativeArea;
        }
        setState(() {});
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  void _onPlaceSelected(Prediction prediction) async {
    try {
      address = null;

      _focusNode.unfocus();
      _searchController.text = prediction.description!;
      List<Location> locations = await locationFromAddress(
        prediction.description!,
      );
      if (locations.isNotEmpty) {
        LatLng newLocation =
            LatLng(locations.first.latitude, locations.first.longitude);
        _mapController?.animateCamera(CameraUpdate.newLatLng(newLocation));
        setState(() {
          selectedLocation = newLocation;
        });
        await getAddressFromLatLong(newLocation);
      }
    } catch (e) {
      log('Error selecting place: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.7,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(10.5276, 76.2144),
              zoom: 15,
            ),
            onTap: (LatLng location) {
              address = null;

              setState(() {
                selectedLocation = location;
              });
              getAddressFromLatLong(location);
            },
            markers: selectedLocation == null
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId('selected_location'),
                      position: selectedLocation!,
                      infoWindow: InfoWindow(title: address),
                    )
                  },
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: GooglePlaceAutoCompleteTextField(
                            focusNode: _focusNode,
                            textEditingController: _searchController,
                            googleAPIKey:
                                'AIzaSyCoEDgDwEhSkLs_bhWmPzErJa7imkZ6EiA',
                            isLatLngRequired: false,
                            debounceTime: 800,
                            inputDecoration: InputDecoration(
                              hintText: 'Search location',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: theme.hintColor,
                              ),
                            ),
                            itemClick: _onPlaceSelected,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (selectedLocation != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(32),
                child: address == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selected Location',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Text("Place : "),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  address!,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Latitude : ${selectedLocation!.latitude}",
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Longitude : ${selectedLocation!.longitude}",
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: const Text(
                                'Confirm Location',
                              ),
                              onPressed: () {
                                Navigator.pop(context, {
                                  'location': selectedLocation,
                                  'address': address,
                                });
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
