import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/page_scaffold.dart';

class PetTypesPage extends StatefulWidget {
  final Function(String) onNavigate;
  const PetTypesPage({super.key, required this.onNavigate});

  @override
  State<PetTypesPage> createState() => _PetTypesPageState();
}

class _PetTypesPageState extends State<PetTypesPage> {
  String q = '';
  String classification = 'All Classifications';
  String status = 'All Statuses';

  final _col = FirebaseFirestore.instance.collection('pet_types');

  static const _classifications = ['Mammal', 'Bird', 'Reptile', 'Fish', 'Other'];

  Future<void> _openAddTypeDialog() async {
    final nameCtl = TextEditingController();
    final iconCtl = TextEditingController();
    final descCtl = TextEditingController();
    final breedsCtl = TextEditingController();
    String classVal = 'Mammal';
    bool isActive = true;
    bool isSaving = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Add Pet Type'),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Name'),
                  TextField(controller: nameCtl, decoration: _inputDeco('e.g., Dog')),
                  const SizedBox(height: 12),
                  _label('Icon (emoji)'),
                  TextField(controller: iconCtl, decoration: _inputDeco('e.g., 🐶')),
                  const SizedBox(height: 12),
                  _label('Classification'),
                  DropdownButtonFormField<String>(
                    initialValue: classVal,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    items: _classifications
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setDialog(() => classVal = v ?? 'Mammal'),
                  ),
                  const SizedBox(height: 12),
                  _label('Description'),
                  TextField(
                    controller: descCtl,
                    maxLines: 2,
                    decoration: _inputDeco('Short description...'),
                  ),
                  const SizedBox(height: 12),
                  _label('Default Breeds (comma-separated)'),
                  TextField(
                    controller: breedsCtl,
                    maxLines: 2,
                    decoration: _inputDeco('e.g., Labrador, Poodle, Husky'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Active'),
                      const Spacer(),
                      Switch(
                        value: isActive,
                        onChanged: (v) => setDialog(() => isActive = v),
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
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B233F)),
              onPressed: isSaving
                  ? null
                  : () async {
                      final name = nameCtl.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(content: Text('Please enter a name')),
                        );
                        return;
                      }
                      setDialog(() => isSaving = true);
                      final breeds = breedsCtl.text
                          .split(',')
                          .map((s) => s.trim())
                          .where((s) => s.isNotEmpty)
                          .toList();
                      final ref = _col.doc();
                      await ref.set({
                        'id': ref.id,
                        'name': name,
                        'icon': iconCtl.text.trim(),
                        'classification': classVal,
                        'description': descCtl.text.trim(),
                        'breeds': breeds,
                        'isActive': isActive,
                        'createdAt': FieldValue.serverTimestamp(),
                        'updatedAt': FieldValue.serverTimestamp(),
                      });
                      if (ctx.mounted) Navigator.of(ctx).pop();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('"$name" added'),
                            backgroundColor: const Color(0xFF2F9C76),
                          ),
                        );
                      }
                    },
              child: isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Add Pet Type'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openEditDialog(DocumentSnapshot doc) async {
    final d = doc.data() as Map<String, dynamic>;
    final nameCtl = TextEditingController(text: d['name'] as String? ?? '');
    final iconCtl = TextEditingController(text: d['icon'] as String? ?? '');
    final descCtl = TextEditingController(text: d['description'] as String? ?? '');
    final breedsCtl = TextEditingController(
        text: (d['breeds'] as List<dynamic>? ?? []).join(', '));
    String classVal = d['classification'] as String? ?? 'Mammal';
    bool isActive = d['isActive'] as bool? ?? true;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Edit Pet Type'),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Name'),
                  TextField(controller: nameCtl, decoration: _inputDeco('e.g., Dog')),
                  const SizedBox(height: 12),
                  _label('Icon (emoji)'),
                  TextField(controller: iconCtl, decoration: _inputDeco('e.g., 🐶')),
                  const SizedBox(height: 12),
                  _label('Classification'),
                  DropdownButtonFormField<String>(
                    initialValue: classVal,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    items: _classifications
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setDialog(() => classVal = v ?? 'Mammal'),
                  ),
                  const SizedBox(height: 12),
                  _label('Description'),
                  TextField(
                      controller: descCtl,
                      maxLines: 2,
                      decoration: _inputDeco('Short description...')),
                  const SizedBox(height: 12),
                  _label('Default Breeds (comma-separated)'),
                  TextField(
                      controller: breedsCtl,
                      maxLines: 2,
                      decoration: _inputDeco('e.g., Labrador, Poodle, Husky')),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Active'),
                      const Spacer(),
                      Switch(
                        value: isActive,
                        onChanged: (v) => setDialog(() => isActive = v),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B233F)),
              onPressed: () async {
                final name = nameCtl.text.trim();
                if (name.isEmpty) return;
                final breeds = breedsCtl.text
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList();
                await _col.doc(doc.id).update({
                  'name': name,
                  'icon': iconCtl.text.trim(),
                  'classification': classVal,
                  'description': descCtl.text.trim(),
                  'breeds': breeds,
                  'isActive': isActive,
                  'updatedAt': FieldValue.serverTimestamp(),
                });
                if (ctx.mounted) Navigator.of(ctx).pop();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pet type updated')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _delete(String docId, String name) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Pet Type'),
        content: Text('Delete "$name"?'),
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
      await _col.doc(docId).delete();
    }
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      );

  InputDecoration _inputDeco(String hint) => InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      );

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Pet Types',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Manage pet species and their default breeds',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 280,
                child: TextField(
                  onChanged: (v) => setState(() => q = v),
                  decoration: InputDecoration(
                    hintText: 'Search pet types...',
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
                  value: classification,
                  underline: const SizedBox.shrink(),
                  items: ['All Classifications', ..._classifications]
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => classification = v ?? 'All Classifications'),
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
                    DropdownMenuItem(value: 'All Statuses', child: Text('All Statuses')),
                    DropdownMenuItem(value: 'Active', child: Text('Active')),
                    DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
                  ],
                  onChanged: (v) => setState(() => status = v ?? 'All Statuses'),
                ),
              ),
              ElevatedButton(
                onPressed: _openAddTypeDialog,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B233F)),
                child: const Text('+ Add Pet Type'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          StreamBuilder<QuerySnapshot>(
            stream: _col.orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
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
                final name = (d['name'] as String? ?? '').toLowerCase();
                final desc = (d['description'] as String? ?? '').toLowerCase();
                final classif = d['classification'] as String? ?? '';
                final isActive = d['isActive'] as bool? ?? true;

                final matchesSearch = q.isEmpty ||
                    name.contains(qLower) ||
                    desc.contains(qLower);

                final matchesClass = classification == 'All Classifications' ||
                    classif == classification;

                final matchesStatus = status == 'All Statuses' ||
                    (status == 'Active' && isActive) ||
                    (status == 'Inactive' && !isActive);

                return matchesSearch && matchesClass && matchesStatus;
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
                        Icon(Icons.category, size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          docs.isEmpty
                              ? 'No pet types yet. Click "+ Add Pet Type" to create one.'
                              : 'No pet types match your search.',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: filtered.map((doc) {
                  final d = doc.data() as Map<String, dynamic>;
                  final name = d['name'] as String? ?? 'Unknown';
                  final icon = d['icon'] as String? ?? '';
                  final classif = d['classification'] as String? ?? '';
                  final desc = d['description'] as String? ?? '';
                  final breeds = List<String>.from(d['breeds'] as List? ?? []);
                  final isActive = d['isActive'] as bool? ?? true;

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
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDF3E9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                icon.isNotEmpty ? icon : '🐾',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      Text(name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                      _chip(classif, const Color(0xFFF3F4F6),
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
                                  if (desc.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(desc,
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 13)),
                                  ],
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 20),
                                  onPressed: () => _openEditDialog(doc),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red, size: 20),
                                  onPressed: () => _delete(doc.id, name),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (breeds.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          const Text('Breeds:',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: breeds
                                .map((b) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF6F6F6),
                                        borderRadius:
                                            BorderRadius.circular(16),
                                      ),
                                      child: Text(b,
                                          style: const TextStyle(
                                              fontSize: 12)),
                                    ))
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, Color bg, Color fg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
        child: Text(label,
            style: TextStyle(
                fontSize: 11, color: fg, fontWeight: FontWeight.w600)),
      );
}
