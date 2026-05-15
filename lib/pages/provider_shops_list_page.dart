import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/page_scaffold.dart';

class ProviderShopsListPage extends StatefulWidget {
  final Function(String) onNavigate;
  const ProviderShopsListPage({super.key, required this.onNavigate});

  @override
  State<ProviderShopsListPage> createState() => _ProviderShopsListPageState();
}

class _ProviderShopsListPageState extends State<ProviderShopsListPage> {
  String q = '';

  static const List<String> _categories = [
    'Grooming',
    'Training',
    'Boarding',
    'Daycare',
    'Veterinary',
    'Other',
  ];

  Future<void> _openAddShopDialog() async {
    final nameCtl = TextEditingController();
    final ownerCtl = TextEditingController();
    final emailCtl = TextEditingController();
    final locationCtl = TextEditingController();
    String category = _categories.first;
    bool isSaving = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Add Service Provider Shop'),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Shop Name'),
                  TextField(
                    controller: nameCtl,
                    decoration: _inputDeco('e.g., Pawfect Spa'),
                  ),
                  const SizedBox(height: 14),
                  _label('Category'),
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                    items: _categories
                        .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) =>
                        setDialog(() => category = v ?? _categories.first),
                  ),
                  const SizedBox(height: 14),
                  _label('Owner Name'),
                  TextField(
                    controller: ownerCtl,
                    decoration: _inputDeco('e.g., Emma Wilson'),
                  ),
                  const SizedBox(height: 14),
                  _label('Email'),
                  TextField(
                    controller: emailCtl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDeco('e.g., emma@pawfectspa.com'),
                  ),
                  const SizedBox(height: 14),
                  _label('Location'),
                  TextField(
                    controller: locationCtl,
                    decoration: _inputDeco('e.g., Downtown Plaza'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B233F)),
              onPressed: isSaving
                  ? null
                  : () async {
                      final name = nameCtl.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter a shop name')),
                        );
                        return;
                      }
                      setDialog(() => isSaving = true);
                      try {
                        await FirebaseFirestore.instance
                            .collection('serviceShops')
                            .add({
                          'name': name,
                          'category': category,
                          'owner': ownerCtl.text.trim(),
                          'email': emailCtl.text.trim(),
                          'location': locationCtl.text.trim(),
                          'bookings': 0,
                          'status': 'active',
                          'createdAt': FieldValue.serverTimestamp(),
                        });
                        if (ctx.mounted) Navigator.of(ctx).pop();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Shop "$name" added'),
                              backgroundColor: const Color(0xFF2F9C76),
                            ),
                          );
                        }
                      } catch (e) {
                        setDialog(() => isSaving = false);
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red),
                          );
                        }
                      }
                    },
              child: isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Add Shop'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13)),
      );

  InputDecoration _inputDeco(String hint) => InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      );

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

          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => q = v),
                  decoration: InputDecoration(
                    hintText: 'Search by shop name, owner, or category...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _openAddShopDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B233F),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Shop'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('serviceShops')
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
                  child: Text('Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red)),
                );
              }

              final docs = snapshot.data?.docs ?? [];
              final filtered = docs.where((doc) {
                final d = doc.data() as Map<String, dynamic>;
                final search = q.toLowerCase();
                return (d['name'] as String? ?? '')
                        .toLowerCase()
                        .contains(search) ||
                    (d['owner'] as String? ?? '')
                        .toLowerCase()
                        .contains(search) ||
                    (d['category'] as String? ?? '')
                        .toLowerCase()
                        .contains(search);
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
                              ? 'No shops yet. Click "Add Shop" to create one.'
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
                    .map((doc) => _buildShopCard(
                        doc.data() as Map<String, dynamic>, doc.id))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShopCard(Map<String, dynamic> data, String docId) {
    final name = data['name'] as String? ?? 'Unnamed';
    final category = data['category'] as String? ?? '';
    final owner = data['owner'] as String? ?? '';
    final email = data['email'] as String? ?? '';
    final location = data['location'] as String? ?? '';
    final bookings = data['bookings'] ?? 0;
    final status = data['status'] as String? ?? 'active';
    final isActive = status == 'active';

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
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F6F4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.build, color: Color(0xFF5A9B7E)),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              _chip(category, const Color(0xFFF3F4F6),
                                  Colors.black87),
                              _chip(
                                isActive ? 'Active' : 'Inactive',
                                isActive
                                    ? const Color(0xFFEFFAF1)
                                    : const Color(0xFFF3F4F6),
                                isActive
                                    ? const Color(0xFF2F9C76)
                                    : Colors.grey,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('Owner: $owner',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey.shade700)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showActions(context, data, docId),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 20,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (email.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.email_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(email,
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 13)),
                  ],
                ),
              if (location.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(location,
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 13)),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text('Bookings: $bookings',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade700)),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('serviceShops')
                          .doc(docId)
                          .update({'status': isActive ? 'inactive' : 'active'});
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          isActive ? Colors.orange : const Color(0xFF2F9C76),
                      side: BorderSide(
                          color: isActive
                              ? Colors.orange
                              : const Color(0xFF2F9C76)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(isActive ? 'Deactivate' : 'Activate'),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          title: const Text('Delete Shop'),
                          content: Text(
                              'Are you sure you want to delete "$name"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                      if (ok == true) {
                        await FirebaseFirestore.instance
                            .collection('serviceShops')
                            .doc(docId)
                            .delete();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, Color bg, Color fg) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
        child: Text(label,
            style: TextStyle(
                fontSize: 11, color: fg, fontWeight: FontWeight.w600)),
      );

  void _showActions(
      BuildContext context, Map<String, dynamic> data, String docId) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Shop'),
              onTap: () {
                Navigator.pop(context);
                // TODO: open edit dialog
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Shop',
                  style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                await FirebaseFirestore.instance
                    .collection('serviceShops')
                    .doc(docId)
                    .delete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
