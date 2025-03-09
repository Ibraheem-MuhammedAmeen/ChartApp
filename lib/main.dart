import 'package:chatter/app.dart';
import 'package:chatter/screen/home_screen.dart';
import 'package:chatter/screen/login_screen.dart';
import 'package:chatter/screen/select_user_screen.dart';
import 'package:chatter/screen/sign_up.dart';
import 'package:chatter/theme.dart';
import 'package:chatter/widgets/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter is ready before Firebase
  await Firebase.initializeApp(); // Initialize Firebase

  final client = StreamChatClient(streamkey);

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.client,
  });
  final StreamChatClient client;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      builder: (context, child) {
        return StreamChatCore(
          client: client,
          child: child!,
        );
      },
      initialRoute: '/login',
      routes: {
        '/login': (ctx) => const LoginScreen(),
        '/signup': (ctx) => const SignupScreen(),
      },
      //home: const AuthScreen(),
    );
  }
}
//SelectUserScreen()
