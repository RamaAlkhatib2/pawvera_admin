import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/page_scaffold.dart';

class BookingsPage extends StatefulWidget {
  final Function(String) onNavigate;
  const BookingsPage({super.key, required this.onNavigate});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  String _search = '';
  String _statusFilter = 'All';

  static const _statusOptions = ['All', 'pending', 'confirmed', 'completed', 'cancelled'];

  static const _statusColors = {
    'pending': Color(0xFFFFF3CD),
    'confirmed': Color(0xFFD1ECF1),
    'completed': Color(0xFFD4EDDA),
    'cancelled': Color(0xFFF8D7DA),
  };
  static const _statusTextColors = {
    'pending': Color(0xFF856404),
    'confirmed': Color(0xFF0C5460),
    'completed': Color(0xFF155724),
    'cancelled': Color(0xFF721C24),
  };

  String _fmt(dynamic value) {
    if (value == null) return '—';
    if (value is Timestamp) {
      final d = value.toDate();
      return '${d.day}/${d.month}/${d.year}';
    }
    return value.toString();
  }

  Future<void> _updateStatus(String docId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(docId)
        .update({'status': newStatus});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking status updated to "$newStatus"'),
          backgroundColor: const Color(0xFF2F9C76),
        ),
      );
    }
  }

  Future<void> _confirmDelete(String docId, String label) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Booking'),
        content: Text('Delete booking for "$label"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await FirebaseFirestore.instance.collection('bookings').doc(docId).delete();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking deleted'), backgroundColor: Color(0xFF2F9C76)),
      );
    }
  }

  void _showDetail(Map<String, dynamic> d, String docId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Booking — ${d['name'] ?? 'Unknown'}'),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow(Icons.person, 'Customer', d['name'] ?? '—'),
                _detailRow(Icons.email, 'Email', d['email'] ?? '—'),
                _detailRow(Icons.phone, 'Phone', d['phone'] ?? '—'),
                _detailRow(Icons.pets, 'Pet', d['pet'] ?? '—'),
                _detailRow(Icons.medical_services, 'Service', d['service'] ?? '—'),
                _detailRow(Icons.store, 'Provider', d['provider']?.toString().isEmpty == true ? '—' : d['provider'] ?? '—'),
                _detailRow(Icons.calendar_today, 'Date', d['date'] ?? '—'),
                _detailRow(Icons.access_time, 'Time', d['time'] ?? '—'),
                _detailRow(Icons.timer, 'Duration', d['duration'] ?? '—'),
                _detailRow(Icons.attach_money, 'Price', '\$${d['price'] ?? '—'}'),
                _detailRow(Icons.info, 'Status', d['status'] ?? '—'),
                _detailRow(Icons.event, 'Created', _fmt(d['createdAt'])),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Bookings',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('View and manage all service bookings.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    decoration: InputDecoration(
                      hintText: 'Search by name, email, service...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _statusFilter,
                    underline: const SizedBox.shrink(),
                    items: _statusOptions
                        .map((s) => DropdownMenuItem(value: s, child: Text(s == 'All' ? 'All Statuses' : s)))
                        .toList(),
                    onChanged: (v) => setState(() => _statusFilter = v ?? 'All'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('bookings')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Padding(padding: EdgeInsets.all(48), child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) {
                return _errorBox('Error loading bookings: ${snapshot.error}');
              }

              final docs = snapshot.data?.docs ?? [];
              final q = _search.toLowerCase();
              final filtered = docs.where((doc) {
                final d = doc.data() as Map<String, dynamic>;
                final matchSearch = q.isEmpty ||
                    (d['name'] as String? ?? '').toLowerCase().contains(q) ||
                    (d['email'] as String? ?? '').toLowerCase().contains(q) ||
                    (d['service'] as String? ?? '').toLowerCase().contains(q) ||
                    (d['pet'] as String? ?? '').toLowerCase().contains(q);
                final matchStatus = _statusFilter == 'All' || d['status'] == _statusFilter;
                return matchSearch && matchStatus;
              }).toList();

              if (filtered.isEmpty) {
                return _emptyState(docs.isEmpty
                    ? 'No bookings found in the database.'
                    : 'No bookings match your filter.');
              }

              return Column(
                children: filtered.map((doc) {
                  final d = doc.data() as Map<String, dynamic>;
                  return _buildBookingCard(d, doc.id);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> d, String docId) {
    final name = d['name'] as String? ?? 'Unknown';
    final email = d['email'] as String? ?? '—';
    final phone = d['phone'] as String? ?? '—';
    final pet = d['pet'] as String? ?? '—';
    final service = d['service'] as String? ?? '—';
    final date = d['date'] as String? ?? '—';
    final time = d['time'] as String? ?? '—';
    final price = d['price']?.toString() ?? '—';
    final status = (d['status'] as String? ?? 'pending').toLowerCase();
    final bgColor = _statusColors[status] ?? const Color(0xFFF3F4F6);
    final fgColor = _statusTextColors[status] ?? Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F6F4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.event_note, color: Color(0xFF5A9B7E)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(status, style: TextStyle(color: fgColor, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(service, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Actions',
                icon: const Icon(Icons.more_vert),
                onSelected: (v) async {
                  if (v == 'view') {
                    _showDetail(d, docId);
                  } else if (v == 'delete') {
                    await _confirmDelete(docId, name);
                  } else {
                    await _updateStatus(docId, v);
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'view', child: Row(children: [Icon(Icons.visibility_outlined, size: 18), SizedBox(width: 8), Text('View Details')])),
                  const PopupMenuDivider(),
                  const PopupMenuItem(value: 'pending', child: Row(children: [Icon(Icons.hourglass_empty, size: 18), SizedBox(width: 8), Text('Mark Pending')])),
                  const PopupMenuItem(value: 'confirmed', child: Row(children: [Icon(Icons.check_circle_outline, size: 18), SizedBox(width: 8), Text('Confirm')])),
                  const PopupMenuItem(value: 'completed', child: Row(children: [Icon(Icons.done_all, size: 18), SizedBox(width: 8), Text('Complete')])),
                  const PopupMenuItem(value: 'cancelled', child: Row(children: [Icon(Icons.cancel_outlined, size: 18, color: Colors.orange), SizedBox(width: 8), Text('Cancel', style: TextStyle(color: Colors.orange))])),
                  const PopupMenuDivider(),
                  const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 18, color: Colors.red), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))])),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              _infoChip(Icons.email, email),
              _infoChip(Icons.phone, phone),
              _infoChip(Icons.pets, 'Pet: $pet'),
              _infoChip(Icons.calendar_today, '$date  $time'),
              _infoChip(Icons.attach_money, '\$$price'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
      ],
    );
  }

  Widget _errorBox(String msg) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: const Color(0xFFFFECEC), borderRadius: BorderRadius.circular(8)),
        child: Text(msg, style: const TextStyle(color: Colors.red)),
      );

  Widget _emptyState(String msg) => Container(
        padding: const EdgeInsets.symmetric(vertical: 48),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.event_busy, size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(msg, style: TextStyle(color: Colors.grey.shade500)),
            ],
          ),
        ),
      );
}
