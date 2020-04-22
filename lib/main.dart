import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text("Flutter"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: Text("Chart"),
          ),
          Card(
            child: Text("List of Tx"),
          ),
        ],
      ),
    );
  }
}
