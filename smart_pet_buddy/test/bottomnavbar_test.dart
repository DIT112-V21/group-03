import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_pet_buddy/bottomnavbar.dart';

void main() {

  testWidgets('Pressing the home button should set index to 0',
       (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new BottomBar(Firebase.app())));

    await tester.pumpWidget(testWidget);
    BottomBarState state =
    tester.state<BottomBarState>(find.byType(BottomBar));
    expect(state.currentIndex, 0); // Needs mqtt mock?

    await tester.tap(find.byIcon(Icons.home_outlined));
    expect(state.currentIndex, 0);

       });

  testWidgets('Pressing the play button should set index to 1',
          (WidgetTester tester) async {
        Widget testWidget = new MediaQuery(
            data: new MediaQueryData(),
            child: new MaterialApp(home: new BottomBar(Firebase.app())));

        await tester.pumpWidget(testWidget);
        BottomBarState state =
        tester.state<BottomBarState>(find.byType(BottomBar));
        expect(state.currentIndex, 0);

        await tester.tap(find.byIcon(Icons.directions_car_outlined));
        expect(state.currentIndex, 1);

      });

  testWidgets('Pressing the custom button should set index to 2',
          (WidgetTester tester) async {
        Widget testWidget = new MediaQuery(
            data: new MediaQueryData(),
            child: new MaterialApp(home: new BottomBar(Firebase.app())));

        await tester.pumpWidget(testWidget);
        BottomBarState state =
        tester.state<BottomBarState>(find.byType(BottomBar));
        expect(state.currentIndex, 0);

        await tester.tap(find.byIcon(Icons.play_circle_outline));
        expect(state.currentIndex, 2);


      });

  testWidgets('Pressing the profile button should set index to 3',
          (WidgetTester tester) async {
        Widget testWidget = new MediaQuery(
            data: new MediaQueryData(),
            child: new MaterialApp(home: new BottomBar(Firebase.app())));

        await tester.pumpWidget(testWidget);
        BottomBarState state =
        tester.state<BottomBarState>(find.byType(BottomBar));
        expect(state.currentIndex, 0);

        await tester.tap(find.byIcon(Icons.account_circle_outlined));
        expect(state.currentIndex, 3);


      });
}
