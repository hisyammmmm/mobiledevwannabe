import 'package:flutter/material.dart';

class KonversiWaktuPage extends StatefulWidget {
  const KonversiWaktuPage({super.key});

  @override
  State<KonversiWaktuPage> createState() => _KonversiWaktuPageState();
}

class _KonversiWaktuPageState extends State<KonversiWaktuPage> {
  final TextEditingController _controller = TextEditingController();
  String _hasil = '';

  void _konversiWaktu() {
    final input = double.tryParse(_controller.text);
    if (input == null || input <= 0) {
      setState(() {
        _hasil = 'Masukkan jumlah tahun yang valid.';
      });
      return;
    }

    final tahun = input;
    final jam = tahun * 365.25 * 24;
    final menit = jam * 60;
    final detik = menit * 60;

    setState(() {
      _hasil =
      '${tahun.toStringAsFixed(2)} tahun =\n'
          '${jam.toStringAsFixed(0)} jam\n'
          '${menit.toStringAsFixed(0)} menit\n'
          '${detik.toStringAsFixed(0)} detik';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Warna-warna tema Mocha Cream
    const Color backgroundColor = Color(0xFFF4E2D8); // Cream Beige
    const Color buttonColor = Color(0xFFA47148); // Mocha
    const Color textColor = Color(0xFF5E4B3C); // Deep Taupe

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Konversi Waktu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan jumlah tahun:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Contoh: 1.5',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _konversiWaktu,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Konversi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            // Menampilkan hasil di tengah layar
            if (_hasil.isNotEmpty)
              Center(
                child: Card(
                  color: backgroundColor,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      _hasil,
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
