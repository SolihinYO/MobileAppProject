import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveLocationScreen extends StatefulWidget {
  const LiveLocationScreen({super.key});

  @override
  State<LiveLocationScreen> createState() => _LiveLocationScreenState();
}

class _LiveLocationScreenState extends State<LiveLocationScreen> {
  final supabase = Supabase.instance.client;
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Live Tracking'),
        centerTitle: true,
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase
            .from('bus_locations')
            .stream(primaryKey: ['id'])
            .eq('id', 'bus_001'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text('Bus location not available.'));
          }

          final busData = snapshot.data!.first;
          bool isLive = busData['is_live'] ?? false;
          double lat = (busData['latitude'] ?? 0.0).toDouble();
          double lng = (busData['longitude'] ?? 0.0).toDouble();

          if (!isLive) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bus_alert, size: 100, color: Colors.grey),
                  const SizedBox(height: 20),
                  const Text(
                    'BUS IS OFFLINE',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const Text('The driver has not started the trip yet.'),
                ],
              ),
            );
          }

          // Marker for bus
          final busMarker = Marker(
            markerId: const MarkerId('bus'),
            position: LatLng(lat, lng),
            infoWindow: const InfoWindow(title: 'Bus 001'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          );

          return Column(
            children: [
              // Google Map section
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(lat, lng),
                    zoom: 15,
                  ),
                  markers: {busMarker},
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                ),
              ),

              // Info Card
              Container(
                padding: const EdgeInsets.all(25),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.directions_bus,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "STATUS: LIVE",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              "Bus 001 is on the way",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Move camera to bus location when pressed
                        _mapController?.animateCamera(
                          CameraUpdate.newLatLng(LatLng(lat, lng)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        "CENTER ON BUS",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
