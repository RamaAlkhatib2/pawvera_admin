import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/page_scaffold.dart';

class ReviewsPage extends StatefulWidget {
  final Function(String) onNavigate;
  const ReviewsPage({super.key, required this.onNavigate});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  String _search = '';
  String _typeFilter = 'All';
  int _minStars = 0;

  static const _typeOptions = ['All', 'product', 'service', 'store'];

  String _fmt(dynamic value) {
    if (value == null) return '—';
    if (value is Timestamp) {
      final d = value.toDate();
      return '${d.day}/${d.month}/${d.year}';
    }
    return value.toString();
  }

  Future<void> _confirmDelete(String docId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Review'),
        content: const Text('Delete this review? This cannot be undone.'),
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
    await FirebaseFirestore.instance.collection('reviews').doc(docId).delete();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review deleted'), backgroundColor: Color(0xFF2F9C76)),
      );
    }
  }

  Widget _starRow(int stars, {double size = 18}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) => Icon(
        i < stars ? Icons.star : Icons.star_border,
        size: size,
        color: i < stars ? const Color(0xFFFFC107) : Colors.grey.shade300,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Reviews',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Monitor customer reviews and ratings.', style: TextStyle(color: Colors.grey)),
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
                  width: 260,
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    decoration: InputDecoration(
                      hintText: 'Search by comment or user ID...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                _filterDropdown(_typeFilter, _typeOptions, 'Type', (v) => setState(() => _typeFilter = v ?? 'All')),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                  child: DropdownButton<int>(
                    value: _minStars,
                    underline: const SizedBox.shrink(),
                    items: [
                      const DropdownMenuItem(value: 0, child: Text('All Stars')),
                      ...List.generate(5, (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1}+ ★'))),
                    ],
                    onChanged: (v) => setState(() => _minStars = v ?? 0),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('reviews')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Padding(padding: EdgeInsets.all(48), child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) {
                return _errorBox('Error loading reviews: ${snapshot.error}');
              }

              final docs = snapshot.data?.docs ?? [];
              final q = _search.toLowerCase();
              final filtered = docs.where((doc) {
                final d = doc.data() as Map<String, dynamic>;
                final stars = (d['stars'] as int?) ?? (d['stars'] as num?)?.toInt() ?? 0;
                final comment = (d['comment'] as String? ?? '').toLowerCase();
                final userId = (d['userId'] as String? ?? '').toLowerCase();
                final matchSearch = q.isEmpty || comment.contains(q) || userId.contains(q);
                final matchType = _typeFilter == 'All' || d['type'] == _typeFilter;
                final matchStars = _minStars == 0 || stars >= _minStars;
                return matchSearch && matchType && matchStars;
              }).toList();

              if (filtered.isEmpty) {
                return _emptyState(docs.isEmpty ? 'No reviews found.' : 'No reviews match your filter.');
              }

              return Column(
                children: filtered.map((doc) => _buildReviewCard(doc.data() as Map<String, dynamic>, doc.id)).toList(),
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
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
      child: DropdownButton<String>(
        value: value,
        underline: const SizedBox.shrink(),
        items: options.map((s) => DropdownMenuItem(value: s, child: Text(s == 'All' ? 'All Types' : s))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> d, String docId) {
    final stars = (d['stars'] as int?) ?? (d['stars'] as num?)?.toInt() ?? 0;
    final comment = d['comment'] as String? ?? '';
    final type = d['type'] as String? ?? 'product';
    final userId = d['userId'] as String? ?? '—';
    final storeId = d['storeId'] as String? ?? '';
    final productId = d['productId'] as String? ?? '';
    final createdAt = _fmt(d['createdAt']);

    final typeColor = type == 'product'
        ? const Color(0xFFCCE5FF)
        : type == 'service'
            ? const Color(0xFFD4EDDA)
            : const Color(0xFFFFF3CD);
    final typeTextColor = type == 'product'
        ? const Color(0xFF004085)
        : type == 'service'
            ? const Color(0xFF155724)
            : const Color(0xFF856404);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFFFF3CD),
                child: Text(
                  stars.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF856404)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _starRow(stars),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: typeColor, borderRadius: BorderRadius.circular(12)),
                          child: Text(type, style: TextStyle(color: typeTextColor, fontSize: 11)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text('User: $userId', style: TextStyle(color: Colors.grey.shade600, fontSize: 12, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                tooltip: 'Delete review',
                onPressed: () => _confirmDelete(docId),
              ),
            ],
          ),
          if (comment.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(comment, style: const TextStyle(fontSize: 13)),
            ),
          ],
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              _chip(Icons.calendar_today, createdAt),
              if (productId.isNotEmpty) _chip(Icons.inventory_2_outlined, 'Product: ${productId.length > 10 ? productId.substring(0, 10) : productId}...'),
              if (storeId.isNotEmpty) _chip(Icons.store, 'Store: ${storeId.length > 10 ? storeId.substring(0, 10) : storeId}...'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String text) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.grey),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
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
              Icon(Icons.star_border, size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(msg, style: TextStyle(color: Colors.grey.shade500)),
            ],
          ),
        ),
      );
}
