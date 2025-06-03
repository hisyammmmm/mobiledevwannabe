import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:poker_app/models/card_model.dart';
import 'package:poker_app/services/api_service.dart';
import 'package:poker_app/services/combo_service.dart';

class CardSelectionScreen extends StatefulWidget {
  @override
  _CardSelectionScreenState createState() => _CardSelectionScreenState();
}

class _CardSelectionScreenState extends State<CardSelectionScreen> {
  late Future<List<CardModel>> _cardsFuture;
  bool _isLoading = false;
  List<CardModel> _allCards = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _cardsFuture = _loadCards();
  }

  Future<List<CardModel>> _loadCards() async {
    setState(() => _isLoading = true);
    try {
      final cards = await ApiService().getNewDeck();
      _allCards = cards;
      return cards;
    } catch (e) {
      throw Exception('Failed to load cards: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<CardModel> _filterCards() {
    if (_searchQuery.isEmpty) return _allCards;
    return _allCards.where((card) {
      final value = card.value.toLowerCase();
      final suit = card.suit.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return value.contains(query) || suit.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final comboService = Provider.of<ComboService>(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey.shade50,
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
      ),
      child: Column(
        children: [
          // Custom Loading Indicator
          if (_isLoading)
            Container(
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.purple.shade300],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
              child: LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
              ),
            ),

          // Enhanced Search Field
          Container(
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari kartu (contoh: king, heart)',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 16,
                ),
                prefixIcon: Container(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade400,
                    size: 24,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
              ),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Enhanced Selected Cards Section
          if (comboService.selectedCards.isNotEmpty)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.style_rounded,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Kartu Terpilih (${comboService.selectedCards.length})',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: comboService.selectedCards.length,
                      itemBuilder: (context, index) {
                        final card = comboService.selectedCards[index];
                        return GestureDetector(
                          onTap: () => comboService.removeCard(card),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: card.image,
                                      height: 80,
                                      width: 56,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        height: 80,
                                        width: 56,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              Colors.grey.shade400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${card.value} ${card.suit}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: 16),

          // Enhanced Card Grid
          Expanded(
            child: FutureBuilder<List<CardModel>>(
              future: _cardsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.shade100,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            color: Colors.red.shade400,
                            size: 48,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(
                              color: Colors.red.shade600,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: Container(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue.shade400,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Memuat kartu...',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final filteredCards = _filterCards();

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredCards.length,
                    itemBuilder: (context, index) {
                      final card = filteredCards[index];
                      final isSelected = comboService.selectedCards.contains(card);

                      return GestureDetector(
                        onTap: () {
                          isSelected
                              ? comboService.removeCard(card)
                              : comboService.selectCard(card);
                        },
                        child: CardWidget(card: card, isSelected: isSelected),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final CardModel card;
  final bool isSelected;

  const CardWidget({
    required this.card,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? Colors.blue.shade200.withOpacity(0.6)
                : Colors.grey.shade300.withOpacity(0.5),
            blurRadius: isSelected ? 12 : 8,
            offset: Offset(0, isSelected ? 6 : 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? Colors.blue.shade300
                    : Colors.grey.shade200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: card.image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.error_outline_rounded,
                      color: Colors.grey.shade400,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ),

          if (isSelected)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade500,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade200,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),

          // Subtle overlay for better visual feedback
          if (isSelected)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue.shade500.withOpacity(0.1),
              ),
            ),
        ],
      ),
    );
  }
}