import 'package:flutter/material.dart';
import 'package:rakuten_task/message_screen.dart';
import 'package:rakuten_task/phone_dialer_screen.dart';
import 'package:rakuten_task/youtube_screen.dart';

void main() {
  runApp(MaterialApp(home: HomeScreen()));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Dialer"),
              Tab(text: "Message"),
              Tab(text: "YouTube"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [PhoneDialer(), MessageScreen(), YoutubeScreen()],
        ),
      ),
    );
  }
}
