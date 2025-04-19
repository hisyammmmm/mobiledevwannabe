import 'package:flutter/material.dart';
import 'stopwatch_page.dart';
import 'jenis_bilangan_page.dart';
import 'tracking_lbs_page.dart';
import 'konversi_waktu_page.dart';
import 'situs_rekomendasi_page.dart';
import 'bottom_nav.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna-warna tema Mocha Cream
    const Color backgroundColor = Color(0xFFF4E2D8); // Cream Beige
    const Color cardColor = Color(0xFFCDBBA7);       // Soft Brown
    const Color textColor = Color(0xFF5E4B3C);       // Deep Taupe
    const Color buttonColor = Color(0xFFA47148);     // Mocha

    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Utama'),
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: backgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildMenuTile(context, 'Stopwatch', const StopwatchPage(), cardColor, textColor),
          _buildMenuTile(context, 'Jenis Bilangan', const JenisBilanganPage(), cardColor, textColor),
          _buildMenuTile(context, 'Tracking LBS', const TrackingLBSPage(), cardColor, textColor),
          _buildMenuTile(context, 'Konversi Waktu', const KonversiWaktuPage(), cardColor, textColor),
          _buildMenuTile(context, 'Situs Rekomendasi', const SitusRekomendasiPage(), cardColor, textColor),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }

  Widget _buildMenuTile(BuildContext context, String title, Widget page, Color cardColor, Color textColor) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: textColor),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        ),
      ),
    );
  }
}
