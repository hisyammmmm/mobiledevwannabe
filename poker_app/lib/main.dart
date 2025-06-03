import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:poker_app/models/history_model.dart';
import 'package:poker_app/services/local_storage_service.dart';
import 'package:poker_app/services/auth_service.dart';
import 'package:poker_app/services/combo_service.dart';
import 'package:poker_app/views/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:poker_app/models/feedback_model.dart';
import 'package:poker_app/services/feedback_service.dart';
import 'package:poker_app/views/home/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(HistoryModelAdapter());
  Hive.registerAdapter(AppFeedbackAdapter());

  final authService = AuthService();
  final feedbackService = FeedbackService();

  await Future.wait([
    Hive.openBox<HistoryModel>('history'),
    Hive.openBox<AppFeedback>('feedback'),
    authService.autoLogin(),
    feedbackService.init(),
    LocalStorageService.init(), // Don't forget to initialize this if you're using it
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authService),
        ChangeNotifierProvider(create: (_) => ComboService()),
        Provider(create: (_) => feedbackService),
      ],
      child: const MyApp(),
    ),
  );
}

// Define MyApp as a StatelessWidget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Poker App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Consumer<AuthService>(
        builder: (context, authService, _) {
          return authService.isLoggedIn ? MainScreen() : LoginScreen();
        },
      ),
    );
  }
}