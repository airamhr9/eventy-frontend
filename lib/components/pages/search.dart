import 'package:eventy_front/services/tags_service.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final _SearchState searchState = _SearchState();

  @override
  _SearchState createState() {
    return searchState;
  }
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  List<String> filterTags = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: [SingleChildScrollView()],
      ),
    );
  }

  void openBottomDrawer() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                height: 490,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search_rounded),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          filled: true,
                          hintText: "Concierto, quedada..."),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Preferencias",
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    FutureBuilder(
                        future: TagsService().get(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            List<String> tagList =
                                snapshot.data as List<String>;
                            return Container(
                                child: Wrap(
                              spacing: 5,
                              runSpacing: 3,
                              children: [
                                ...tagList.map((tag) => FilterChip(
                                      label: Text(tag),
                                      selected: filterTags.contains(tag),
                                      selectedColor: Colors.lightBlue[100],
                                      onSelected: (bool selected) {
                                        setModalState(() {
                                          if (selected) {
                                            filterTags.add(tag);
                                          } else {
                                            filterTags.remove(tag);
                                          }
                                        });
                                      },
                                    ))
                              ],
                            ));
                          } else
                            return Center(child: CircularProgressIndicator());
                        }),
                    Spacer(),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity,
                                40), // double.infinity is the width and 30 is the height
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        onPressed: () {},
                        child: Text("Buscar"))
                  ],
                ),
              );
            },
          );
        });
  }
}
