import 'package:eventy_front/components/pages/my_events/map_view.dart';
import 'package:eventy_front/components/pages/search/community_search_result.dart';
import 'package:eventy_front/components/pages/search/search_result.dart';
import 'package:eventy_front/components/widgets/filled_button.dart';
import 'package:eventy_front/objects/community.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/services/communities_service.dart';
import 'package:eventy_front/services/events_service.dart';
import 'package:eventy_front/services/tags_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

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
  String searchHint = "Encuentra eventos y comunidades a tu gusto";
  List<bool> _selectedSearch = [true, false];
  bool advancedFilters = false;
  bool uniqueDay = false;
  DateTime minDate = DateTime.now();
  DateTime maxDate = DateTime.now();
  bool _priceRange = false;
  RangeValues _priceRangeValues = RangeValues(0, 100);
  TextEditingController minDateController = TextEditingController();
  TextEditingController maxDateController = TextEditingController();
  LatLng? eventLocation;
  String hasLocation = "Sin seleccionar";
  IconData hasLocationIcon = Icons.place_rounded;

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
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "●  ${events.length} resultados",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: openBottomDrawer,
                      child: Text(
                        "Buscar",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: TextButton.styleFrom(primary: Colors.black54),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return SearchResult(events[index]);
                  },
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                ),
              ),
            ],
          );
        }
      } else {
        if (communities.length <= 0) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${communities.length} resultados",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: openBottomDrawer,
                      child: Text(
                        "Buscar",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: TextButton.styleFrom(primary: Colors.black54),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: communities.length,
                  itemBuilder: (context, index) {
                    return CommunitySearchResult(communities[index]);
                  },
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                ),
              ),
            ],
          );
        }
      }
    } else {
      return Column(
        children: [
          SizedBox(
            height: 130,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Image.asset('assets/images/search.png')),
          SizedBox(
            height: 60,
          ),
          Text(
            searchHint,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          FilledButton(
            text: "Comienza a buscar",
            onPressed: openBottomDrawer,
          ),
        ],
      );
    }
  }

  void openBottomDrawer() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                height: 600,
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
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
                                advancedFilters = false;
                              });
                            },
                            selectedColor: Colors.white,
                            fillColor: Colors.black,
                          ),
                        ]),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      key: ValueKey("search_textfield"),
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1)),
                        hintText: "Concierto, quedada...",
                      ),
                      onChanged: (text) {
                        setState(() {
                          searchText = _searchController.text;
                        });
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                        ...tagList.map((tag) {
                                          bool selected =
                                              filterTags.contains(tag);
                                          return FilterChip(
                                            label: Text(tag),
                                            selected: selected,
                                            side: BorderSide(
                                                color: Colors.black, width: 1),
                                            backgroundColor: Colors.transparent,
                                            labelStyle: (selected)
                                                ? TextStyle(color: Colors.white)
                                                : TextStyle(),
                                            checkmarkColor: (selected)
                                                ? Colors.white
                                                : Colors.black,
                                            selectedColor: Colors.black,
                                            onSelected: (bool selected) {
                                              setModalState(() {
                                                if (selected) {
                                                  filterTags.add(tag);
                                                } else {
                                                  filterTags.remove(tag);
                                                }
                                              });
                                            },
                                          );
                                        })
                                      ],
                                    ));
                                  } else
                                    return Center(
                                        child: CircularProgressIndicator());
                                }),
                            (searchEvents)
                                ? TextButton(
                                    onPressed: () {
                                      setModalState(() {
                                        advancedFilters = !advancedFilters;
                                      });
                                    },
                                    child: Text(
                                      "Filtros avanzados",
                                      style: TextStyle(color: Colors.black),
                                    ))
                                : SizedBox(
                                    height: 15,
                                  ),
                            Visibility(
                              visible: advancedFilters,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CheckboxListTile(
                                      title: Text("Día único"),
                                      value: uniqueDay,
                                      activeColor: Colors.black,
                                      onChanged: (value) {
                                        setModalState(() {
                                          uniqueDay = value!;
                                        });
                                      }),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                            readOnly: true,
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              DatePicker.showDateTimePicker(
                                                  context,
                                                  showTitleActions: true,
                                                  minTime: DateTime.now(),
                                                  maxTime: DateTime.now()
                                                      .add(Duration(days: 730)),
                                                  onChanged: (date) {
                                                print('change $date');
                                              }, onConfirm: (date) {
                                                print('confirm $date');
                                                setState(() {
                                                  final DateFormat formatter =
                                                      DateFormat('dd/MM/yyyy');
                                                  final String formatted =
                                                      formatter.format(date);
                                                  minDate = date;
                                                  minDateController.text =
                                                      formatted;
                                                });
                                              });
                                            },
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(Icons
                                                    .calendar_today_rounded),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        BorderSide.none),
                                                filled: true,
                                                hintText: "Mínima"),
                                            controller: minDateController),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextField(
                                            readOnly: true,
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              DatePicker.showDateTimePicker(
                                                  context,
                                                  showTitleActions: true,
                                                  minTime: DateTime.now(),
                                                  maxTime: DateTime.now()
                                                      .add(Duration(days: 730)),
                                                  onChanged: (date) {
                                                print('change $date');
                                              }, onConfirm: (date) {
                                                print('confirm $date');
                                                setState(() {
                                                  final DateFormat formatter =
                                                      DateFormat('dd/MM/yyyy');
                                                  final String formatted =
                                                      formatter.format(date);
                                                  maxDate = date;
                                                  maxDateController.text =
                                                      formatted;
                                                });
                                              });
                                            },
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(Icons
                                                    .calendar_today_rounded),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        BorderSide.none),
                                                filled: true,
                                                hintText: "Máxima"),
                                            controller: maxDateController),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Rango de precios",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      Checkbox(
                                          activeColor: Colors.black,
                                          value: _priceRange,
                                          onChanged: (value) {
                                            setModalState(() {
                                              _priceRange = value!;
                                            });
                                          })
                                    ],
                                  ),
                                  RangeSlider(
                                      inactiveColor: Colors.black12,
                                      activeColor: Colors.black,
                                      values: _priceRangeValues,
                                      min: 0,
                                      max: 100,
                                      divisions: 20,
                                      labels: RangeLabels(
                                        _priceRangeValues.start
                                            .round()
                                            .toString(),
                                        _priceRangeValues.end
                                            .round()
                                            .toString(),
                                      ),
                                      onChanged: (_priceRange)
                                          ? (values) {
                                              setModalState(() {
                                                _priceRangeValues = values;
                                              });
                                            }
                                          : null),
                                  buildMapPicker(context, setModalState)
                                ],
                              ),
                            ),
                            ElevatedButton(
                                key: ValueKey("search_button"),
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity,
                                        40), // double.infinity is the width and 30 is the height
                                    elevation: 0,
                                    primary: Colors.black,
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                onPressed: search,
                                child: Text("Buscar")),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void search() {
    setState(() {
      events = [];
      communities = [];
      searching = true;
    });
    Map<String, dynamic> filters = {};
    if (searchEvents) {
      if (advancedFilters) {
        if (uniqueDay) {
          filters['unique'] = true;
        }
        if (minDateController.text != "") {
          filters['sDate'] = minDate.toIso8601String();
        }
        if (maxDateController.text != "") {
          filters['fDate'] = maxDate.toIso8601String();
        }
        if (_priceRange) {
          filters['priceMin'] = _priceRangeValues.start;
          filters['price'] = _priceRangeValues.end;
        }
        if (eventLocation != null) {
          filters['lat'] = eventLocation!.latitude;
          filters['long'] = eventLocation!.longitude;
        }
      }
      EventService()
          .search(searchText, filterTags, filters)
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
  }

  Widget buildMapPicker(BuildContext context, StateSetter setModalState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ubicación",
          style: TextStyle(color: Colors.black54),
        ),
        Row(
          children: [
            Icon(
              hasLocationIcon,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              hasLocation,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            Spacer(),
            TextButton(
              child: Text(
                "Cambiar",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              onPressed: () {
                showPlacePicker(context, setModalState);
              },
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  void showPlacePicker(BuildContext context, StateSetter setModalState) async {
    LatLng? result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MapPositionSelector()));
    if (result != null) {
      setModalState(() {
        eventLocation = result;
        hasLocation = "Seleccionada";
        hasLocationIcon = Icons.done_rounded;
      });
    }
  }
}
