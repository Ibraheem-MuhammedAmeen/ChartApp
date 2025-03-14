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
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter is ready before Firebase
  await Firebase.initializeApp(); // Initialize Firebase

  //creating an instance of StreamChatClient and passing it down the tree
  final client = StreamChatClient(streamkey);

  await Supabase.initialize(
    url:
        'https://nadeweensbspwoeufxbj.supabase.co', // ✅ Replace with your Supabase URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5hZGV3ZWVuc2JzcHdvZXVmeGJqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE4ODQ2MTMsImV4cCI6MjA1NzQ2MDYxM30.dZgacY--jlev7xtSqd8pLnxQcqE1GrwxEDNAwc8Ft40', // ✅ Replace with your Anon Key
  );
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
