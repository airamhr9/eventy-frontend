import 'package:eventy_front/components/pages/my_events/event_card.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/services/events_service.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class MyEvents extends StatefulWidget {
  final TabController _tabController;
  const MyEvents(this._tabController) : super();

  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> with TickerProviderStateMixin {
  List<Event> futureEvents = [];
  bool hasFutureEventsResponse = false;
  List<Event> eventHistory = [];
  bool hasResponse = false;
  List<Event> seeLater = [];
  bool seeLaterResponse = false;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future _fetchEvents() async {
    final eventsService = EventService();

    final results = await Future.wait([
      eventsService.getFutureEvents(),
      eventsService.getHistory(),
      eventsService.getSeeLaterEvents()
    ]);

    setState(() {
      futureEvents = results[0];
      hasFutureEventsResponse = true;
    });
    setState(() {
      eventHistory = results[1];
      hasResponse = true;
    });
    setState(() {
      seeLater = results[2];
      seeLaterResponse = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: TabBarView(controller: widget._tabController, children: [
          buildTabCurrent(),
          buildTabHistory(),
          buildTabSeeLater()
        ]),
      )
    ]);
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
        : (eventHistory.length > 0)
            ? ListView.separated(
                itemCount: eventHistory.length,
                itemBuilder: (context, index) {
                  return EventCard(eventHistory[index]);
                },
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                  thickness: 1,
                  height: 0,
                ),
              )
            : Center(
                child: Text("No has asistido a ningún evento"),
              );
  }

  Widget buildTabSeeLater() {
    return (!seeLaterResponse)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : (seeLater.length > 0)
            ? ListView.separated(
                itemCount: seeLater.length,
                itemBuilder: (context, index) {
                  return EventCard(seeLater[index]);
                },
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                  thickness: 1,
                  height: 0,
                ),
              )
            : Center(
                child: Text("No has guardado ningún evento"),
              );
  }

  Widget buildTabCurrent() {
    return (!hasFutureEventsResponse)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : (futureEvents.length > 0)
            ? ListView.separated(
                itemCount: futureEvents.length,
                itemBuilder: (context, index) {
                  return EventCard(futureEvents[index]);
                },
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                  thickness: 1,
                  height: 0,
                ),
              )
            : Center(
                child: Text("No estás inscrito en ningún evento próximo"),
              );
  }
}
