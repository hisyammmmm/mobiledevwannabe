class CardModel {
  final String code;
  final String value;
  final String suit;
  final String image;

  CardModel({
    required this.code,
    required this.value,
    required this.suit,
    required this.image,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      code: json['code'],
      value: json['value'],
      suit: json['suit'],
      image: json['image'],
    );
  }

  int get numericValue {
    switch (value) {
      case 'ACE': return 14;
      case 'KING': return 13;
      case 'QUEEN': return 12;
      case 'JACK': return 11;
      default: return int.tryParse(value) ?? 0;
    }
  }
}