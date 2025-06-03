import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poker_app/models/feedback_model.dart';
import 'package:poker_app/services/feedback_service.dart';
import 'package:poker_app/services/auth_service.dart';
import 'package:intl/intl.dart';

class FeedbackListScreen extends StatefulWidget {
  @override
  _FeedbackListScreenState createState() => _FeedbackListScreenState();
}

class _FeedbackListScreenState extends State<FeedbackListScreen> {
  late TextEditingController _commentController;
  int _currentRating = 0;
  String? _editingFeedbackId;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // Tampilkan dialog edit
  void _showEditDialog(AppFeedback feedback, String currentUsername) {
    _editingFeedbackId = feedback.id;
    _currentRating = feedback.rating;
    _commentController.text = feedback.comment;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Ulasan'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Update rating Anda:'),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      return IconButton(
                        icon: Icon(
                          i < _currentRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () => setState(() => _currentRating = i + 1),
                      );
                    }),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      labelText: 'Komentar',
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
                    try {
                      await Provider.of<FeedbackService>(context, listen: false).updateFeedback(
                        id: _editingFeedbackId!,
                        currentUsername: currentUsername,
                        newRating: _currentRating,
                        newComment: _commentController.text,
                      );
                      Navigator.pop(context);
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ulasan berhasil diperbarui')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                  child: Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Tampilkan konfirmasi delete
  void _showDeleteConfirmation(String feedbackId, String currentUsername) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Ulasan?'),
        content: Text('Anda yakin ingin menghapus ulasan ini? Tindakan tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<FeedbackService>(context, listen: false).deleteFeedback(
                  id: feedbackId,
                  currentUsername: currentUsername,
                );
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ulasan berhasil dihapus')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final feedbackService = Provider.of<FeedbackService>(context);
    final authService = Provider.of<AuthService>(context);
    final feedbacks = feedbackService.getAllFeedback()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      appBar: AppBar(
        title: Text('Ulasan Pengguna'),
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Rating Rata-rata'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 30),
                          SizedBox(width: 8),
                          Text(
                            feedbackService.getAverageRating().toStringAsFixed(1),
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('Dari ${feedbacks.length} ulasan', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Tutup'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: feedbacks.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.feedback, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text('Belum ada ulasan', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: feedbacks.length,
        itemBuilder: (context, index) {
          final feedback = feedbacks[index];
          final canEdit = feedback.username == authService.username;

          return Card(
            margin: EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(Icons.person, color: Colors.blue.shade800),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feedback.username,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 4),
                            Text(
                              DateFormat('dd MMM yyyy, HH:mm').format(feedback.createdAt),
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      if (canEdit) ...[
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showEditDialog(feedback, authService.username),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteConfirmation(feedback.id, authService.username),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: List.generate(5, (i) => Icon(
                      i < feedback.rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    )),
                  ),
                  SizedBox(height: 12),
                  if (feedback.comment.isNotEmpty)
                    Text(feedback.comment, style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}