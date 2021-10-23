import 'package:eventy_front/components/pages/my_events/event_card.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/services/events_service.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class MyEvents extends StatefulWidget {
  const MyEvents() : super();

  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> with TickerProviderStateMixin {
  List<Event> eventHistory = [];
  bool hasResponse = false;

  late TabController _tabController;
  final List<Widget> myTabs = [
    Tab(text: 'Historial'),
    Tab(text: 'Eventos actuales'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    EventService().getHistory().then((value) {
      setState(() {
        eventHistory = value;
        hasResponse = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (context, boolean) {
          return [
            SliverToBoxAdapter(
              child: TabBar(
                indicator: MaterialIndicator(
                  color: Theme.of(context).primaryColor,
                  horizontalPadding: 80,
                  topLeftRadius: 20,
                  topRightRadius: 20,
                  paintingStyle: PaintingStyle.fill,
                ),
                labelColor: Colors.black87,
                controller: _tabController,
                isScrollable: false,
                tabs: myTabs,
              ),
            ),
          ];
        },
        body: Container(
            child: TabBarView(
                controller: _tabController,
                children: [buildTabHistory(), buildTabCurrent()])));
/*     return (!hasResponse)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : (hasResponse && eventHistory.length > 0)
            ? ListView.separated(
                itemCount: eventHistory.length,
                itemBuilder: (context, index) {
                  return EventCard(eventHistory[index]);
                },
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(),
                ),
              )
            : Center(
                child: Text("No has asistido a ningún evento"),
              ); */
  }

  Widget buildTabHistory() {
    return (!hasResponse)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : (hasResponse && eventHistory.length > 0)
            ? ListView.separated(
                itemCount: eventHistory.length,
                itemBuilder: (context, index) {
                  return EventCard(eventHistory[index]);
                },
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(),
                ),
              )
            : Center(
                child: Text("No has asistido a ningún evento"),
              );
  }

  Widget buildTabCurrent() {
    return Center(
      child: Text("No hay eventos próximos"),
    );
  }
}
