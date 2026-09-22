import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_store.dart';
import '../core/constants.dart';
import '../core/hostel_search.dart';
import '../models/complete_models.dart';

const cities = ['G-11, Islamabad', 'G-10, Islamabad', 'F-10, Islamabad',
  'Gulberg, Lahore', 'Johar Town, Lahore', 'Clifton, Karachi', 'Gulshan, Karachi',
  'University Town, Peshawar'];
const amenityOptions = ['UPS', 'Wi-Fi', 'Mess', 'Laundry', 'Security',
  'Garden', 'AC', 'Hot Water', 'Attached Bath', 'Study Area'];
const roomTypes = ['1-Seater', '2-Seater', '3-Seater', '4-Seater'];

class DemoNotice extends StatelessWidget {
  const DemoNotice({super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Text('Demo workspace • Changes stay on this device. Offers and coins are simulated; no booking or payment is made.',
      style: Theme.of(context).textTheme.bodySmall),
  );
}

class PageBody extends StatelessWidget {
  final List<Widget> children;
  const PageBody({super.key, required this.children});
  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 24 + MediaQuery.viewInsetsOf(context).bottom),
      child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 720),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children))),
    ),
  );
}

class SectionCard extends StatelessWidget {
  final Widget child;
  const SectionCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(padding: const EdgeInsets.all(16), child: child),
  );
}

class HostelTile extends StatelessWidget {
  final HostelData hostel;
  final int? matchingPrice;
  const HostelTile({super.key, required this.hostel, this.matchingPrice});
  @override
  Widget build(BuildContext context) {
    final available = hostel.rooms.where((r) => r.availableBeds > 0).toList();
    final price = matchingPrice ?? (available.isEmpty ? null :
      available.map((r) => r.pricePerBed).reduce((a, b) => a < b ? a : b));
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/hostel-details', arguments: hostel.id),
        child: Padding(padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.apartment, size: 36, color: AppColors.green),
              const SizedBox(width: 12),
              Expanded(child: Text(hostel.name, style: Theme.of(context).textTheme.titleMedium)),
              IconButton(tooltip: AppStore.instance.isFavorite(hostel.id) ? 'Remove favorite' : 'Save favorite',
                onPressed: () => AppStore.instance.toggleFavorite(hostel.id),
                icon: Icon(AppStore.instance.isFavorite(hostel.id) ? Icons.favorite : Icons.favorite_border)),
            ]),
            Text(hostel.city),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 4, children: hostel.amenities.take(4)
              .map((a) => Chip(label: Text(a), visualDensity: VisualDensity.compact)).toList()),
            const SizedBox(height: 8),
            Text(price == null ? 'No beds available' : 'From ${money(price)} / bed / month',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.green)),
            Text('${hostel.overallRating.toStringAsFixed(1)} / 5 • ${hostel.totalReviews} reviews'),
          ])),
      ),
    );
  }
}

class UnavailableScreen extends StatelessWidget {
  final String message;
  const UnavailableScreen({super.key, this.message = 'This page is unavailable. Please open it from the relevant list.'});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Page unavailable')),
    body: PageBody(children: [
      const Icon(Icons.info_outline, size: 48),
      const SizedBox(height: 16), Text(message),
      const SizedBox(height: 20),
      FilledButton(onPressed: () {
        if (Navigator.canPop(context)) { Navigator.pop(context); } else {
          Navigator.pushNamedAndRemoveUntil(context, '/role-selection', (_) => false);
        }
      }, child: const Text('Go back')),
    ]),
  );
}

void showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(text)));
}
Future<bool> confirmAction(BuildContext context, String title, String message,
    {String action = 'Confirm'}) async => await showDialog<bool>(
  context: context, builder: (dialogContext) => AlertDialog(title: Text(title),
    content: Text(message), actions: [
      TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
      FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: Text(action)),
    ]),
) ?? false;

Future<void> copyValue(BuildContext context, String value) async {
  await Clipboard.setData(ClipboardData(text: value));
  if (context.mounted) showMessage(context, 'Copied to clipboard');
}
Future<void> openContact(BuildContext context, String phone, {bool whatsapp = false}) async {
  final digits = phone.replaceAll(RegExp(r'\D'), '');
  final international = digits.startsWith('0') ? '92${digits.substring(1)}' : digits;
  if (international.length < 10 || international.length > 15) {
    showMessage(context, 'This phone number is invalid.'); return;
  }
  final uri = whatsapp ? Uri.https('wa.me', '/$international') : Uri(scheme: 'tel', path: '+$international');
  try {
    if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
  } catch (_) {
    // An emulator or device may not have a dialer or messaging application.
  }
  if (context.mounted) showMessage(context, 'No compatible app is available. Use Copy phone instead.');
}

String? requiredText(String? value, {int min = 1, int max = 120}) {
  final text = value?.trim() ?? '';
  if (text.length < min) return 'Enter at least $min characters.';
  if (text.length > max) return 'Use no more than $max characters.';
  return null;
}
String? phoneValidator(String? value) {
  final text = value?.trim() ?? '';
  if (!RegExp(r'^\+?[0-9 ()-]+$').hasMatch(text)) return 'Enter a valid phone number.';
  final digits = text.replaceAll(RegExp(r'\D'), '');
  return digits.length < 10 || digits.length > 15 ? 'Enter a valid phone number.' : null;
}
String? priceValidator(String? value) {
  final amount = int.tryParse(value?.trim() ?? '');
  return amount == null || amount < 5000 || amount > 1000000
    ? 'Enter a price from 5,000 to 1,000,000.' : null;
}

