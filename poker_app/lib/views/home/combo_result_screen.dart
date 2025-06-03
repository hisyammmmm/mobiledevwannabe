import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poker_app/services/combo_service.dart';
import 'package:poker_app/widgets/combo_display_widget.dart';

class ComboResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final comboService = Provider.of<ComboService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Combo Result')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ComboDisplayWidget(combo: comboService.currentCombo),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                comboService.clearSelection();
                Navigator.pop(context);
              },
              child: Text('Back to Cards'),
            ),
          ],
        ),
      ),
    );
  }
}