import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../utils/favorites_manager.dart';

class DetailPage extends StatefulWidget {
  final String id;

  const DetailPage({required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isFavorite = false;

  void checkFavorite() async {
    final fav = await FavoritesManager.isFavorite(widget.id);
    setState(() => isFavorite = fav);
  }

  @override
  void initState() {
    super.initState();
    checkFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Movie'),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () async {
              if (isFavorite) {
                await FavoritesManager.removeFavorite(widget.id);
              } else {
                await FavoritesManager.addFavorite(widget.id);
              }
              checkFavorite();
            },
          )
        ],
      ),
      body: FutureBuilder<Movie>(
        future: MovieService.fetchMovieDetail(widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final movie = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.network(movie.imgUrl),
                  SizedBox(height: 16),
                  Text(movie.title, style: TextStyle(fontSize: 22)),
                  Text('Rating: ${movie.rating}'),
                  Text('Genre: ${movie.genre}'),
                  Text('Duration: ${movie.duration}'),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load details'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
