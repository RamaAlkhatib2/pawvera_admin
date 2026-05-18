import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/page_scaffold.dart';

class OrdersPage extends StatefulWidget {
  final Function(String) onNavigate;
  const OrdersPage({super.key, required this.onNavigate});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String _search = '';
  String _statusFilter = 'All';
  String _paymentFilter = 'All';

  static const _statusOptions = ['All', 'pending', 'processing', 'shipped', 'delivered', 'cancelled'];
  static const _paymentOptions = ['All', 'paid', 'unpaid', 'refunded'];

  static const _statusColors = {
    'pending': Color(0xFFFFF3CD),
    'processing': Color(0xFFD1ECF1),
    'shipped': Color(0xFFCCE5FF),
    'delivered': Color(0xFFD4EDDA),
    'cancelled': Color(0xFFF8D7DA),
  };
  static const _statusTextColors = {
    'pending': Color(0xFF856404),
    'processing': Color(0xFF0C5460),
    'shipped': Color(0xFF004085),
    'delivered': Color(0xFF155724),
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
        .collection('orders')
        .doc(docId)
        .update({'status': newStatus, 'updatedAt': FieldValue.serverTimestamp()});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order status updated to "$newStatus"'),
          backgroundColor: const Color(0xFF2F9C76),
        ),
      );
    }
  }

  Future<void> _confirmDelete(String docId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Order'),
        content: const Text('Delete this order? This cannot be undone.'),
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
    await FirebaseFirestore.instance.collection('orders').doc(docId).delete();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order deleted'), backgroundColor: Color(0xFF2F9C76)),
      );
    }
  }

  void _showOrderDetail(Map<String, dynamic> d, String docId) {
    final items = (d['items'] as List<dynamic>? ?? []);
    final addr = d['deliveryAddress'] as Map<String, dynamic>? ?? {};
    final card = d['cardPayment'] as Map<String, dynamic>? ?? {};

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Order #${docId.substring(0, 8).toUpperCase()}'),
        content: SizedBox(
          width: 460,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Order Info'),
                _detailRow('Store', d['storeName'] ?? '—'),
                _detailRow('Status', d['status'] ?? '—'),
                _detailRow('Payment Method', d['paymentMethod'] ?? '—'),
                _detailRow('Payment Status', d['paymentStatus'] ?? '—'),
                if (card.isNotEmpty) _detailRow('Card', '${card['brand']?.toString().toUpperCase() ?? ''} ****${card['lastFourDigits'] ?? ''} — ${card['cardholderName'] ?? ''}'),
                _detailRow('Subtotal', '\$${d['subtotal'] ?? 0}'),
                _detailRow('Delivery Fee', '\$${d['deliveryFee'] ?? 0}'),
                _detailRow('Discount', '\$${d['discount'] ?? 0}'),
                _detailRow('Total', '\$${d['total'] ?? 0}'),
                _detailRow('Ordered', _fmt(d['createdAt'])),

                const SizedBox(height: 12),
                _sectionTitle('Delivery Address'),
                _detailRow('Recipient', addr['fullName'] ?? addr['recipientName'] ?? '—'),
                _detailRow('Phone', addr['phone'] ?? '—'),
                _detailRow('Address', addr['address'] ?? '${addr['street'] ?? ''}, Building ${addr['building'] ?? ''}'),
                _detailRow('City', addr['city'] ?? '—'),

                if (items.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _sectionTitle('Items (${items.length})'),
                  ...items.map((item) {
                    final m = item is Map ? item as Map<String, dynamic> : {};
                    return Container(
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(m['title'] as String? ?? '—', style: const TextStyle(fontWeight: FontWeight.w500)),
                          ),
                          Text('x${m['quantity'] ?? 1}', style: TextStyle(color: Colors.grey.shade600)),
                          const SizedBox(width: 12),
                          Text('\$${m['price'] ?? 0}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }),
                ],
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

  Widget _sectionTitle(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF5A9B7E))),
      );

  Widget _detailRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            ),
            Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Orders',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Monitor and manage all customer orders.', style: TextStyle(color: Colors.grey)),
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
                  width: 280,
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    decoration: InputDecoration(
                      hintText: 'Search by store or order ID...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                _filterDropdown(_statusFilter, _statusOptions, 'Status', (v) => setState(() => _statusFilter = v ?? 'All')),
                _filterDropdown(_paymentFilter, _paymentOptions, 'Payment', (v) => setState(() => _paymentFilter = v ?? 'All')),
              ],
            ),
          ),

          const SizedBox(height: 16),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Padding(padding: EdgeInsets.all(48), child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) {
                return _errorBox('Error loading orders: ${snapshot.error}');
              }

              final docs = snapshot.data?.docs ?? [];
              final q = _search.toLowerCase();
              final filtered = docs.where((doc) {
                final d = doc.data() as Map<String, dynamic>;
                final matchSearch = q.isEmpty ||
                    (d['storeName'] as String? ?? '').toLowerCase().contains(q) ||
                    doc.id.toLowerCase().contains(q) ||
                    (d['id'] as String? ?? '').toLowerCase().contains(q);
                final matchStatus = _statusFilter == 'All' || d['status'] == _statusFilter;
                final matchPayment = _paymentFilter == 'All' || d['paymentStatus'] == _paymentFilter;
                return matchSearch && matchStatus && matchPayment;
              }).toList();

              if (filtered.isEmpty) {
                return _emptyState(docs.isEmpty ? 'No orders yet.' : 'No orders match your filter.');
              }

              return Column(
                children: filtered.map((doc) {
                  final d = doc.data() as Map<String, dynamic>;
                  return _buildOrderCard(d, doc.id);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _filterDropdown(String value, List<String> options, String label, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: value,
        underline: const SizedBox.shrink(),
        items: options
            .map((s) => DropdownMenuItem(value: s, child: Text(s == 'All' ? 'All $label' : s)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> d, String docId) {
    final storeName = d['storeName'] as String? ?? '—';
    final status = (d['status'] as String? ?? 'pending').toLowerCase();
    final paymentStatus = d['paymentStatus'] as String? ?? '—';
    final paymentMethod = d['paymentMethod'] as String? ?? '—';
    final total = d['total']?.toString() ?? '0';
    final items = (d['items'] as List<dynamic>? ?? []);
    final createdAt = _fmt(d['createdAt']);
    final bgColor = _statusColors[status] ?? const Color(0xFFF3F4F6);
    final fgColor = _statusTextColors[status] ?? Colors.grey;
    final shortId = docId.length >= 8 ? docId.substring(0, 8).toUpperCase() : docId.toUpperCase();

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
                child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF5A9B7E)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text('Order #$shortId', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
                          child: Text(status, style: TextStyle(color: fgColor, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(storeName, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Actions',
                icon: const Icon(Icons.more_vert),
                onSelected: (v) async {
                  if (v == 'view') {
                    _showOrderDetail(d, docId);
                  } else if (v == 'delete') {
                    await _confirmDelete(docId);
                  } else {
                    await _updateStatus(docId, v);
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'view', child: Row(children: [Icon(Icons.visibility_outlined, size: 18), SizedBox(width: 8), Text('View Details')])),
                  const PopupMenuDivider(),
                  const PopupMenuItem(value: 'pending', child: Row(children: [Icon(Icons.hourglass_empty, size: 18), SizedBox(width: 8), Text('Mark Pending')])),
                  const PopupMenuItem(value: 'processing', child: Row(children: [Icon(Icons.sync, size: 18), SizedBox(width: 8), Text('Processing')])),
                  const PopupMenuItem(value: 'shipped', child: Row(children: [Icon(Icons.local_shipping_outlined, size: 18), SizedBox(width: 8), Text('Shipped')])),
                  const PopupMenuItem(value: 'delivered', child: Row(children: [Icon(Icons.done_all, size: 18), SizedBox(width: 8), Text('Delivered')])),
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
              _chip(Icons.receipt_long, '${items.length} item${items.length == 1 ? '' : 's'}'),
              _chip(Icons.attach_money, 'Total: \$$total'),
              _chip(Icons.payment, '$paymentMethod · $paymentStatus'),
              _chip(Icons.calendar_today, createdAt),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String text) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
        ],
      );

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
              Icon(Icons.shopping_bag_outlined, size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(msg, style: TextStyle(color: Colors.grey.shade500)),
            ],
          ),
        ),
      );
}
