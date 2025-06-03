import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poker_app/services/auth_service.dart';
import 'package:poker_app/services/combo_service.dart';
import 'package:poker_app/views/home/card_selection_screen.dart';
import 'package:poker_app/views/home/combo_result_screen.dart';
import 'package:poker_app/views/home/history_screen.dart';
import 'package:poker_app/views/auth/login_screen.dart';
import 'package:poker_app/widgets/feedback_dialog.dart';
import 'package:poker_app/views/feedback/feedback_list_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Poker Combo Checker'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'view_feedback':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FeedbackListScreen()),
                  );
                  break;
                case 'send_feedback':
                  showFeedbackDialog(context);
                  break;
                case 'history':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HistoryScreen()),
                  );
                  break;
                case 'logout':
                  final authService = Provider.of<AuthService>(context, listen: false);
                  await authService.logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                        (route) => false,
                  );
                  break;
              }
            },
            icon: Icon(Icons.more_vert), // Icon dropdown
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'view_feedback',
                child: ListTile(
                  leading: Icon(Icons.feedback),
                  title: Text('Lihat Feedback'),
                ),
              ),
              PopupMenuItem(
                value: 'send_feedback',
                child: ListTile(
                  leading: Icon(Icons.feedback_outlined),
                  title: Text('Kirim Feedback'),
                ),
              ),
              PopupMenuItem(
                value: 'history',
                child: ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Riwayat'),
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome, ${authService.username}!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: CardSelectionScreen(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<ComboService>(
              builder: (context, comboService, _) {
                return ElevatedButton(
                  onPressed: comboService.selectedCards.length == 5
                      ? () {
                    comboService.checkCombo();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ComboResultScreen(),
                      ),
                    );
                  }
                      : null,
                  child: Text('Check Combo (${comboService.selectedCards.length}/5)'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}