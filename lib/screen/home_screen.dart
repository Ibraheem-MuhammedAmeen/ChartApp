import 'package:chatter/pages/calls_page.dart';
import 'package:chatter/pages/contact_page.dart';
import 'package:chatter/pages/messages_page.dart';
import 'package:chatter/pages/notifications_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final pages = const [
    MessagesPage(),
    NotificationsPages(),
    CallsPage(),
    ContactPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[0],
      bottomNavigationBar: _BottomNavigationBar(),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavigationBarItem(
              label: 'Messages', icon: CupertinoIcons.bubble_left_bubble_right),
          NavigationBarItem(
              label: 'Notifications', icon: CupertinoIcons.bell_solid),
          NavigationBarItem(label: 'Calls', icon: CupertinoIcons.phone_fill),
          NavigationBarItem(
              label: 'Contacts', icon: CupertinoIcons.person_2_fill),
        ],
      ),
    );
  }
}

class NavigationBarItem extends StatelessWidget {
  const NavigationBarItem({
    super.key,
    required this.label,
    required this.icon,
  });
  final String label;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            '$label',
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
