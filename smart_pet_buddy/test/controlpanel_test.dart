
 import 'package:flutter/material.dart';
 import 'package:flutter_test/flutter_test.dart';
 import 'package:smart_pet_buddy/controlpanel.dart';

 void main() {

   //************************** Backward button *******************************
   testWidgets('Pressing backward button should set the car in reverse state', (WidgetTester tester) async {

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

   testWidgets('Pressing backward button should move the car in reverse', (WidgetTester tester) async {

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

   testWidgets('The car should stand still when isReversed is false', (WidgetTester tester) async {

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
   testWidgets('Pressing forward button should set the car in a forward state', (WidgetTester tester) async {

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

   testWidgets('Pressing forward button should move the car forward', (WidgetTester tester) async {

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
     //expect (state.currentSpeed, 0); // needs mqtt mock
     expect (state.steerNeutral, '0');
   });

   testWidgets('The car should stand still when isForward is false', (WidgetTester tester) async {

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

// ************************** Left button *******************************

   testWidgets('Pressing left button should set the car in a left state', (WidgetTester tester) async {

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

   testWidgets('Pressing left button should turn the car left in a forward state', (WidgetTester tester) async {

     Widget testWidget = new MediaQuery(
         data: new MediaQueryData(),
         child: new MaterialApp(home: new Controlpanel())
     );

     await tester.pumpWidget(testWidget);
     ControlpanelState state = tester.state<ControlpanelState>(find.byType(Controlpanel));
     expect(state.isLeft, isFalse);
     expect(state.isRight, isFalse);

     state.isForward = true;

     await tester.press(find.byKey(Key('left')));
     expect(state.isReversed, isFalse);
     expect(state.isRight, isFalse);
     expect(state.isLeft, isTrue);
     // expect (state.currentSpeed, 0); // needs mqtt mock
  });

   testWidgets('Pressing left button should turn the car left in a reversed state', (WidgetTester tester) async {

     Widget testWidget = new MediaQuery(
         data: new MediaQueryData(),
         child: new MaterialApp(home: new Controlpanel())
     );

     await tester.pumpWidget(testWidget);
     ControlpanelState state = tester.state<ControlpanelState>(find.byType(Controlpanel));
     expect(state.isLeft, isFalse);
     expect(state.isRight, isFalse);

     state.isReversed = true;

     await tester.press(find.byKey(Key('left')));
     expect(state.isForward, isFalse);
     expect(state.isRight, isFalse);
     expect(state.isLeft, isTrue);
     // expect (state.currentSpeed, 0); // needs mqtt mock
   });

   //************************** Right button *******************************

   testWidgets('Pressing right button should set the car in a right state', (WidgetTester tester) async {

     Widget testWidget = new MediaQuery(
         data: new MediaQueryData(),
         child: new MaterialApp(home: new Controlpanel())
     );

     await tester.pumpWidget(testWidget);
     ControlpanelState state = tester.state<ControlpanelState>(find.byType(Controlpanel));
     expect(state.isLeft, isFalse);
     expect(state.isRight, isFalse);

     await tester.press(find.byKey(Key('right')));
     expect(state.isLeft, isFalse);
     expect(state.isRight, isTrue);

   });

   testWidgets('Pressing right button should turn the car right in a forward state', (WidgetTester tester) async {

     Widget testWidget = new MediaQuery(
         data: new MediaQueryData(),
         child: new MaterialApp(home: new Controlpanel())
     );

     await tester.pumpWidget(testWidget);
     ControlpanelState state = tester.state<ControlpanelState>(find.byType(Controlpanel));
     expect(state.isLeft, isFalse);
     expect(state.isRight, isFalse);

    state.isForward = true;

     await tester.press(find.byKey(Key('right')));
     expect(state.isReversed, isFalse);
     expect(state.isRight, isTrue);
    expect(state.isLeft, isFalse);
     // expect (state.currentSpeed, 0); // needs mqtt mock
   });

  testWidgets('Pressing right button should turn the car right in a reversed state', (WidgetTester tester) async {

    Widget testWidget = new MediaQuery(
         data: new MediaQueryData(),
         child: new MaterialApp(home: new Controlpanel())
     );

    await tester.pumpWidget(testWidget);
     ControlpanelState state = tester.state<ControlpanelState>(find.byType(Controlpanel));
     expect(state.isLeft, isFalse);
   expect(state.isRight, isFalse);

   state.isReversed = true;

     await tester.press(find.byKey(Key('right')));
     expect(state.isForward, isFalse);
     expect(state.isRight, isTrue);
     expect(state.isLeft, isFalse);
     // expect (state.currentSpeed, 0); // needs mqtt mock
   });

 }

