import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_viewer/json_visualizer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('JSON Visualizer'),
        ),
        body: JSONVisualizer(),
      ),
    );
  }
}

