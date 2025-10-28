import 'package:flutter/material.dart';
import 'package:pomodoro_sczuw/utils/styles/app_text_styles.dart';
import 'package:pomodoro_sczuw/widgets/joke_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('from HOME PAGE', style: AppTextStyles.title)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(child: JokeWidget()),
      ),
    );
  }
}
