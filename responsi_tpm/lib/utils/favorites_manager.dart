import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager {
  static const _key = 'favorite_movies';

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<void> addFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = await getFavorites();
    favs.add(id);
    await prefs.setStringList(_key, favs);
  }

  static Future<void> removeFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = await getFavorites();
    favs.remove(id);
    await prefs.setStringList(_key, favs);
  }

  static Future<bool> isFavorite(String id) async {
    final favs = await getFavorites();
    return favs.contains(id);
  }
}
