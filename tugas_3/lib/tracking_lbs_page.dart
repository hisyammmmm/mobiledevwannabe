import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class TrackingLBSPage extends StatefulWidget {
  const TrackingLBSPage({Key? key}) : super(key: key);

  @override
  State<TrackingLBSPage> createState() => _TrackingLBSPageState();
}

class _TrackingLBSPageState extends State<TrackingLBSPage> {
  final MapController _mapController = MapController();
  LatLng? _currentPosition;

  @override
  Widget build(BuildContext context) {
    // Warna-warna tema Mocha Cream
    const Color backgroundColor = Color(0xFFF4E2D8); // Cream Beige
    const Color buttonColor = Color(0xFFA47148); // Mocha
    const Color textColor = Color(0xFF5E4B3C); // Deep Taupe

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tracking LBS',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton.icon(
              onPressed: _locateAndCenter,
              icon: const Icon(Icons.my_location),
              label: const Text('Dapatkan Lokasi Saya'),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                // jika belum ada lokasi, default ke Jakarta
                center: _currentPosition ?? LatLng(-6.1754, 106.8272),
                zoom: 13.0,
              ),
              children: [
                // TileLayer OpenStreetMap
                TileLayer(
                  urlTemplate:
                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),

                // Marker lokasi saat ini (jika tersedia)
                if (_currentPosition != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentPosition!,
                        width: 50,
                        height: 50,
                        builder: (ctx) => const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _locateAndCenter() async {
    // Cek apakah layanan lokasi aktif
    if (!await Geolocator.isLocationServiceEnabled()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Layanan lokasi tidak aktif')),
      );
      return;
    }

    // Cek & minta izin lokasi
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Izin lokasi ditolak')),
        );
        return;
      }
    }
    if (perm == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Izin lokasi ditolak permanen')),
      );
      return;
    }

    // Ambil posisi pengguna
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Update state & pindah kamera peta
    setState(() {
      _currentPosition = LatLng(pos.latitude, pos.longitude);
    });
    _mapController.move(_currentPosition!, 15.0);
  }
}
