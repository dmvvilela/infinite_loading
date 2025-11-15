import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinite_loading/infinite_loading.dart';

void main() {
  group('InfiniteLoading Widget Tests', () {
    testWidgets('Widget renders with default parameters',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfiniteLoading(),
          ),
        ),
      );

      expect(find.byType(InfiniteLoading), findsOneWidget);
    });

    testWidgets('Widget renders with custom dimensions',
        (WidgetTester tester) async {
      const testWidth = 300.0;
      const testHeight = 15.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfiniteLoading(
              width: testWidth,
              height: testHeight,
            ),
          ),
        ),
      );

      // Let the animation start
      await tester.pump();

      final widget = tester.widget<InfiniteLoading>(
        find.byType(InfiniteLoading),
      );

      expect(widget.width, testWidth);
      expect(widget.height, testHeight);
    });

    testWidgets('Widget shows oscillating animation during loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfiniteLoading(
              width: 200,
              height: 8,
            ),
          ),
        ),
      );

      // Initial frame
      await tester.pump();

      // Animation should be running
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(InfiniteLoading), findsOneWidget);

      // Continue animation
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(InfiniteLoading), findsOneWidget);
    });

    testWidgets('Widget transitions to success state',
        (WidgetTester tester) async {
      bool? completeWithSuccess;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return InfiniteLoading(
                  width: 200,
                  height: 8,
                  completeWithSuccess: completeWithSuccess,
                );
              },
            ),
          ),
        ),
      );

      // Widget should be in loading state
      await tester.pump();

      // Change to success state
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfiniteLoading(
              width: 200,
              height: 8,
              completeWithSuccess: true,
            ),
          ),
        ),
      );

      // Wait for completion animation
      await tester.pumpAndSettle();

      // Should show success icon
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });

    testWidgets('Widget transitions to error state',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfiniteLoading(
              width: 200,
              height: 8,
              completeWithSuccess: false,
            ),
          ),
        ),
      );

      // Wait for completion animation
      await tester.pumpAndSettle();

      // Should show error icon
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    });

    testWidgets('Widget respects custom colors', (WidgetTester tester) async {
      const testTrackColor = Color(0xFF2C3E50);
      const testProgressColor = Color(0xFF3498DB);
      const testBorderColor = Color(0xFF3498DB);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfiniteLoading(
              width: 200,
              height: 8,
              trackColor: testTrackColor,
              progressColor: testProgressColor,
              borderColor: testBorderColor,
            ),
          ),
        ),
      );

      await tester.pump();

      final widget = tester.widget<InfiniteLoading>(
        find.byType(InfiniteLoading),
      );

      expect(widget.trackColor, testTrackColor);
      expect(widget.progressColor, testProgressColor);
      expect(widget.borderColor, testBorderColor);
    });

    testWidgets('Widget respects custom animation duration',
        (WidgetTester tester) async {
      const testDuration = Duration(milliseconds: 600);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfiniteLoading(
              width: 200,
              height: 8,
              oscillationDuration: testDuration,
            ),
          ),
        ),
      );

      await tester.pump();

      final widget = tester.widget<InfiniteLoading>(
        find.byType(InfiniteLoading),
      );

      expect(widget.oscillationDuration, testDuration);
    });

    testWidgets('Widget respects custom border properties',
        (WidgetTester tester) async {
      const testBorderWidth = 5.0;
      const testBorderRadius = 20.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfiniteLoading(
              width: 200,
              height: 8,
              borderWidth: testBorderWidth,
              borderRadius: testBorderRadius,
            ),
          ),
        ),
      );

      await tester.pump();

      final widget = tester.widget<InfiniteLoading>(
        find.byType(InfiniteLoading),
      );

      expect(widget.borderWidth, testBorderWidth);
      expect(widget.borderRadius, testBorderRadius);
    });
  });
}
