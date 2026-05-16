import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/page_scaffold.dart';

class ProviderShopsListPage extends StatefulWidget {
  final Function(String) onNavigate;
  const ProviderShopsListPage({super.key, required this.onNavigate});

  @override
  State<ProviderShopsListPage> createState() => _ProviderShopsListPageState();
}

class _ProviderShopsListPageState extends State<ProviderShopsListPage> {
  String q = '';

  final _col = FirebaseFirestore.instance.collection('service_shops');

  Future<void> _toggleOpen(String docId, bool current) async {
    await _col.doc(docId).update({
      'isOpen': !current,
      'status': current ? 'Closed' : 'Open',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _delete(String docId, String name) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Shop'),
        content: Text('Are you sure you want to delete "$name"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      try {
        await _col.doc(docId).delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('"$name" deleted'),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Service Provider Shops',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage pet care service shops and their offerings',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          TextField(
            onChanged: (v) => setState(() => q = v),
            decoration: InputDecoration(
              hintText: 'Search by shop name, email, or address...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),

          const SizedBox(height: 16),

          StreamBuilder<QuerySnapshot>(
            stream: _col.orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECEC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red)),
                );
              }

              final docs = snapshot.data?.docs ?? [];
              final qLower = q.toLowerCase();
              final filtered = docs.where((doc) {
                final d = doc.data() as Map<String, dynamic>;
                return (d['shopName'] as String? ?? '').toLowerCase().contains(qLower) ||
                    (d['email'] as String? ?? '').toLowerCase().contains(qLower) ||
                    (d['address'] as String? ?? '').toLowerCase().contains(qLower);
              }).toList();

              if (filtered.isEmpty) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.storefront_outlined,
                            size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          docs.isEmpty
                              ? 'No service shops found.'
                              : 'No shops match your search.',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: filtered
                    .map((doc) =>
                        _buildShopCard(doc.data() as Map<String, dynamic>, doc.id))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShopCard(Map<String, dynamic> d, String docId) {
    final name = d['shopName'] as String? ?? 'Unnamed';
    final email = d['email'] as String? ?? '';
    final phone = d['phone'] as String? ?? '';
    final address = d['address'] as String? ?? '';
    final workingHours = d['workingHours'] as String? ?? '';
    final isOpen = d['isOpen'] as bool? ?? false;
    final totalBookings = d['totalBookings'] ?? 0;
    final activeBookings = d['activeBookings'] ?? 0;
    final servicesCount = d['activeServicesCount'] ?? 0;
    final totalRevenue = d['totalRevenue'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: isOpen ? const Color(0xFF2F9C76) : Colors.grey.shade300,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F6F4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.storefront, color: Color(0xFF5A9B7E), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        _chip(
                          isOpen ? 'Open' : 'Closed',
                          isOpen ? const Color(0xFFEFFAF1) : const Color(0xFFF3F4F6),
                          isOpen ? const Color(0xFF2F9C76) : Colors.grey,
                        ),
                      ],
                    ),
                    if (workingHours.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time, size: 13, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(workingHours,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (action) {
                  if (action == 'toggle') _toggleOpen(docId, isOpen);
                  if (action == 'delete') _delete(docId, name);
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'toggle',
                    child: Row(children: [
                      Icon(
                        isOpen ? Icons.pause_circle : Icons.play_circle,
                        color: isOpen ? Colors.orange : const Color(0xFF2F9C76),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(isOpen ? 'Mark Closed' : 'Mark Open'),
                    ]),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(children: [
                      Icon(Icons.delete, color: Colors.red, size: 18),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ]),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Contact info
          Wrap(
            spacing: 20,
            runSpacing: 8,
            children: [
              if (email.isNotEmpty) _infoItem(Icons.email_outlined, email),
              if (phone.isNotEmpty) _infoItem(Icons.phone_outlined, phone),
              if (address.isNotEmpty) _infoItem(Icons.location_on_outlined, address),
            ],
          ),

          const SizedBox(height: 12),

          // Stats row
          Row(
            children: [
              _statBox('Total Bookings', '$totalBookings', const Color(0xFF5A9B7E)),
              const SizedBox(width: 8),
              _statBox('Active Bookings', '$activeBookings', const Color(0xFFF5A623)),
              const SizedBox(width: 8),
              _statBox('Services', '$servicesCount', const Color(0xFF9B7BD7)),
              const SizedBox(width: 8),
              _statBox('Revenue', '\$$totalRevenue', const Color(0xFF2D9CDB)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String text) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.grey),
          const SizedBox(width: 4),
          Text(text,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
        ],
      );

  Widget _statBox(String label, String value, Color color) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: color)),
              Text(label,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            ],
          ),
        ),
      );

  Widget _chip(String label, Color bg, Color fg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
        child: Text(label,
            style: TextStyle(
                fontSize: 11, color: fg, fontWeight: FontWeight.w600)),
      );
}
