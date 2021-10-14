import 'package:flutter/material.dart';

class TagsList extends StatefulWidget {
  const TagsList() : super();

  @override
  _TagsListState createState() => _TagsListState();
}

class _TagsListState extends State<TagsList> {
  bool value = false;
  List<Chip> tagList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Etiquetas"),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView(
              children: [
                //...tagList.map(buildSingleTagCheckbox).toList()
              ],
            ),
            TextButton(onPressed: () {}, child: Text("Aceptar")),
          ],
        ),
      ),
    );
  }
}
