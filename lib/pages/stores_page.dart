import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/page_scaffold.dart';

class StoresPage extends StatefulWidget {
  final Function(String) onNavigate;
  const StoresPage({super.key, required this.onNavigate});

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  String q = '';
  String status = 'All Statuses';

  void _openAddStoreDialog() {
    final nameCtl = TextEditingController();
    final ownerCtl = TextEditingController();
    final emailCtl = TextEditingController();
    final locationCtl = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Add New Shop'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtl,
                decoration: InputDecoration(
                  hintText: 'Shop Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ownerCtl,
                decoration: InputDecoration(
                  hintText: 'Owner Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCtl,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationCtl,
                decoration: InputDecoration(
                  hintText: 'Location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final businessName = nameCtl.text.trim().isEmpty
                  ? 'New Store'
                  : nameCtl.text.trim();

              await FirebaseFirestore.instance.collection('users').add({
                'role': 'provider',
                'providerType': 'Pet Supplies Store',
                'businessName': businessName,
                'owner': ownerCtl.text.trim(),
                'email': emailCtl.text.trim(),
                'location': locationCtl.text.trim(),
                'commission': '0%',
                'products': 0,
                'orders': 0,
                'isActive': true,
                'createdAt': FieldValue.serverTimestamp(),
                'createdBy': 'admin',
              });

              if (ctx.mounted) {
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Add Shop'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Pet Supplies Stores',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage pet supplies stores and their product inventory.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => q = v),
                    decoration: InputDecoration(
                      hintText: 'Search stores...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: status,
                    underline: const SizedBox.shrink(),
                    items: const [
                      DropdownMenuItem(
                        value: 'All Statuses',
                        child: Text('All Statuses'),
                      ),
                      DropdownMenuItem(value: 'Active', child: Text('Active')),
                      DropdownMenuItem(
                        value: 'Inactive',
                        child: Text('Inactive'),
                      ),
                    ],
                    onChanged: (v) =>
                        setState(() => status = v ?? 'All Statuses'),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _openAddStoreDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B233F),
                  ),
                  child: const Text('+ Add Store'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('role', isEqualTo: 'provider')
                .where('providerType', isEqualTo: 'Pet Supplies Store')
                .orderBy('createdAt', descending: true)
                .snapshots(),
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
                  child: Text(
                    'Error loading stores: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              final docs = snapshot.data?.docs ?? [];
              final search = q.toLowerCase();
              final filtered = docs.where((doc) {
                final s = doc.data() as Map<String, dynamic>;
                final name = (s['businessName'] as String? ?? '').toLowerCase();
                final email = (s['email'] as String? ?? '').toLowerCase();
                final owner = (s['owner'] as String? ?? '').toLowerCase();
                final matchesSearch = name.contains(search) ||
                    email.contains(search) ||
                    owner.contains(search);

                final isActive = s['isActive'] as bool? ?? true;
                final matchesStatus = status == 'All Statuses' ||
                    (status == 'Active' && isActive) ||
                    (status == 'Inactive' && !isActive);

                return matchesSearch && matchesStatus;
              }).toList();

              if (filtered.isEmpty) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      docs.isEmpty
                          ? 'No pet supplies stores yet. Add one from "Add Provider".'
                          : 'No stores match your search or filter.',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  for (final doc in filtered)
                    _buildStoreCard(doc.data() as Map<String, dynamic>),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(Map<String, dynamic> s) {
    final name = s['businessName'] as String? ?? 'Unnamed Store';
    final owner = s['owner'] as String? ?? 'N/A';
    final email = s['email'] as String? ?? '';
    final location = s['location'] as String? ?? 'N/A';
    final commission = s['commission']?.toString() ?? '0%';
    final products = s['products']?.toString() ?? '0';
    final orders = s['orders']?.toString() ?? '0';
    final isActive = s['isActive'] as bool? ?? true;
    final statusText = isActive ? 'active' : 'inactive';
    final chipBg = isActive ? const Color(0xFFEFFAF1) : const Color(0xFFF3F4F6);
    final chipFg = isActive ? const Color(0xFF2F9C76) : Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F6F4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.store),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: chipBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(color: chipFg),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Owner: $owner',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.email,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    email,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    location,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '%',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    ' Commission: $commission',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Products: $products',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(width: 16),
              Text(
                'Orders: $orders',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
