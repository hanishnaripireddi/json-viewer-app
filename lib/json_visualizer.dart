import 'dart:convert';
import 'package:flutter/material.dart';

class JSONVisualizer extends StatefulWidget {
  const JSONVisualizer({super.key});

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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                height: 300, // Set the height to 300 pixels
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  maxLines: null, // Allow multiple lines of input
                  decoration: InputDecoration(labelText: 'Enter JSON Data',border: InputBorder.none),
                  onChanged: (value) {
                    setState(() {
                      jsonInput = value;
                      parseJSON();
                    });
                  },
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: buildNestedJson(jsonData),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
