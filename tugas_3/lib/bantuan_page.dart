import 'package:flutter/material.dart';
import 'session_manager.dart';
import 'login_page.dart';
import 'bottom_nav.dart';

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  void _logout(BuildContext context) async {
    await SessionManager.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Warna-warna tema Mocha Cream
    const Color backgroundColor = Color(0xFFF4E2D8); // Cream Beige
    const Color cardColor = Color(0xFFCDBBA7);       // Soft Brown
    const Color textColor = Color(0xFF5E4B3C);       // Deep Taupe
    const Color buttonColor = Color(0xFFA47148);     // Mocha

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Menu Bantuan'),
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cara Menggunakan Aplikasi:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '1. Halaman Utama: Pilih menu yang diinginkan.\n'
                    '2. Stopwatch: Gunakan untuk menghitung waktu.\n'
                    '3. Jenis Bilangan: Menampilkan informasi jenis bilangan.\n'
                    '4. Tracking LBS: Melihat lokasi saat ini.\n'
                    '5. Konversi Waktu: Mengonversi waktu antar zona.\n'
                    '6. Situs Rekomendasi: Melihat situs web rekomendasi.',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () => _logout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }
}
