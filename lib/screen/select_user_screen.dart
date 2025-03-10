import 'dart:math';
import 'package:chatter/screen/login_screen.dart';
import 'package:chatter/widgets/getImage.dart';
import 'package:chatter/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    as stream;

import '../../../app.dart';
import 'home_screen.dart';

class SelectUserScreen extends StatefulWidget {
  static Route get route => MaterialPageRoute(
        builder: (context) => const SelectUserScreen(),
      );

  const SelectUserScreen({Key? key}) : super(key: key);

  @override
  _SelectUserScreenState createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  bool _loading = false;

  /// Fetch users from Firestore
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    var snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Handle user selection and login
  Future<void> onUserSelected(Map<String, dynamic> user) async {
    print("✅ Button tapped! User selected: ${user['name']}");

    setState(() {
      _loading = true;
    });

    try {
      final client = stream.StreamChatCore.of(context).client;
      await client.connectUser(
        stream.User(
          id: user['id'], // Ensure 'id' field exists in Firestore
          extraData: {
            'name': user['name'],
            'image': user['image'], // Ensure 'image' field exists
          },
        ),
        client.devToken(user['id']).rawValue,
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on Exception catch (e, st) {
      print('❌ Error: Could not connect user - $e');

      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: (_loading)
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text(
                            'Select a user',
                            style: TextStyle(fontSize: 24, letterSpacing: 0.4),
                          ),
                        ),
                        Spacer(),
                        Card(
                          child: IconButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              if (!mounted) return;

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            },
                            icon: const Icon(Icons.exit_to_app),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: fetchUsers(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No users found'));
                          }
                          var users = snapshot.data!;

                          return ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              var user = users[index];

                              return SelectUserButton(
                                user: user, // ✅ Pass Firestore user data
                                onPressed: onUserSelected,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

/// User Button Widget
class SelectUserButton extends StatelessWidget {
  const SelectUserButton({
    Key? key,
    required this.user,
    required this.onPressed,
  }) : super(key: key);

  final Map<String, dynamic> user;
  final Function(Map<String, dynamic>) onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () => onPressed(user),
        child: Row(
          children: [
            Avatar.large(
              url: Randimage, // ✅ Use Firestore image or random one
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                user['name'] ?? 'Unknown', // ✅ Ensure name is not null
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
