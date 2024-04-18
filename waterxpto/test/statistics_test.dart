import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterxpto/Statistics/MonthChart.dart';
import 'package:waterxpto/Statistics/StatisticsContent.dart';
import 'package:waterxpto/Statistics/WeekChart.dart';
import 'package:waterxpto/Statistics/YearChart.dart';

void main() {
  testWidgets(
      'StatisticsContent renders correctly', (WidgetTester tester) async {
    // Build our widget with a Material widget ancestor
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: StatisticsContent(),
      ),
    ));

    // Verify that the text "Your History" is displayed
    expect(find.text('Your History'), findsOneWidget);

    // Verify that all three tab buttons are displayed
    expect(find.text('week'), findsOneWidget);
    expect(find.text('month'), findsOneWidget);
    expect(find.text('year'), findsOneWidget);

    // Verify that the initial chart displayed is for the week
    expect(find.byType(WeekChart), findsOneWidget);
    expect(find.byType(MonthChart), findsNothing);
    expect(find.byType(YearChart), findsNothing);
  });



  //Fails to click the month tab but works but the tab works perfectly when running

  testWidgets('Tap "month" multiple times and wait to find MonthChart', (WidgetTester tester) async {
    // Build our widget with a Material widget ancestor
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: StatisticsContent(),
      ),
    ));

    // Wait for the widget building process to complete
    await tester.pumpAndSettle();

    // Tap on the "month" tab multiple times
    for (int i = 0; i < 3; i++) {
      await tester.tap(find.text('month'));
      await tester.pumpAndSettle();
    }

    // Wait for a few seconds to allow any animations or state changes to settle
    await Future.delayed(Duration(seconds: 2));

    // Check if the MonthChart widget is present
    expect(find.byType(MonthChart), findsOneWidget);
  });


}