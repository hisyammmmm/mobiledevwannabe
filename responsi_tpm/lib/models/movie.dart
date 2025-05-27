class Movie {
  final String id;
  final String title;
  final String imgUrl;
  final double rating;
  final List<String> genre;
  final String duration;
  final String releaseDate;
  final String description;
  final String director;
  final List<String> cast;
  final String language;

  Movie({
    required this.id,
    required this.title,
    required this.imgUrl,
    required this.rating,
    required this.genre,
    required this.duration,
    required this.releaseDate,
    required this.description,
    required this.director,
    required this.cast,
    required this.language,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      imgUrl: json['imgUrl'],
      rating: double.parse(json['rating'].toString()),
      genre: List<String>.from(json['genre']),
      duration: json['duration'],
      releaseDate: json['release_date'],
      description: json['description'],
      director: json['director'],
      cast: List<String>.from(json['cast']),
      language: json['language'],
    );
  }
}
