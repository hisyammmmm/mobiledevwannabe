import 'package:flutter/material.dart';
import 'home_page.dart';
import 'daftar_anggota_page.dart';
import 'bantuan_page.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({super.key, required this.currentIndex});

  void _onTabTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget destination;
    switch (index) {
      case 0:
        destination = const HomePage();
        break;
      case 1:
        destination = const DaftarAnggotaPage();
        break;
      case 2:
        destination = const BantuanPage();
        break;
      default:
        destination = const HomePage();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onTabTapped(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Anggota'),
        BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'Bantuan'),
      ],
    );
  }
}
