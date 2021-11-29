import 'package:eventy_front/components/pages/search/search_result.dart';
import 'package:eventy_front/components/root.dart';
import 'package:eventy_front/navigation/navigation.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  /*testWidgets("Search menu opens", (WidgetTester tester) async {
    await tester.pumpWidget(new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: Root(selectedPage: EventsNavigation.NAV_SEARCH))));
    //locates appbar
    final appbarfinder = find.byKey(ValueKey("appbar"));
    expect(appbarfinder, findsOneWidget);
    await tester.pump(Duration(seconds: 3));
    //locates and presses fab
    final fabFinder = find.byType(FloatingActionButton);
    expect(fabFinder, findsOneWidget);
    await tester.pump(Duration(seconds: 3));
    await tester.tap(fabFinder);
    await tester.pump(Duration(seconds: 3));
    //modal bottom sheet opens -> locate search input
    final searchFieldFinder = find.byKey(ValueKey("search_textfield"));
    expect(searchFieldFinder, findsOneWidget);
    final searchbutton = find.byKey(ValueKey("search_button"));
    expect(searchbutton, findsOneWidget);
    //close modal bottom sheet
    await tester.tap(appbarfinder,
        warnIfMissed:
            false); //No es necesario que le de, solamente que toque fuera para cerrar el menú de búsqueda
    await tester.pump();
  });
  testWidgets("Search starts loading", (WidgetTester tester) async {
    //Enters search screen
    await tester.pumpWidget(new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: Root(selectedPage: EventsNavigation.NAV_SEARCH))));
    //locates appbar
    final appbarfinder = find.byKey(ValueKey("appbar"));
    expect(appbarfinder, findsOneWidget);
    await tester.pump(Duration(seconds: 3));
    //locates and presses fab
    final fabFinder = find.byType(FloatingActionButton);
    expect(fabFinder, findsOneWidget);
    await tester.pump(Duration(seconds: 3));
    await tester.tap(fabFinder);
    await tester.pump(Duration(seconds: 3));
    //locates and types text in search field
    final searchFieldFinder = find.byKey(ValueKey("search_textfield"));
    expect(searchFieldFinder, findsOneWidget);
    await tester.pump();
    await tester.enterText(searchFieldFinder, "a");
    //start search
    final gesture =
        await tester.startGesture(Offset(0, 300)); //Position of the scrollview
    await gesture.moveBy(Offset(0, -1500)); //How much to scroll by
    await tester.pump(Duration(seconds: 3));
    final searchbutton = find.byKey(ValueKey("search_button"));
    expect(searchbutton, findsOneWidget);
    await tester.press(searchbutton);
    await tester.pump(Duration(seconds: 15));

    final loadingIndicator = find.byType(CircularProgressIndicator);
    expect(loadingIndicator, findsOneWidget);
  });
  testWidgets("Search result custom widget are generated in a list",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      List<Event> events = [
        Event(
            1,
            "descripcion",
            DateTime.now().toIso8601String(),
            DateTime.now().toIso8601String(),
            [
              "https://firebasestorage.googleapis.com/v0/b/eventy-a8e4c.appspot.com/o/images%2Fevents%2Ferasmus.png?alt=media&token=8a744c36-4656-4d38-aee7-306e980b3d79"
            ],
            1.0,
            2.0,
            5,
            [],
            "name1",
            "ownerId",
            1.0,
            false,
            "summary",
            ["tag"],
            [],
            1),
        Event(
            2,
            "descripcion",
            DateTime.now().toIso8601String(),
            DateTime.now().toIso8601String(),
            [
              "https://firebasestorage.googleapis.com/v0/b/eventy-a8e4c.appspot.com/o/images%2Fevents%2Ferasmus.png?alt=media&token=8a744c36-4656-4d38-aee7-306e980b3d79"
            ],
            1.0,
            2.0,
            5,
            [],
            "name2",
            "ownerId",
            1.0,
            false,
            "summary",
            ["tag"],
            [],
            1),
        Event(
            3,
            "descripcion",
            DateTime.now().toIso8601String(),
            DateTime.now().toIso8601String(),
            [
              "https://firebasestorage.googleapis.com/v0/b/eventy-a8e4c.appspot.com/o/images%2Fevents%2Ferasmus.png?alt=media&token=8a744c36-4656-4d38-aee7-306e980b3d79"
            ],
            1.0,
            2.0,
            5,
            [],
            "name3",
            "ownerId",
            1.0,
            false,
            "summary",
            ["tag"],
            [],
            1),
        Event(
            4,
            "descripcion",
            DateTime.now().toIso8601String(),
            DateTime.now().toIso8601String(),
            [
              "https://firebasestorage.googleapis.com/v0/b/eventy-a8e4c.appspot.com/o/images%2Fevents%2Ferasmus.png?alt=media&token=8a744c36-4656-4d38-aee7-306e980b3d79"
            ],
            1.0,
            2.0,
            5,
            [],
            "name4",
            "ownerId",
            1.0,
            false,
            "summary",
            ["tag"],
            [],
            1),
        Event(
            5,
            "descripcion",
            DateTime.now().toIso8601String(),
            DateTime.now().toIso8601String(),
            [
              "https://firebasestorage.googleapis.com/v0/b/eventy-a8e4c.appspot.com/o/images%2Fevents%2Ferasmus.png?alt=media&token=8a744c36-4656-4d38-aee7-306e980b3d79"
            ],
            1.0,
            2.0,
            5,
            [],
            "name5",
            "ownerId",
            1.0,
            false,
            "summary",
            ["tag"],
            [],
            1),
        Event(
            6,
            "descripcion",
            DateTime.now().toIso8601String(),
            DateTime.now().toIso8601String(),
            [
              "https://firebasestorage.googleapis.com/v0/b/eventy-a8e4c.appspot.com/o/images%2Fevents%2Ferasmus.png?alt=media&token=8a744c36-4656-4d38-aee7-306e980b3d79"
            ],
            1.0,
            2.0,
            5,
            [],
            "name6",
            "ownerId",
            1.0,
            false,
            "summary",
            ["tag"],
            [],
            1),
        Event(
            7,
            "descripcion",
            DateTime.now().toIso8601String(),
            DateTime.now().toIso8601String(),
            [
              "https://firebasestorage.googleapis.com/v0/b/eventy-a8e4c.appspot.com/o/images%2Fevents%2Ferasmus.png?alt=media&token=8a744c36-4656-4d38-aee7-306e980b3d79"
            ],
            1.0,
            2.0,
            5,
            [],
            "name7",
            "ownerId",
            1.0,
            false,
            "summary",
            ["tag"],
            [],
            1),
      ];

      await tester.pumpWidget(new MediaQuery(
          data: new MediaQueryData(),
          child: Directionality(
              textDirection: TextDirection.ltr,
              child: ListView.separated(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return SearchResult(events[index]);
                },
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(),
                ),
              ))));
      //Results are generated without needing scroll
      final resultsFinderNoScroll = find.byType(SearchResult);
      expect(resultsFinderNoScroll, findsWidgets);

      //First element is generated and the last one is off screen
      var lastElementFinder = find.text("name7");
      var firstElementFinder = find.text("name1");
      expect(lastElementFinder, findsNothing);
      expect(firstElementFinder, findsOneWidget);

      //Let's scroll through the SearchResults list
      final gesture = await tester
          .startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -2000)); //How much to scroll by
      await tester.pump(Duration(seconds: 3));

      //First element is not generated but the last one is
      lastElementFinder = find.text("name7");
      firstElementFinder = find.text("name1");
      expect(lastElementFinder, findsOneWidget);
      expect(firstElementFinder, findsNothing);
    });
  });*/
}
