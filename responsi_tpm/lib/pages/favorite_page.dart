import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../utils/favorites_manager.dart';
import '../widgets/movie_card.dart';
import 'detail_page.dart';
import '../models/movie.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<String> favoriteIds = [];

  void loadFavorites() async {
    final favs = await FavoritesManager.getFavorites();
    setState(() => favoriteIds = favs);
  }

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Movies')),
      body: FutureBuilder<List<Movie>>(
        future: MovieService.fetchMovies(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final movies = snapshot.data!
                .where((movie) => favoriteIds.contains(movie.id))
                .toList();

            if (movies.isEmpty) return Center(child: Text("No favorites yet"));

            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) => MovieCard(
                movie: movies[index],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(id: movies[index].id),
                  ),
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
