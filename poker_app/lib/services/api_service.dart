import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/card_model.dart';

class ApiService {
  static const String _baseUrl = 'https://deckofcardsapi.com/api/deck/';

  Future<List<CardModel>> getNewDeck() async {
    try {
      final response = await http.get(Uri.parse('${_baseUrl}new/draw/?count=52'));


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<CardModel> cards = (data['cards'] as List)
            .map((card) => CardModel.fromJson(card))
            .toList();

        // Urutkan kartu secara manual
        cards.sort((a, b) {
          // Urutkan berdasarkan suit dulu, kemudian nilai
          final suitOrder = {'SPADES': 1, 'HEARTS': 2, 'DIAMONDS': 3, 'CLUBS': 4};
          final aSuit = suitOrder[a.suit] ?? 0;
          final bSuit = suitOrder[b.suit] ?? 0;

          if (aSuit != bSuit) return aSuit.compareTo(bSuit);
          return a.numericValue.compareTo(b.numericValue);
        });

        return cards;
      }
      throw Exception('Failed to load cards');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}