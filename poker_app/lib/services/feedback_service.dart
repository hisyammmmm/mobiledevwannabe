import 'package:hive/hive.dart';
import 'package:poker_app/models/feedback_model.dart';

class FeedbackService {
  late Box<AppFeedback> _feedbackBox;

  Future<void> init() async {
    _feedbackBox = await Hive.openBox<AppFeedback>('feedback');
  }

  Future<void> addFeedback({
    required String username,
    required int rating,
    required String comment,
  }) async {
    final feedback = AppFeedback(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: username,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );
    await _feedbackBox.add(feedback);
  }

  // Get all feedback
  List<AppFeedback> getAllFeedback() {
    return _feedbackBox.values.toList();
  }

  // Update feedback
  Future<void> updateFeedback({
    required String id,
    required String currentUsername,
    required int newRating,
    required String newComment,
  }) async {
    final feedback = _feedbackBox.values.firstWhere(
          (f) => f.id == id,
      orElse: () => throw Exception('Feedback tidak ditemukan'),
    );

    // Validasi kepemilikan
    if (feedback.username != currentUsername) {
      throw Exception('Anda tidak memiliki izin untuk mengedit ulasan ini');
    }

    await _feedbackBox.put(
      _feedbackBox.keyAt(_feedbackBox.values.toList().indexWhere((f) => f.id == id)),
      AppFeedback(
        id: feedback.id,
        username: feedback.username,
        rating: newRating,
        comment: newComment,
        createdAt: feedback.createdAt,
      ),
    );
  }

  Future<void> deleteFeedback({
    required String id,
    required String currentUsername,
  }) async {
    final feedback = _feedbackBox.values.firstWhere(
          (f) => f.id == id,
      orElse: () => throw Exception('Feedback tidak ditemukan'),
    );

    if (feedback.username != currentUsername) {
      throw Exception('Anda tidak memiliki izin untuk menghapus ulasan ini');
    }

    await _feedbackBox.delete(
      _feedbackBox.keyAt(_feedbackBox.values.toList().indexWhere((f) => f.id == id)),
    );
  }

  double getAverageRating() {
    if (_feedbackBox.isEmpty) return 0;
    return _feedbackBox.values.map((f) => f.rating).reduce((a, b) => a + b) / _feedbackBox.length;
  }
}