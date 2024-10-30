import 'package:flutter/material.dart';
import 'package:payapp/ui/widgets/app_bar_widget.dart';

class ComingSoonScreen extends StatelessWidget {
  final String title;

  const ComingSoonScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: title,
        size: 55,
      ),
      body: const Center(
        child: Text(
          "Coming Soon",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }
}
