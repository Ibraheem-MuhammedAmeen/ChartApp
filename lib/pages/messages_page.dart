import 'package:chatter/widgets/icon_buttons.dart';
import 'package:flutter/material.dart';

import '../helpers.dart';
import '../theme.dart';
import '../widgets/avatar.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Messages',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        leading: Align(
          alignment: Alignment.centerRight,
          child: IconBackground(
            icon: Icons.search,
            onTap: () {},
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Avatar.small(url: Helpers.randomPictureUrl()),
          ),
        ],
      ),
      body: Card(
        color: Color(0xFF7F7FF),
        margin: const EdgeInsets.all(8),
        elevation: 0,
        child: SizedBox(
          height: 134,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Stories',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: AppColors.textFaded,
                ),
              ),
              Expanded(
                  child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Text('texing');
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
