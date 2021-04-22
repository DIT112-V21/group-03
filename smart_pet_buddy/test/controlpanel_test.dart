import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_pet_buddy/bottomnavbar.dart';
import 'package:smart_pet_buddy/controlpanel.dart';

void main() {

  //************************** Backward button *******************************
  testWidgets('Backward should set the car in reverse state', (WidgetTester tester) async {

    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new Controlpanel())
    );

    await tester.pumpWidget(testWidget);
    ControlpanelState state = tester.state<ControlpanelState>(find.byType(Controlpanel));
    expect(state.isReversed, isFalse);

    await tester.tap(find.byKey(Key('backwards')));
    expect(state.isReversed, isTrue);
    expect(state.isForward, isFalse);
    expect(state.isRight, isFalse);
    expect(state.isLeft, isFalse);
  });

  testWidgets('Backward should move the car in reverse', (WidgetTester tester) async {

    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new Controlpanel())
    );

    await tester.pumpWidget(testWidget);
    ControlpanelState state = tester.state<ControlpanelState>(find.byType(Controlpanel));
    expect(state.isReversed, isFalse);

    await tester.tap(find.byKey(Key('backwards')));
    expect(state.isReversed, isTrue);
    expect(state.isForward, isFalse);
    expect(state.isRight, isFalse);
    expect(state.isLeft, isFalse);
    expect (state.reverseSpeed, -30);
    expect (state.steerNeutral, '0');

  });

  testWidgets('Backward should stand still when isReversed is false', (WidgetTester tester) async {

    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new Controlpanel())
    );

    await tester.pumpWidget(testWidget);
    ControlpanelState state = tester.state<ControlpanelState>(find.byType(Controlpanel));
    state.isReversed = true;

    await tester.tap(find.byKey(Key('backwards')));
    expect(state.isReversed, isFalse);
    expect(state.isForward, isFalse);
    expect(state.isRight, isFalse);
    expect(state.isLeft, isFalse);
    expect(state.throttleNeutral, '0');
  });

  //************************** Forward button *******************************
  testWidgets('Forward should set the car in a non reverse state', (WidgetTester tester) async {

    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new Controlpanel())
    );

    await tester.pumpWidget(testWidget);
    ControlpanelState state = tester.state<ControlpanelState>(find.byType(Controlpanel));
    expect(state.isForward, isFalse);

    await tester.tap(find.byKey(Key('forwards')));
    expect(state.isReversed, isFalse);
    expect(state.isForward, isTrue);
    expect(state.isRight, isFalse);
    expect(state.isLeft, isFalse);
  });

  testWidgets('Forward should move the car forward', (WidgetTester tester) async {

    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new Controlpanel())
    );

    await tester.pumpWidget(testWidget);
    ControlpanelState state = tester.state<ControlpanelState>(find.byType(Controlpanel));
    expect(state.isForward, isFalse);

    await tester.tap(find.byKey(Key('forwards')));
    expect(state.isReversed, isFalse);
    expect(state.isForward, isTrue);
    expect(state.isRight, isFalse);
    expect(state.isLeft, isFalse);
    expect (state.currentSpeed, 0); // needs mqtt mock
    expect (state.steerNeutral, '0');
  });

  testWidgets('Forward should stand still when isForward is false', (WidgetTester tester) async {

    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new Controlpanel())
    );

    await tester.pumpWidget(testWidget);
    ControlpanelState state = tester.state<ControlpanelState>(find.byType(Controlpanel));
    state.isForward = true;
    await tester.tap(find.byKey(Key('forwards')));
    expect(state.isReversed, isFalse);
    expect(state.isForward, isFalse);
    expect(state.isRight, isFalse);
    expect(state.isLeft, isFalse);
    expect(state.throttleNeutral, '0');
  });

  //************************** Left button *******************************

  testWidgets('Left should set the car in a left state', (WidgetTester tester) async {

    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new Controlpanel())
    );

    await tester.pumpWidget(testWidget);
    ControlpanelState state = tester.state<ControlpanelState>(find.byType(Controlpanel));
    expect(state.isLeft, isFalse);
    expect(state.isRight, isFalse);

    await tester.press(find.byKey(Key('left')));
    expect(state.isLeft, isTrue);
    expect(state.isRight, isFalse);

  });

}
