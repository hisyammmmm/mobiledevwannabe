// widgets/feedback_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poker_app/services/auth_service.dart';
import 'package:poker_app/services/feedback_service.dart';

void showFeedbackDialog(BuildContext context) {
  final authService = Provider.of<AuthService>(context, listen: false);
  final feedbackService = Provider.of<FeedbackService>(context, listen: false);

  int rating = 0;
  final commentController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Beri Rating Aplikasi'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Berikan bintang untuk aplikasi kami:'),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          rating = index + 1;
                        });
                      },
                    );
                  }),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    labelText: 'Komentar (opsional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (rating == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Harap berikan rating')),
                    );
                    return;
                  }

                  await feedbackService.addFeedback(
                    username: authService.username,
                    rating: rating,
                    comment: commentController.text,
                  );

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Terima kasih atas feedback Anda!')),
                  );
                },
                child: Text('Kirim'),
              ),
            ],
          );
        },
      );
    },
  );
}