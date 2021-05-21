import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_pet_buddy/bottomnavbar_widget.dart';
import 'package:smart_pet_buddy/custompage.dart';
import 'package:smart_pet_buddy/homepage.dart';
import 'package:smart_pet_buddy/playpage.dart';
import 'package:smart_pet_buddy/profile_widget.dart';


void main() {
  testWidgets("Finds a Home button", (WidgetTester tester) async {
    final homeButton = find.byIcon(Icons.home_outlined);
    final homepage = HomePage();

    await tester.pumpWidget(MaterialApp(home: ConvexBottomBar(Firebase.app())));
    await tester.tap(homeButton);
    await tester.pump();

    expect(homepage, findsOneWidget);
  });

  testWidgets("Finds a Play button", (WidgetTester tester) async {
    final playButton = find.byIcon(Icons.control_camera_outlined);
    final playpage = PlayPage();

    await tester.pumpWidget(MaterialApp(home: ConvexBottomBar(Firebase.app())));
    await tester.tap(playButton);
    await tester.pump();

    expect(playpage, findsOneWidget);
  });

  testWidgets("Finds a Automated play button", (WidgetTester tester) async {
    final autoButton = find.byIcon(Icons.pest_control_rodent_outlined);
    final autopage = CustomPage();

    await tester.pumpWidget(MaterialApp(home: ConvexBottomBar(Firebase.app())));
    await tester.tap(autoButton);
    await tester.pump();

    expect(autopage, findsOneWidget);

  });

  testWidgets("Finds a Profile button", (WidgetTester tester) async {
    final profileButton = find.byIcon(Icons.account_circle_outlined);
    final profilepage = ProfileWidget();

    await tester.pumpWidget(MaterialApp(home: ConvexBottomBar(Firebase.app())));
    await tester.tap(profileButton);
    await tester.pump();

    expect(profilepage, findsOneWidget);

   });
  }
