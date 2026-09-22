import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_store.dart';
import '../widgets/marketplace_widgets.dart';

class PostRequirementScreen extends StatefulWidget {
  const PostRequirementScreen({super.key});
  @override
  State<PostRequirementScreen> createState() => _PostRequirementScreenState();
}
class _PostRequirementScreenState extends State<PostRequirementScreen> {
  final form = GlobalKey<FormState>();
  final budget = TextEditingController(text: '35000');
  late String city;
  int seats = 2;
  final Set<String> amenities = {'Wi-Fi'};
  bool submitted = false;
  @override
  void initState() { super.initState(); city = AppStore.instance.profile.city; }
  @override
  void dispose() { budget.dispose(); super.dispose(); }
  void submit() {
    if (submitted || !form.currentState!.validate()) return;
    submitted = true;
    final request = AppStore.instance.postRequirement(city: city,
      budget: int.parse(budget.text.trim()), seats: seats, amenities: amenities.toList());
    Navigator.pushReplacementNamed(context, '/bids-inbox', arguments: request.id);
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Post a requirement')),
    body: Form(key: form, child: PageBody(children: [
      const DemoNotice(),
      DropdownButtonFormField<String>(initialValue: city, isExpanded: true,
        decoration: const InputDecoration(labelText: 'City'),
        items: {city, ...cities}.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
        onChanged: (v) { if (v != null) setState(() => city = v); }),
      const SizedBox(height: 16),
      TextFormField(controller: budget, keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly], validator: priceValidator,
        decoration: const InputDecoration(labelText: 'Monthly budget (PKR)')),
      const SizedBox(height: 16),
      DropdownButtonFormField<int>(initialValue: seats,
        decoration: const InputDecoration(labelText: 'Room type'),
        items: [1, 2, 3, 4].map((n) => DropdownMenuItem(value: n, child: Text('$n-Seater'))).toList(),
        onChanged: (v) { if (v != null) setState(() => seats = v); }),
      const SizedBox(height: 16), const Text('Required amenities'),
      Wrap(spacing: 8, children: amenityOptions.map((a) => FilterChip(
        label: Text(a), selected: amenities.contains(a),
        onSelected: (selected) => setState(() { if (selected) { amenities.add(a); } else { amenities.remove(a); } }))).toList()),
      const SizedBox(height: 20),
      FilledButton(onPressed: submit, child: const Text('Post demo request')),
    ])),
  );
}
