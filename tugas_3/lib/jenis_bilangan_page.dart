import 'package:flutter/material.dart';

class JenisBilanganPage extends StatefulWidget {
  const JenisBilanganPage({super.key});

  @override
  State<JenisBilanganPage> createState() => _JenisBilanganPageState();
}

class _JenisBilanganPageState extends State<JenisBilanganPage> {
  final TextEditingController _controller = TextEditingController();
  int? _input;
  Map<String, bool> _hasil = {};

  void _periksaAngka() {
    final inputStr = _controller.text.trim();
    final input = num.tryParse(inputStr);

    if (input == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan angka yang valid")),
      );
      return;
    }

    setState(() {
      _input = input.toInt();
      _hasil = {
        'Prima': _isPrima(input.toInt()),
        'Desimal': input is double && input != input.toInt(),
        'Bulat Positif': input is int && input > 0,
        'Bulat Negatif': input is int && input < 0,
        'Cacah': input is int && input >= 0,
      };
    });
  }

  bool _isPrima(int n) {
    if (n <= 1) return false;
    for (int i = 2; i <= n ~/ 2; i++) {
      if (n % i == 0) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Warna-warna tema Mocha Cream
    const Color backgroundColor = Color(0xFFF4E2D8); // Cream Beige
    const Color buttonColor = Color(0xFFA47148); // Mocha
    const Color textColor = Color(0xFF5E4B3C); // Deep Taupe

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jenis Bilangan'),
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Masukkan angka',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _periksaAngka,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Periksa Angka',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            if (_hasil.isNotEmpty)
              Expanded(
                child: ListView(
                  children: _hasil.entries.map((e) {
                    return Card(
                      color: backgroundColor,
                      child: ListTile(
                        title: Text(
                          e.key,
                          style: TextStyle(color: textColor),
                        ),
                        trailing: Icon(
                          e.value ? Icons.check_circle : Icons.cancel,
                          color: e.value ? Colors.green : Colors.red,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
