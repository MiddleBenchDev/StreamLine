import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:streamline/providers/auth_provider.dart';
import 'package:streamline/providers/playlist_provider.dart';
import 'package:streamline/providers/theme_provider.dart';
import 'package:streamline/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const LearningApp());
}

class LearningApp extends StatelessWidget {
  const LearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PlaylistProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Learning App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.themeMode,
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
