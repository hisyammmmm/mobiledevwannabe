class SiteModel {
  final int id;
  final String name;
  final String url;
  final String imageUrl;
  bool isFavorite;

  SiteModel({
    required this.id,
    required this.name,
    required this.url,
    required this.imageUrl,
    this.isFavorite = false,
  });

  factory SiteModel.fromMap(Map<String, dynamic> map) {
    return SiteModel(
      id: map['id'],
      name: map['name'],
      url: map['url'],
      imageUrl: map['imageUrl'],
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}

List<SiteModel> siteRecommendations = [
  SiteModel(
    id: 1,
    name: "Google",
    url: "https://www.google.com",
    imageUrl: "https://www.google.com/favicon.ico",
  ),
  SiteModel(
    id: 2,
    name: "Telegram",
    url: "https://web.telegram.org",
    imageUrl: "https://web.telegram.org/favicon.ico",
  ),
  SiteModel(
    id: 3,
    name: "Facebook",
    url: "https://www.facebook.com",
    imageUrl: "https://www.facebook.com/favicon.ico",
  ),
  SiteModel(
    id: 4,
    name: "Instagram",
    url: "https://www.instagram.com",
    imageUrl: "https://www.instagram.com/favicon.ico",
  ),
  SiteModel(
    id: 5,
    name: "X",
    url: "https://x.com",
    imageUrl: "https://www.google.com/s2/favicons?sz=64&domain=x.com",
  ),
  SiteModel(
    id: 6,
    name: "LinkedIn",
    url: "https://www.linkedin.com",
    imageUrl: "https://www.linkedin.com/favicon.ico",
  ),
  SiteModel(
    id: 7,
    name: "GitHub",
    url: "https://github.com",
    imageUrl: "https://github.githubassets.com/favicon.ico",
  ),
  SiteModel(
    id: 8,
    name: "YouTube",
    url: "https://www.youtube.com",
    imageUrl: "https://www.youtube.com/favicon.ico",
  ),
  SiteModel(
    id: 9,
    name: "Line",
    url: "https://line.me",
    imageUrl: "https://line.me/favicon.ico",
  ),
  SiteModel(
    id: 10,
    name: "TikTok",
    url: "https://www.tiktok.com",
    imageUrl: "https://www.tiktok.com/favicon.ico",
  ),
];
