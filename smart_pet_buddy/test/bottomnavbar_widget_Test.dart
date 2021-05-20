import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_pet_buddy/bottomnavbar_widget.dart';


void main() {
  testWidgets("Finds a Home button", (WidgetTester tester) async {
    final homeButton = find.byIcon(Icons.home_outlined);
    await tester.pumpWidget(MaterialApp(home: ConvexBottomBar(Firebase.app())));

    expect(homeButton, findsOneWidget);
  });

  testWidgets("Finds a Play button", (WidgetTester tester) async {
    final playButton = find.byIcon(Icons.control_camera_outlined);
    await tester.pumpWidget(MaterialApp(home: ConvexBottomBar(Firebase.app())));

    expect(playButton, findsOneWidget);
  });

  testWidgets("Finds a Automated play button", (WidgetTester tester) async {
    final autoButton = find.byIcon(Icons.pest_control_rodent_outlined);
    await tester.pumpWidget(MaterialApp(home: ConvexBottomBar(Firebase.app())));

    expect(autoButton, findsOneWidget);

  });

  testWidgets("Finds a Profile button", (WidgetTester tester) async {
    final profileButton = find.byIcon(Icons.account_circle_outlined);
    await tester.pumpWidget(MaterialApp(home: ConvexBottomBar(Firebase.app())));

    expect(profileButton, findsOneWidget);

   });
  }
