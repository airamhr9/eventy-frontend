import 'package:eventy_front/components/pages/search/community_search_result.dart';
import 'package:eventy_front/components/pages/search/search_result.dart';
import 'package:eventy_front/objects/community.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/services/communities_service.dart';
import 'package:eventy_front/services/events_service.dart';
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
  String searchText = "";
  List<String> filterTags = [];
  List<Event> events = [];
  List<Community> communities = [];
  bool searching = false;
  String searchHint = "Busca eventos";
  List<bool> _selectedSearch = [true, false];
  List<Widget> _toggleButtons = [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text("Eventos"),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text("Comunidades"),
    )
  ];
  bool searchEvents = true;

  @override
  Widget build(BuildContext context) {
    if (searching) {
      if (searchEvents) {
        if (events.length <= 0) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            itemCount: events.length,
            itemBuilder: (context, index) {
              return SearchResult(events[index]);
            },
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(),
            ),
          );
        }
      } else {
        if (communities.length <= 0) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            itemCount: communities.length,
            itemBuilder: (context, index) {
              return CommunitySearchResult(communities[index]);
            },
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(),
            ),
          );
        }
      }
    } else {
      return Center(
        child: Text(
          searchHint,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      );
    }
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
                height: 550,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ToggleButtons(
                            children: _toggleButtons,
                            isSelected: _selectedSearch,
                            onPressed: (index) {
                              setModalState(() {
                                _selectedSearch = [false, false];
                                _selectedSearch[index] = true;
                              });
                              setState(() {
                                searching = false;
                                searchEvents = !searchEvents;
                                if (!searchEvents)
                                  searchHint = "Busca comunidades";
                              });
                            },
                            borderRadius: BorderRadius.circular(15),
                            selectedColor: Colors.white,
                            fillColor: Theme.of(context).primaryColor,
                          ),
                        ]),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        filled: true,
                        hintText: "Concierto, quedada...",
                      ),
                      onChanged: (text) {
                        setState(() {
                          searchText = _searchController.text;
                        });
                      },
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
                                        setState(() {
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
                        onPressed: () {
                          setState(() {
                            events = [];
                            communities = [];
                            searching = true;
                          });
                          if (searchEvents) {
                            EventService()
                                .search(searchText, filterTags)
                                .then((value) => setState(() {
                                      events = value;
                                      if (events.length == 0) {
                                        searching = false;
                                        searchHint =
                                            "No hay eventos que coincidan con los criterios de búsqueda";
                                      }
                                    }));
                          } else {
                            CommunityService()
                                .search(searchText, filterTags)
                                .then((value) => setState(() {
                                      communities = value;
                                      if (communities.length == 0) {
                                        searching = false;
                                        searchHint =
                                            "No hay comunidades que coincidan con los criterios de búsqueda";
                                      }
                                    }));
                          }
                          Navigator.pop(context);
                        },
                        child: Text("Buscar"))
                  ],
                ),
              );
            },
          );
        });
  }
}
