import 'dart:convert';
import 'package:flutter/material.dart';

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

class JSONVisualizer extends StatefulWidget {
  @override
  _JSONVisualizerState createState() => _JSONVisualizerState();
}

class _JSONVisualizerState extends State<JSONVisualizer> {
  String jsonInput = '';
  Map<String, dynamic> jsonData = {};
  Map<String, bool> expanded = {};

  @override
  void initState() {
    super.initState();
  }

  void parseJSON() {
    try {
      jsonData = json.decode(jsonInput);
    } catch (e) {
      print('Invalid JSON: $e');
      jsonData = {};
    }
  }

  Widget buildNestedJson(Map<String, dynamic> data) {
    List<Widget> children = [];
    data.forEach((key, value) {
      if (value is Map) {
        bool isExpanded = expanded[key] ?? false;

        children.add(ListTile(
          title: Text('$key :'),
          trailing:
              Icon(isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
          onTap: () {
            setState(() {
              expanded[key] = !isExpanded;
            });
          },
        ));

        if (isExpanded) {
          children.add(buildNestedJson(value as Map<String, dynamic>));
        }
      } else {
        children.add(ListTile(
          title: Text('$key : ${value is Map ? key : jsonEncode(value)}'),
        ));
      }
    });

    return Column(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                maxLines: null, // Allow multiple lines of input
                decoration: InputDecoration(labelText: 'Enter JSON Data'),
                onChanged: (value) {
                  setState(() {
                    jsonInput = value;
                    parseJSON();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildNestedJson(jsonData),
            ),
          ],
        ),
      ),
    );
  }
}
