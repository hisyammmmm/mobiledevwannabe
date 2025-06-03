import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:poker_app/models/card_model.dart';
import 'package:poker_app/models/history_model.dart';

class ComboService with ChangeNotifier {
  final Box<HistoryModel> _historyBox = Hive.box<HistoryModel>('history');

  List<CardModel> _selectedCards = [];
  String _currentCombo = '';

  List<CardModel> get selectedCards => _selectedCards;
  String get currentCombo => _currentCombo;
  List<HistoryModel> get history => _historyBox.values.toList().reversed.toList();

  void selectCard(CardModel card) {
    if (_selectedCards.length < 5 && !_selectedCards.contains(card)) {
      _selectedCards.add(card);
      notifyListeners();
    }
  }

  void removeCard(CardModel card) {
    _selectedCards.remove(card);
    notifyListeners();
  }

  void clearSelection() {
    _selectedCards.clear();
    _currentCombo = '';
    notifyListeners();
  }

  void checkCombo() {
    if (_selectedCards.length != 5) {
      _currentCombo = 'Please select exactly 5 cards';
      notifyListeners();
      return;
    }

    final ranks = _selectedCards.map((card) => card.value).toList();
    final suits = _selectedCards.map((card) => card.suit).toList();
    final numericValues = _selectedCards.map((card) => card.numericValue).toList()..sort();

    // Check for flush (all same suit)
    final isFlush = suits.toSet().length == 1;

    // Check for straight (consecutive values)
    bool isStraight = true;
    for (int i = 1; i < numericValues.length; i++) {
      if (numericValues[i] != numericValues[i - 1] + 1) {
        isStraight = false;
        break;
      }
    }

    // Special case for low straight (A-2-3-4-5)
    if (!isStraight && numericValues.contains(14)) {
      final lowStraightValues = numericValues.map((v) => v == 14 ? 1 : v).toList()..sort();
      isStraight = true;
      for (int i = 1; i < lowStraightValues.length; i++) {
        if (lowStraightValues[i] != lowStraightValues[i - 1] + 1) {
          isStraight = false;
          break;
        }
      }
    }

    // Count card ranks
    final rankCount = <String, int>{};
    for (final rank in ranks) {
      rankCount[rank] = (rankCount[rank] ?? 0) + 1;
    }

    final counts = rankCount.values.toList()..sort((a, b) => b.compareTo(a));

    // Determine combo
    if (isFlush && isStraight && numericValues.last == 14) {
      _currentCombo = 'Royal Flush';
    } else if (isFlush && isStraight) {
      _currentCombo = 'Straight Flush';
    } else if (counts[0] == 4) {
      _currentCombo = 'Four of a Kind';
    } else if (counts[0] == 3 && counts[1] == 2) {
      _currentCombo = 'Full House';
    } else if (isFlush) {
      _currentCombo = 'Flush';
    } else if (isStraight) {
      _currentCombo = 'Straight';
    } else if (counts[0] == 3) {
      _currentCombo = 'Three of a Kind';
    } else if (counts[0] == 2 && counts[1] == 2) {
      _currentCombo = 'Two Pair';
    } else if (counts[0] == 2) {
      _currentCombo = 'One Pair';
    } else {
      _currentCombo = 'High Card: ${_getHighCardName(numericValues.last)}';
    }

    // Save to history
    _saveToHistory();
    notifyListeners();
  }

  String _getHighCardName(int value) {
    switch (value) {
      case 14: return 'Ace';
      case 13: return 'King';
      case 12: return 'Queen';
      case 11: return 'Jack';
      default: return value.toString();
    }
  }

  void _saveToHistory() {
    final history = HistoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      combo: _currentCombo,
      cards: _selectedCards.map((card) => card.code).toList(),
    );
    _historyBox.add(history);
  }

  void deleteHistoryItem(String id) {
    final index = _historyBox.values.toList().indexWhere((item) => item.id == id);
    if (index != -1) {
      _historyBox.deleteAt(index);
      notifyListeners();
    }
  }
}