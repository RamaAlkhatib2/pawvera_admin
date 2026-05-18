import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/page_scaffold.dart';

class ProductsPage extends StatefulWidget {
  final Function(String) onNavigate;
  const ProductsPage({super.key, required this.onNavigate});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _search = '';
  String _categoryFilter = 'All';
  String _statusFilter = 'All';

  static const _statusOptions = ['All', 'Active', 'Inactive'];

  String _fmt(dynamic value) {
    if (value == null) return '—';
    if (value is Timestamp) {
      final d = value.toDate();
      return '${d.day}/${d.month}/${d.year}';
    }
    return value.toString();
  }

  Future<void> _toggleActive(String docId, bool current) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(docId)
        .update({'isActive': !current, 'updatedAt': FieldValue.serverTimestamp()});
  }

  Future<void> _confirmDelete(String docId, String name) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Product'),
        content: Text('Delete "$name"? This cannot be undone.'),
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
    await FirebaseFirestore.instance.collection('products').doc(docId).delete();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product "$name" deleted'), backgroundColor: const Color(0xFF2F9C76)),
      );
    }
  }

  Future<void> _openEditDialog(Map<String, dynamic> initial, String docId) async {
    final titleCtl = TextEditingController(text: initial['title'] as String? ?? '');
    final brandCtl = TextEditingController(text: initial['brand'] as String? ?? '');
    final categoryCtl = TextEditingController(text: initial['category'] as String? ?? '');
    final priceCtl = TextEditingController(text: (initial['price'] ?? '').toString());
    final stockCtl = TextEditingController(text: (initial['stock'] ?? '').toString());
    final descCtl = TextEditingController(text: initial['description'] as String? ?? '');
    bool saving = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Edit Product'),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Title'),
                  TextField(controller: titleCtl, decoration: _dec('Product title')),
                  const SizedBox(height: 10),
                  _label('Brand'),
                  TextField(controller: brandCtl, decoration: _dec('Brand name')),
                  const SizedBox(height: 10),
                  _label('Category'),
                  TextField(controller: categoryCtl, decoration: _dec('e.g. Toys, Food')),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          _label('Price (\$)'),
                          TextField(controller: priceCtl, keyboardType: TextInputType.number, decoration: _dec('0')),
                        ]),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          _label('Stock'),
                          TextField(controller: stockCtl, keyboardType: TextInputType.number, decoration: _dec('0')),
                        ]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _label('Description'),
                  TextField(controller: descCtl, maxLines: 3, decoration: _dec('Product description')),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: saving ? null : () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5A9B7E)),
              onPressed: saving
                  ? null
                  : () async {
                      final title = titleCtl.text.trim();
                      if (title.isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Title is required')));
                        return;
                      }
                      setD(() => saving = true);
                      try {
                        await FirebaseFirestore.instance.collection('products').doc(docId).update({
                          'title': title,
                          'brand': brandCtl.text.trim(),
                          'category': categoryCtl.text.trim(),
                          'price': num.tryParse(priceCtl.text.trim()) ?? 0,
                          'stock': int.tryParse(stockCtl.text.trim()) ?? 0,
                          'description': descCtl.text.trim(),
                          'updatedAt': FieldValue.serverTimestamp(),
                        });
                        if (ctx.mounted) Navigator.of(ctx).pop();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('"$title" updated'), backgroundColor: const Color(0xFF2F9C76)),
                          );
                        }
                      } catch (e) {
                        setD(() => saving = false);
                        if (ctx.mounted) ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
                      }
                    },
              child: saving
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
    titleCtl.dispose(); brandCtl.dispose(); categoryCtl.dispose();
    priceCtl.dispose(); stockCtl.dispose(); descCtl.dispose();
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      );

  InputDecoration _dec(String hint) => InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      );

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Products',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Manage products listed by pet supply stores.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('products').snapshots(),
            builder: (context, catSnapshot) {
              final categories = <String>{'All'};
              if (catSnapshot.hasData) {
                for (final doc in catSnapshot.data!.docs) {
                  final cat = (doc.data() as Map<String, dynamic>)['category'] as String?;
                  if (cat != null && cat.isNotEmpty) categories.add(cat);
                }
              }
              final catList = categories.toList()..sort((a, b) => a == 'All' ? -1 : a.compareTo(b));

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: 260,
                          child: TextField(
                            onChanged: (v) => setState(() => _search = v),
                            decoration: InputDecoration(
                              hintText: 'Search products...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        _dropdown(_categoryFilter, catList, 'Category', (v) => setState(() => _categoryFilter = v ?? 'All')),
                        _dropdown(_statusFilter, _statusOptions, 'Status', (v) => setState(() => _statusFilter = v ?? 'All')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: Padding(padding: EdgeInsets.all(48), child: CircularProgressIndicator()));
                      }
                      if (snapshot.hasError) {
                        return _errorBox('Error loading products: ${snapshot.error}');
                      }

                      final docs = snapshot.data?.docs ?? [];
                      final q = _search.toLowerCase();
                      final filtered = docs.where((doc) {
                        final d = doc.data() as Map<String, dynamic>;
                        final matchSearch = q.isEmpty ||
                            (d['title'] as String? ?? '').toLowerCase().contains(q) ||
                            (d['brand'] as String? ?? '').toLowerCase().contains(q) ||
                            (d['category'] as String? ?? '').toLowerCase().contains(q);
                        final matchCat = _categoryFilter == 'All' || d['category'] == _categoryFilter;
                        final isActive = d['isActive'] as bool? ?? true;
                        final matchStatus = _statusFilter == 'All' ||
                            (_statusFilter == 'Active' && isActive) ||
                            (_statusFilter == 'Inactive' && !isActive);
                        return matchSearch && matchCat && matchStatus;
                      }).toList();

                      if (filtered.isEmpty) {
                        return _emptyState(docs.isEmpty ? 'No products found.' : 'No products match your filter.');
                      }

                      return Column(
                        children: filtered.map((doc) => _buildProductCard(doc.data() as Map<String, dynamic>, doc.id)).toList(),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _dropdown(String value, List<String> options, String label, ValueChanged<String?> onChanged) {
    final safeValue = options.contains(value) ? value : options.first;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
      child: DropdownButton<String>(
        value: safeValue,
        underline: const SizedBox.shrink(),
        items: options.map((s) => DropdownMenuItem(value: s, child: Text(s == 'All' ? 'All $label' : s))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> d, String docId) {
    final title = d['title'] as String? ?? 'Untitled';
    final brand = d['brand'] as String? ?? '—';
    final category = d['category'] as String? ?? '—';
    final price = d['price']?.toString() ?? '0';
    final stock = d['stock']?.toString() ?? '0';
    final isActive = d['isActive'] as bool? ?? true;
    final createdAt = _fmt(d['createdAt']);
    final description = d['description'] as String? ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F6F4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.inventory_2_outlined, color: Color(0xFF5A9B7E), size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFFD4EDDA) : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isActive ? 'Active' : 'Inactive',
                        style: TextStyle(color: isActive ? const Color(0xFF155724) : Colors.grey, fontSize: 12),
                      ),
                    ),
                    PopupMenuButton<String>(
                      tooltip: 'Actions',
                      icon: const Icon(Icons.more_vert),
                      onSelected: (v) async {
                        if (v == 'edit') await _openEditDialog(d, docId);
                        if (v == 'toggle') await _toggleActive(docId, isActive);
                        if (v == 'delete') await _confirmDelete(docId, title);
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined, size: 18), SizedBox(width: 8), Text('Edit')])),
                        PopupMenuItem(value: 'toggle', child: Row(children: [Icon(isActive ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18), SizedBox(width: 8), Text(isActive ? 'Deactivate' : 'Activate')])),
                        const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 18, color: Colors.red), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))])),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('$brand · $category', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                ],
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 6,
                  children: [
                    _chip(Icons.attach_money, '\$$price'),
                    _chip(Icons.inventory, 'Stock: $stock'),
                    _chip(Icons.calendar_today, createdAt),
                  ],
                ),
              ],
            ),
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
              Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(msg, style: TextStyle(color: Colors.grey.shade500)),
            ],
          ),
        ),
      );
}
