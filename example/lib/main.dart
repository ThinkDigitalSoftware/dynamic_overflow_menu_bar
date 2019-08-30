import 'package:dynamic_overflow_menu_bar/dynamic_overflow_menu_bar.dart';
import 'package:flutter/material.dart';

void main(List<String> arguments) {
  runApp(
    MaterialApp(
      title: "Dynamic Overflow Actions Bar Demo",
      home: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _titleTextController;
  @override
  void initState() {
    super.initState();
    _titleTextController = TextEditingController(text: "Title Text");
    _titleTextController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: DynamicOverflowMenuBar(
          title: Text(
            _titleTextController.text,
            softWrap: true,
          ),
          actions: <Widget>[
            IconButton(
              tooltip: "API",
              icon: Text(
                'API',
              ),
              onPressed: () {},
            ),
            IconButton(
              tooltip: "Repo",
              icon: Icon(
                Icons.code,
              ),
              onPressed: () {},
            ),
            IconButton(
              tooltip: "Issues",
              icon: Icon(
                Icons.bug_report,
              ),
              onPressed: () {},
            ),
            IconButton(
              tooltip: "Favorite",
              icon: Icon(
                Icons.favorite_border,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _titleTextController,
              decoration: InputDecoration(labelText: "AppBar Title"),
            ),
          )
        ],
      ),
    );
  }
}
