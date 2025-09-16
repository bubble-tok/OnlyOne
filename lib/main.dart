import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'package:provider/provider.dart';
import 'providers/chat_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ChatProvider())],
      child: const OnlyOneApp(),
    ),
  );
}

class OnlyOneApp extends StatelessWidget {
  const OnlyOneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OnlyOne',
      theme: ThemeData(primarySwatch: Colors.purple),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
      },
      home: const LoginScreen(), // 로그인부터 시작
    );
  }
}
