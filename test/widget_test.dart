import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_intentions_app/main.dart';

void main() {
  testWidgets('App loads home screen and navigates across all tabs', (WidgetTester tester) async {
    // Set a phone/desktop viewport size
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const PersonalIntentionsApp());
    await tester.pumpAndSettle();

    // 1. Home tab check
    expect(find.textContaining('Assalamualaikum'), findsOneWidget);
    expect(find.text('DAILY NIYYAH'), findsOneWidget);
    expect(find.text('Upcoming reminder'), findsOneWidget);
    expect(find.text('A little inspiration'), findsOneWidget);

    // 2. Switch to Explore Tab
    final exploreTab = find.text('Explore');
    expect(exploreTab, findsOneWidget);
    await tester.tap(exploreTab);
    await tester.pumpAndSettle();
    expect(find.text('Explore Intentions'), findsOneWidget);

    // 3. Switch to Saved Tab
    final savedTab = find.text('Saved');
    expect(savedTab, findsOneWidget);
    await tester.tap(savedTab);
    await tester.pumpAndSettle();
    expect(find.text('Saved Items'), findsOneWidget);

    // 4. Switch to Reminders Tab
    final remindersTab = find.text('Reminders');
    expect(remindersTab, findsOneWidget);
    await tester.tap(remindersTab);
    await tester.pumpAndSettle();
    expect(find.text('Your Reminders'), findsOneWidget);

    // 5. Switch back to Home Tab
    final homeTab = find.text('Home');
    expect(homeTab, findsOneWidget);
    await tester.tap(homeTab);
    await tester.pumpAndSettle();
    expect(find.textContaining('Assalamualaikum'), findsOneWidget);
  });

  testWidgets('Category direct bypass vs subcategories navigation', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const PersonalIntentionsApp());
    await tester.pumpAndSettle();

    // Go to Explore tab
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();

    // 1. Test direct bypass category: "Family & Relationships" has hasSubcategories = false
    // It should open IntentionListScreen directly with "Family Intentions" or "Intentions" tab
    final familyCat = find.text('Family & Relationships');
    expect(familyCat, findsOneWidget);
    await tester.tap(familyCat);
    await tester.pumpAndSettle();

    // Verify we are on IntentionListScreen
    expect(find.text('Family & Relationships'), findsWidgets);
    expect(find.textContaining('Intentions'), findsWidgets);
    expect(find.text('Content'), findsOneWidget);

    // Pop back to Explore
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // 2. Test category with subcategories: "Character & Manners"
    final characterCat = find.text('Character & Manners');
    expect(characterCat, findsOneWidget);
    await tester.tap(characterCat);
    await tester.pumpAndSettle();

    // Verify we are on SubcategoriesScreen
    expect(find.text('Character & Manners'), findsWidgets);
    expect(find.text('Being Patient'), findsOneWidget);
    expect(find.text('Soft Speech & Kindness'), findsOneWidget);
  });

  testWidgets('Superadmin portal switch toggle test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const PersonalIntentionsApp());
    await tester.pumpAndSettle();

    // Tap the profile circle on HomeScreen to open dialog
    final profileIcon = find.byIcon(Icons.person);
    expect(profileIcon, findsOneWidget);
    await tester.tap(profileIcon);
    await tester.pumpAndSettle();

    // Dialog should appear with Superadmin Portal toggle
    expect(find.text("Ayesha's Profile"), findsOneWidget);
    expect(find.text('Superadmin Portal'), findsOneWidget);

    // Toggle switch
    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    // Verify Admin Portal screen is loaded
    expect(find.text('SUPERADMIN'), findsOneWidget);
    expect(find.text('Global Feature Control'), findsOneWidget);

    // Switch to Categories section
    await tester.tap(find.textContaining('Categories ('));
    await tester.pumpAndSettle();
    expect(find.text('Preset Categories'), findsOneWidget);
  });
}


