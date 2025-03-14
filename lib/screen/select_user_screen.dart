import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    as stream;
import '../api_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

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

    return snapshot.docs.map((doc) {
      var data = doc.data();
      data['id'] = doc.id;
      data['profileImageUrl'] =
          data['profileImageUrl'] ?? ''; // Ensure no null values
      return data;
    }).toList();
  }

  Future<void> onUserSelected(Map<String, dynamic> user) async {
    setState(() {
      _loading = true;
    });

    try {
      final client = stream.StreamChatCore.of(context).client;
      final FirebaseAuth _firebase = FirebaseAuth.instance;

      String? userId = user['id'];
      if (userId == null || userId.isEmpty) {
        throw Exception("❌ User ID is missing!");
      }

      final tokenResponse = await ApiService.getToken(userId);

      if (tokenResponse == null || !tokenResponse.containsKey('token')) {
        throw Exception("❌ Failed to retrieve token for user $userId");
      }

      String userToken = tokenResponse['token']!;

      await client.connectUser(
        stream.User(
          id: userId,
          extraData: {'name': user['Name']},
        ),
        userToken,
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on Exception catch (e) {
      print('❌ Error: Could not connect user - $e');
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
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
                                user: user,
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
              url: user['profileImageUrl']!.isNotEmpty
                  ? user['profileImageUrl']
                  : 'https://via.placeholder.com/150', // Default if no image
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                user['Name'] ?? 'Unknown',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final String url;
  const Avatar.large({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundImage: url.isNotEmpty
          ? NetworkImage(url)
          : const AssetImage('assets/default_avatar.png') as ImageProvider,
    );
  }
}
