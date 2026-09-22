import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:hostel_buddy/models/complete_models.dart';
import 'package:hostel_buddy/screens/connected_leads_screen.dart';
import 'package:hostel_buddy/screens/role_selection_screen.dart';

// These tests pump screens directly rather than HostelBuddyApp, which pulls
// fonts from the network via google_fonts.

void main() {
  setUp(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.physicalSize = const Size(1080, 2400);
    binding.platformDispatcher.views.first.devicePixelRatio = 2.75;
  });

  tearDown(() {
    final view = TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  testWidgets('role selection asks for a role before continuing',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RoleSelectionScreen()));

    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(find.text('Please select a role'), findsOneWidget);
  });

  testWidgets('role selection back button does not leave an empty navigator',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: const RoleSelectionScreen(),
      routes: {'/google-auth': (_) => const Text('auth screen')},
    ));

    await tester.tap(find.byIcon(FontAwesomeIcons.arrowLeft));
    await tester.pumpAndSettle();

    expect(find.text('auth screen'), findsOneWidget);
  });

  testWidgets('tapping WhatsApp on a lead shows a message instead of crashing',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ConnectedLeadsScreen()));

    await tester.tap(find.byIcon(FontAwesomeIcons.whatsapp).first);
    await tester.pump();

    expect(find.textContaining('Opening WhatsApp'), findsOneWidget);
  });

  test('minPricePerBed uses the cheapest room, not the first', () {
    final hostel = CompleteDummyData.hostels.first;
    final cheapest = hostel.rooms
        .map((room) => room.pricePerBed)
        .reduce((a, b) => a < b ? a : b);

    expect(hostel.rooms.first.pricePerBed, isNot(cheapest));
    expect(hostel.minPricePerBed, cheapest);
  });
}
