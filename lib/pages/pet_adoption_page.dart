import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/page_scaffold.dart';

class PetAdoptionPage extends StatefulWidget {
  final Function(String) onNavigate;
  const PetAdoptionPage({super.key, required this.onNavigate});

  @override
  State<PetAdoptionPage> createState() => _PetAdoptionPageState();
}

class _PetAdoptionPageState extends State<PetAdoptionPage> {
  String q = '';
  String statusFilter = 'All Statuses';

  final _col = FirebaseFirestore.instance.collection('adoption_posts');

  Future<void> _setActive(String docId, bool value) async {
    await _col.doc(docId).update({'isActive': value});
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(value ? 'Post activated' : 'Post deactivated')),
    );
  }

  Future<void> _delete(String docId, String petName) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Post'),
        content: Text('Delete "$petName"? This cannot be undone.'),
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
    if (ok == true) await _col.doc(docId).delete();
  }

  void _showDetails(Map<String, dynamic> d, String docId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(d['name'] as String? ?? 'Pet Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if ((d['imageBase64'] as String? ?? '').isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    base64Decode(d['imageBase64'] as String),
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
              const SizedBox(height: 12),
              _detailRow('Category', d['category']),
              _detailRow('Gender', d['gender']),
              _detailRow('Age', d['age']),
              _detailRow('Location', d['location']),
              _detailRow('Price', d['price']),
              _detailRow('Owner', d['ownerName']),
              _detailRow('Vaccinated', (d['isVaccinated'] as bool? ?? false) ? 'Yes' : 'No'),
              _detailRow('Neutered', (d['isNeutered'] as bool? ?? false) ? 'Yes' : 'No'),
              const SizedBox(height: 8),
              const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(d['desc'] as String? ?? '—'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value?.toString() ?? '—'),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> d, String docId) {
    final name = d['name'] as String? ?? 'Unknown';
    final category = d['category'] as String? ?? '';
    final age = d['age'] as String? ?? '';
    final gender = d['gender'] as String? ?? '';
    final location = d['location'] as String? ?? '';
    final ownerName = d['ownerName'] as String? ?? '';
    final desc = d['desc'] as String? ?? '';
    final price = d['price'] as String? ?? '';
    final isActive = d['isActive'] as bool? ?? false;
    final isVaccinated = d['isVaccinated'] as bool? ?? false;
    final isNeutered = d['isNeutered'] as bool? ?? false;

    final border = !isActive
        ? Border.all(color: const Color(0xFFFFD24D))
        : Border.all(color: Colors.grey.shade200);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: border,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    _chip(category, const Color(0xFFF3F4F6), Colors.black87),
                    if (!isActive)
                      _chip('Inactive', const Color(0xFFFFF2D6), const Color(0xFFB37B00))
                    else
                      _chip('Active', const Color(0xFFEFFAF1), const Color(0xFF2F9C76)),
                    if (isVaccinated)
                      _chip('Vaccinated', const Color(0xFFE8F5E9), const Color(0xFF388E3C)),
                    if (isNeutered)
                      _chip('Neutered', const Color(0xFFE3F2FD), const Color(0xFF1565C0)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '$gender • $age • $location',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Owner: $ownerName  •  Price: $price',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                if (desc.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    desc,
                    style: TextStyle(color: Colors.grey.shade600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () => _showDetails(d, docId),
                  icon: const Icon(Icons.remove_red_eye, size: 18),
                  label: const Text('View Details'),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (action) {
              if (action == 'activate') _setActive(docId, true);
              if (action == 'deactivate') _setActive(docId, false);
              if (action == 'delete') _delete(docId, name);
            },
            itemBuilder: (_) => [
              if (!isActive)
                const PopupMenuItem(
                  value: 'activate',
                  child: Row(children: [
                    Icon(Icons.check_circle, color: Color(0xFF2F9C76), size: 18),
                    SizedBox(width: 8),
                    Text('Activate'),
                  ]),
                )
              else
                const PopupMenuItem(
                  value: 'deactivate',
                  child: Row(children: [
                    Icon(Icons.pause_circle, color: Colors.orange, size: 18),
                    SizedBox(width: 8),
                    Text('Deactivate'),
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
    );
  }

  Widget _chip(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: fg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Adoption Listings',
      onNavigate: widget.onNavigate,
      child: StreamBuilder<QuerySnapshot>(
        stream: _col.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];
          final qLower = q.toLowerCase();

          final filtered = docs.where((doc) {
            final d = doc.data() as Map<String, dynamic>;
            final name = (d['name'] as String? ?? '').toLowerCase();
            final category = (d['category'] as String? ?? '').toLowerCase();
            final ownerName = (d['ownerName'] as String? ?? '').toLowerCase();
            final location = (d['location'] as String? ?? '').toLowerCase();

            final matchesSearch = q.isEmpty ||
                name.contains(qLower) ||
                category.contains(qLower) ||
                ownerName.contains(qLower) ||
                location.contains(qLower);

            final isActive = d['isActive'] as bool? ?? false;
            final matchesStatus = statusFilter == 'All Statuses' ||
                (statusFilter == 'Active' && isActive) ||
                (statusFilter == 'Inactive' && !isActive);

            return matchesSearch && matchesStatus;
          }).toList();

          final inactive = filtered.where((d) {
            final data = d.data() as Map<String, dynamic>;
            return !(data['isActive'] as bool? ?? false);
          }).toList();

          final active = filtered.where((d) {
            final data = d.data() as Map<String, dynamic>;
            return data['isActive'] as bool? ?? false;
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Manage pet adoption posts',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => q = v),
                      decoration: InputDecoration(
                        hintText: 'Search by name, category, owner, or location',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
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
                      value: statusFilter,
                      underline: const SizedBox.shrink(),
                      items: const [
                        DropdownMenuItem(
                          value: 'All Statuses',
                          child: Text('All Statuses'),
                        ),
                        DropdownMenuItem(
                          value: 'Inactive',
                          child: Text('Inactive'),
                        ),
                        DropdownMenuItem(
                          value: 'Active',
                          child: Text('Active'),
                        ),
                      ],
                      onChanged: (v) =>
                          setState(() => statusFilter = v ?? 'All Statuses'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(child: CircularProgressIndicator())
              else if (filtered.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.favorite_border,
                            size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          'No adoption listings found',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                if (statusFilter == 'All Statuses' ||
                    statusFilter == 'Inactive') ...[
                  Text(
                    'Inactive Posts (${inactive.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  for (final doc in inactive)
                    _buildCard(doc.data() as Map<String, dynamic>, doc.id),
                  const SizedBox(height: 12),
                ],
                if (statusFilter == 'All Statuses' ||
                    statusFilter == 'Active') ...[
                  Text(
                    'Active Posts (${active.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  for (final doc in active)
                    _buildCard(doc.data() as Map<String, dynamic>, doc.id),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}
