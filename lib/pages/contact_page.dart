import 'package:chatter/helpers.dart';
import 'package:chatter/widgets/avatar.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Contacts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Avatar.small(url: Helpers.randomPictureUrl()),
          ),
        ],
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Contact Page'),
      ),
    );
  }
}
