import 'package:flutter/material.dart';
import '../core/app_store.dart';
import '../core/hostel_search.dart';
import '../models/bid_models.dart';
import '../widgets/marketplace_widgets.dart';

class StudentQuotesScreen extends StatefulWidget {
  final int? requirementId;
  final bool manager;
  const StudentQuotesScreen({super.key, this.requirementId, this.manager = false});
  @override
  State<StudentQuotesScreen> createState() => _StudentQuotesScreenState();
}
class _StudentQuotesScreenState extends State<StudentQuotesScreen> {
  int tab = 0;
  bool busy = false;
  Future<void> unlock(QuoteBid bid) async {
    if (busy) return;
    setState(() => busy = true);
    final approved = await confirmAction(context, 'Unlock contact?',
      'Use 100 demo coins to view this hostel contact. No real payment is taken.', action: 'Unlock');
    if (!mounted) return;
    setState(() => busy = false);
    if (!approved) return;
    final error = AppStore.instance.unlockBid(bid.id);
    if (error != null) { showMessage(context, error); return; }
    Navigator.pushNamed(context, '/contact-reveal', arguments: bid.id);
  }
  Future<void> close(QuoteBid bid, bool accept) async {
    if (busy) return;
    setState(() => busy = true);
    final approved = await confirmAction(context, accept ? 'Accept offer?' : 'Reject offer?',
      accept ? 'Mark this offer accepted in your demo workspace. Contact the manager to arrange a visit; this does not reserve a bed.'
        : 'This closes the offer for this request.', action: accept ? 'Accept' : 'Reject');
    if (!mounted) return;
    setState(() => busy = false);
    if (!approved) return;
    final error = AppStore.instance.closeBid(bid.id, accept);
    showMessage(context, error ?? (accept ? 'Demo offer accepted' : 'Offer rejected'));
  }
  Future<void> withdraw(QuoteBid bid) async {
    if (busy) return;
    setState(() => busy = true);
    final approved = await confirmAction(context, 'Withdraw offer?',
      bid.chargedForPosting ? 'The 50 demo coins used to post this offer will be refunded.' : 'Remove this sample offer from active bids.',
      action: 'Withdraw');
    if (!mounted) return;
    setState(() => busy = false);
    if (!approved) return;
    final error = AppStore.instance.withdrawBid(bid.id);
    showMessage(context, error ?? 'Offer withdrawn');
  }
  @override
  Widget build(BuildContext context) => StoreBuilder(builder: (context, store) {
    final request = store.requirement(widget.requirementId);
    if (widget.requirementId != null && request == null) return const UnavailableScreen();
    final all = store.bids.where((b) =>
      (widget.requirementId == null || b.requirementId == widget.requirementId) &&
      (!widget.manager || b.hostelId == store.selectedHostelId)).toList();
    final bids = all.where((b) => switch (tab) {
      0 => b.status == BidStatus.received,
      1 => b.status == BidStatus.pending,
      _ => [BidStatus.accepted, BidStatus.rejected, BidStatus.withdrawn].contains(b.status),
    }).toList();
    return Scaffold(
      appBar: AppBar(title: Text(widget.manager ? 'My bids' : 'My quotes'),
        actions: [Padding(padding: const EdgeInsets.all(12),
          child: Center(child: Text('${widget.manager ? store.managerCoins : store.studentCoins} demo coins')))]),
      floatingActionButton: widget.manager ? FloatingActionButton(
        tooltip: 'Post an offer', onPressed: () => Navigator.pushNamed(context, '/manager-post-bid'),
        child: const Icon(Icons.add)) : null,
      body: SafeArea(child: Column(children: [
        if (request != null) Padding(padding: const EdgeInsets.all(12),
          child: Text('${request.city} • ${request.roomType} • ${money(request.budget)} / month')),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Wrap(spacing: 8, children: [
            for (var i = 0; i < 3; i++) ChoiceChip(
              label: Text([widget.manager ? 'Sent' : 'Received', 'Pending', 'Closed'][i]),
              selected: tab == i, onSelected: (_) => setState(() => tab = i)),
          ])),
        Expanded(child: bids.isEmpty ? Center(child: Padding(padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.inbox_outlined, size: 48),
            const SizedBox(height: 12), const Text('No offers in this view.'),
            Text(widget.manager ? 'Post an offer for a matching request.' :
              'Your request is saved locally. Switch to the manager demo to create a matching offer.',
              textAlign: TextAlign.center),
          ]))) : ListView.builder(padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
          itemCount: bids.length, itemBuilder: (context, index) {
            final b = bids[index];
            final hostel = store.hostel(b.hostelId);
            final requirement = store.requirement(b.requirementId);
            if (hostel == null || requirement == null) return const SizedBox.shrink();
            return SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(widget.manager ? requirement.studentName : hostel.name,
                style: Theme.of(context).textTheme.titleMedium),
              Text('${requirement.city} • Request #${requirement.id}'),
              Text('${b.roomType} • ${money(b.price)} / month'),
              Text('Status: ${b.status.name}'),
              if (b.note.isNotEmpty) Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(b.note)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: [
                if (widget.manager && b.status == BidStatus.received)
                  OutlinedButton(onPressed: busy ? null : () => withdraw(b), child: const Text('Withdraw')),
                if (!widget.manager && b.status == BidStatus.received)
                  FilledButton(onPressed: busy ? null : () => unlock(b), child: const Text('Review offer')),
                if (!widget.manager && b.status == BidStatus.pending)
                  FilledButton(onPressed: busy ? null : () => close(b, true), child: const Text('Accept')),
                if (!widget.manager && [BidStatus.received, BidStatus.pending].contains(b.status))
                  OutlinedButton(onPressed: busy ? null : () => close(b, false), child: const Text('Reject')),
                if (b.contactUnlocked && (!widget.manager || b.status == BidStatus.accepted))
                  OutlinedButton(onPressed: () => Navigator.pushNamed(context, '/contact-reveal', arguments: b.id),
                    child: const Text('Contact details')),
                if (b.status == BidStatus.accepted)
                  TextButton(onPressed: () => Navigator.pushNamed(context,
                    widget.manager ? '/hostel-review' : '/student-review',
                    arguments: widget.manager ? {'studentId': requirement.studentId,
                      'studentName': requirement.studentName, 'hostelName': hostel.name} : hostel.id),
                    child: Text(widget.manager ? 'Review student' : 'Review hostel')),
              ]),
            ]));
          })),
      ])),
    );
  });
}
