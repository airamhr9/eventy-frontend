import 'package:eventy_front/components/pages/home/home.dart';
import 'package:eventy_front/components/root.dart';
import 'package:eventy_front/navigation/navigation.dart';
import 'package:eventy_front/objects/group.dart';
import 'package:eventy_front/objects/group_request.dart';
import 'package:eventy_front/services/group_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("Search menu opens", (WidgetTester tester) async {
    await tester.pumpWidget(new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: Root(selectedPage: EventsNavigation.NAV_SEARCH))));
    final appbarfinder = find.byKey(ValueKey("appbar"));
    await tester.pump(Duration(seconds: 3));
    final fabFinder = find.byType(FloatingActionButton);
    expect(fabFinder, findsOneWidget);
    await tester.pump(Duration(seconds: 3));
    await tester.tap(fabFinder);
    await tester.pump(Duration(seconds: 3));
    final searchFieldFinder = find.byKey(ValueKey("search_textfield"));
    expect(searchFieldFinder, findsOneWidget);
    await tester.tap(appbarfinder,
        warnIfMissed:
            false); //No es necesario que le de, solamente que toque fuera para cerrar el menú de búsqueda
    await tester.pump();
  });
}
