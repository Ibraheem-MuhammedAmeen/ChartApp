import 'package:chatter/screen/select_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  bool _isloading = false;
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _submit() async {
    setState(() {
      _isloading = true;
    });
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      // Show Snackbar for invalid input
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill out all fields correctly!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _formKey.currentState!.save();
    try {
      await _firebase.signInWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredPassword,
      );
      setState(() {
        _isloading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SelectUserScreen(),
        ),
      );
      setState(() {
        _isloading = false;
      });
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Login failed')),
      );
      setState(() {
        _isloading = false;
      });
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
                              const SizedBox(height: 12),
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Colors.black12,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: _submit,
                                    child: const Text('Login'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/signup');
                                    },
                                    child: const Text(
                                      'Create an account',
                                      style: TextStyle(color: Colors.blue),
                                    ),
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
