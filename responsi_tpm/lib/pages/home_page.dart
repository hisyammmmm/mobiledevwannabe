import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';
import 'detail_page.dart';
import 'favorite_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie List'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FavoritePage()),
            ),
          )
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: MovieService.fetchMovies(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final movies = snapshot.data!;
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
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading movies'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
