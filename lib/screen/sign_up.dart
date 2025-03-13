import 'package:chatter/screen/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    as stream;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isloading = false;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredNumber = '';
  var _enteredName = '';

  void _submit() async {
    setState(() {
      _isloading = true;
    });
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    _formKey.currentState!.save();
    try {
      // Create the user with email and password
      UserCredential userCredential =
          await _firebase.createUserWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredPassword,
      );

      // Get the created user
      User? user = userCredential.user;

      if (user != null) {
        final client = stream.StreamChatCore.of(context).client;
        String userToken = client.devToken(user.uid).rawValue;
        // Update user profile with phone number
        await user
            .updateDisplayName(_enteredNumber); // This is just a workaround

        // (Optional) Store the phone number,email and name in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': _enteredEmail,
          'phone': _enteredNumber,
          'Name': _enteredName,
          'token': userToken,
        });
        print('token' + userToken);
        print(user);
      }
      setState(() {
        _isloading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
      setState(() {
        _isloading = false;
      });
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Signup failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: (_isloading)
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      width: 200,
                      child: Image.asset('assets/images/chat.png'),
                    ),
                    Card(
                      margin: const EdgeInsets.all(20),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Name'),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Enter a valid Name';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _enteredName = value!,
                              ),
                              TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Email'),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || !value.contains('@')) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _enteredEmail = value!,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Password'),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.length < 6) {
                                    return 'Password too short';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _enteredPassword = value!,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Phone No',
                                ),
                                //obscureText: true,
                                keyboardType: TextInputType
                                    .phone, // Ensures a numeric keypad
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  } else if (!RegExp(r'^\d{10,15}$')
                                      .hasMatch(value)) {
                                    return 'Enter a valid phone number';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _enteredNumber = value!,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .black12, // Change to your desired color
                                      foregroundColor:
                                          Colors.white, // Text color
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 24), // Adjust padding
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // Rounded corners
                                      ),
                                    ),
                                    onPressed: _submit,
                                    child: const Text('Signup'),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor:
                                          Colors.blue, // Text color
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/login');
                                    },
                                    child:
                                        const Text('already have an account'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
