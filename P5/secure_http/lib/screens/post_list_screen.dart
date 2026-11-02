import 'package:flutter/material.dart';

class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Post'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Halaman Daftar Post',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}