import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poker_app/models/history_model.dart';
import 'package:poker_app/services/combo_service.dart';
import 'package:poker_app/widgets/card_widget.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final comboService = Provider.of<ComboService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('History')),
      body: comboService.history.isEmpty
          ? Center(child: Text('No history yet'))
          : ListView.builder(
        itemCount: comboService.history.length,
        itemBuilder: (context, index) {
          final history = comboService.history[index];
          return Dismissible(
            key: Key(history.id),
            background: Container(color: Colors.red),
            onDismissed: (_) => comboService.deleteHistoryItem(history.id),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      history.combo,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${history.date.day}/${history.date.month}/${history.date.year} ${history.date.hour}:${history.date.minute}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: history.cards
                            .map((cardCode) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.network(
                            'https://deckofcardsapi.com/static/img/$cardCode.png',
                            height: 100,
                          ),
                        ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}