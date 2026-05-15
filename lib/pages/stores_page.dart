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

              try {
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
                  'updatedAt': FieldValue.serverTimestamp(),
                  'createdBy': 'admin',
                });

                if (ctx.mounted) Navigator.of(ctx).pop();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Store "$businessName" saved to Firestore'),
                    backgroundColor: const Color(0xFF2F9C76),
                  ),
                );
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text('Firestore: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
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
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 280,
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
                    _buildStoreCard(
                      doc.data() as Map<String, dynamic>,
                      doc.id,
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _openEditStoreDialog(
    Map<String, dynamic> initial,
    String docId,
  ) async {
    final nameCtl = TextEditingController(
      text: initial['businessName'] as String? ?? '',
    );
    final ownerCtl = TextEditingController(
      text: initial['owner'] as String? ?? '',
    );
    final emailCtl = TextEditingController(
      text: initial['email'] as String? ?? '',
    );
    final locationCtl = TextEditingController(
      text: initial['location'] as String? ?? '',
    );
    final commissionCtl = TextEditingController(
      text: initial['commission']?.toString() ?? '0%',
    );
    final productsCtl = TextEditingController(
      text: '${initial['products'] ?? 0}',
    );
    final ordersCtl = TextEditingController(
      text: '${initial['orders'] ?? 0}',
    );
    bool isSaving = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Edit Store'),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Firestore: users/$docId',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Changes sync to this document. Login email in Firebase Authentication is only updated if you change it there for accounts created via Add Provider.',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 14),
                  _fieldLabel('Shop name'),
                  TextField(
                    controller: nameCtl,
                    decoration: _inputDecoration('Shop name'),
                  ),
                  const SizedBox(height: 12),
                  _fieldLabel('Owner'),
                  TextField(
                    controller: ownerCtl,
                    decoration: _inputDecoration('Owner name'),
                  ),
                  const SizedBox(height: 12),
                  _fieldLabel('Email'),
                  TextField(
                    controller: emailCtl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration('Email'),
                  ),
                  const SizedBox(height: 12),
                  _fieldLabel('Location'),
                  TextField(
                    controller: locationCtl,
                    decoration: _inputDecoration('Location'),
                  ),
                  const SizedBox(height: 12),
                  _fieldLabel('Commission'),
                  TextField(
                    controller: commissionCtl,
                    decoration: _inputDecoration('e.g. 15%'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel('Products'),
                            TextField(
                              controller: productsCtl,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration('0'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel('Orders'),
                            TextField(
                              controller: ordersCtl,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration('0'),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                backgroundColor: const Color(0xFF0B233F),
              ),
              onPressed: isSaving
                  ? null
                  : () async {
                      final businessName = nameCtl.text.trim();
                      if (businessName.isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(content: Text('Shop name is required')),
                        );
                        return;
                      }
                      final products =
                          int.tryParse(productsCtl.text.trim()) ?? 0;
                      final orders = int.tryParse(ordersCtl.text.trim()) ?? 0;
                      setDialog(() => isSaving = true);
                      try {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(docId)
                            .update({
                          'businessName': businessName,
                          'owner': ownerCtl.text.trim(),
                          'email': emailCtl.text.trim(),
                          'location': locationCtl.text.trim(),
                          'commission': commissionCtl.text.trim().isEmpty
                              ? '0%'
                              : commissionCtl.text.trim(),
                          'products': products,
                          'orders': orders,
                          'updatedAt': FieldValue.serverTimestamp(),
                        });
                        if (ctx.mounted) Navigator.of(ctx).pop();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Store "$businessName" updated'),
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
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
              child: isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );

    nameCtl.dispose();
    ownerCtl.dispose();
    emailCtl.dispose();
    locationCtl.dispose();
    commissionCtl.dispose();
    productsCtl.dispose();
    ordersCtl.dispose();
  }

  Widget _fieldLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      );

  Future<void> _confirmDeleteStore(String docId, String name) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Store'),
        content: Text(
          'Are you sure you want to delete "$name"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await FirebaseFirestore.instance.collection('users').doc(docId).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Store "$name" deleted'),
            backgroundColor: const Color(0xFF2F9C76),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildStoreCard(Map<String, dynamic> s, String docId) {
    final name = s['businessName'] as String? ?? 'Unnamed Store';
    final owner = s['owner'] as String? ?? 'N/A';
    final email = s['email'] as String? ?? '';
    final location = s['location'] as String? ?? 'N/A';
    final commission = s['commission']?.toString() ?? '0%';
    final products = s['products']?.toString() ?? '0';
    final orders = s['orders']?.toString() ?? '0';
    final isActive = s['isActive'] as bool? ?? true;
    final lastWrite =
        s['updatedAt'] as Timestamp? ?? s['createdAt'] as Timestamp?;
    final statusText = isActive ? 'Active' : 'Inactive';
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
              Expanded(
                child: Row(
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
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
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Store actions',
                icon: const Icon(Icons.more_vert),
                onSelected: (value) async {
                  switch (value) {
                    case 'edit':
                      await _openEditStoreDialog(s, docId);
                      break;
                    case 'toggle':
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(docId)
                          .update({
                        'isActive': !isActive,
                        'updatedAt': FieldValue.serverTimestamp(),
                      });
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              !isActive
                                  ? 'Store "$name" activated'
                                  : 'Store "$name" deactivated',
                            ),
                            backgroundColor: const Color(0xFF2F9C76),
                          ),
                        );
                      }
                      break;
                    case 'delete':
                      await _confirmDeleteStore(docId, name);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 20),
                        SizedBox(width: 10),
                        Text('Edit Store'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'toggle',
                    child: Row(
                      children: [
                        Icon(
                          isActive ? Icons.person_off_outlined : Icons.person_outline,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(isActive ? 'Deactivate' : 'Activate'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 20, color: Colors.red),
                        SizedBox(width: 10),
                        Text(
                          'Delete Store',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
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
          if (lastWrite != null) ...[
            const SizedBox(height: 8),
            Text(
              'Firestore last write: ${_formatFirestoreTime(lastWrite)}',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ],
      ),
    );
  }

  String _formatFirestoreTime(Timestamp ts) {
    final d = ts.toDate();
    final m = d.minute.toString().padLeft(2, '0');
    return '${d.day}/${d.month}/${d.year} ${d.hour}:$m';
  }
}
