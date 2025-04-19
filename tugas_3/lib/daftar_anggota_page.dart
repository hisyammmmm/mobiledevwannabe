import 'package:flutter/material.dart';
import 'bottom_nav.dart';

class DaftarAnggotaPage extends StatelessWidget {
  const DaftarAnggotaPage({super.key});

  final List<Map<String, String>> anggota = const [
    {
      'nama': 'Abdullah Hisyam Rayyanov',
      'nim': '123220120',
    },
    {
      'nama': 'Muhammad Nur Alfi Syahri',
      'nim': '123220000',
    },
    {
      'nama': 'Hanafie Budi Pratama',
      'nim': '123220166',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Warna tema Mocha Cream
    const Color cardColor = Color(0xFFFFFFFF); // White for card
    const Color textColor = Color(0xFF5E4B3C); // Deep Taupe for text

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Anggota',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFA47148), // Mocha
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: anggota.length,
        itemBuilder: (context, index) {
          final data = anggota[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: cardColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nama: ${data['nama']}',
                    style: TextStyle(fontSize: 18, color: textColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'NIM: ${data['nim']}',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}
