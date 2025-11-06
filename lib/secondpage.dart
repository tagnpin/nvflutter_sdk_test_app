import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  final Map<String, dynamic> nvResponseData;
  const SecondPage({super.key, required this.nvResponseData});
  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Second Page",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Text(widget.nvResponseData.toString()),
      ),
    );
  }
}
