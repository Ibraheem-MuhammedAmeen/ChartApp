import 'package:flutter/material.dart';

import '../helpers.dart';
import '../widgets/avatar.dart';

class CallsPage extends StatelessWidget {
  const CallsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Calls',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Avatar.small(url: Helpers.randomPictureUrl()),
          ),
        ],
      ),
      body: const Center(
        child: Text('Calls Page'),
      ),
    );
  }
}
