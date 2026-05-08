import 'package:flutter/material.dart';
import '../widgets/page_scaffold.dart';

class PetTypesPage extends StatefulWidget {
  final Function(String) onNavigate;
  const PetTypesPage({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<PetTypesPage> createState() => _PetTypesPageState();
}

class _PetTypesPageState extends State<PetTypesPage> {
  String q = '';
  String classification = 'All Classifications';
  String status = 'All Statuses';

  final types = [
    {
      'title': 'Dog',
      'subtitle': 'Domesticated canine companion',
      'store': 'Pet Store A',
      'breeds': [
        'Labrador Retriever',
        'Golden Retriever',
        'German Shepherd',
        'Bulldog',
        'Poodle',
      ],
      'status': 'active',
    },
    {
      'title': 'Cat',
      'subtitle': 'Domesticated feline companion',
      'store': 'Pet Store B',
      'breeds': [
        'Persian',
        'Maine Coon',
        'Siamese',
        'British Shorthair',
        'Ragdoll',
      ],
      'status': 'active',
    },
  ];

  void _openAddTypeDialog() {
    final nameCtl = TextEditingController();
    final iconCtl = TextEditingController();
    String classificationVal = 'Mammal';
    final descCtl = TextEditingController();
    final breedsCtl = TextEditingController();
    final storeCtl = TextEditingController();
    String statusVal = 'Active';

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Add Pet Type'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtl,
                decoration: InputDecoration(
                  hintText: 'Pet Type Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: iconCtl,
                decoration: InputDecoration(
                  hintText: 'Icon (Emoji)\ne.g., 🐶',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: classificationVal,
                items: const [
                  DropdownMenuItem(value: 'Mammal', child: Text('Mammal')),
                  DropdownMenuItem(value: 'Bird', child: Text('Bird')),
                  DropdownMenuItem(value: 'Reptile', child: Text('Reptile')),
                  DropdownMenuItem(value: 'Fish', child: Text('Fish')),
                ],
                onChanged: (v) => classificationVal = v ?? 'Mammal',
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: breedsCtl,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText:
                      'Default Breeds (comma-separated)\ne.g., Labrador, Golden Retriever, Poodle',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: storeCtl,
                decoration: InputDecoration(
                  hintText: 'Store',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: statusVal,
                items: const [
                  DropdownMenuItem(value: 'Active', child: Text('Active')),
                  DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
                ],
                onChanged: (v) => statusVal = v ?? 'Active',
                decoration: const InputDecoration(border: OutlineInputBorder()),
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
            onPressed: () {
              final breeds = breedsCtl.text
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();
              final map = {
                'title': nameCtl.text.isEmpty ? 'New Type' : nameCtl.text,
                'icon': iconCtl.text,
                'subtitle': descCtl.text,
                'store': storeCtl.text,
                'breeds': breeds,
                'classification': classificationVal,
                'status': statusVal.toLowerCase(),
              };
              setState(() => types.insert(0, map));
              Navigator.of(ctx).pop();
            },
            child: const Text('Add Pet Type'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = types
        .where(
          (t) => (t['title'] as String).toLowerCase().contains(q.toLowerCase()),
        )
        .toList();

    return PageScaffold(
      title: 'Pet Types Management',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage pet species and their default breeds',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => q = v),
                  decoration: InputDecoration(
                    hintText: 'Search pet types...',
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
                  value: classification,
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(
                      value: 'All Classifications',
                      child: Text('All Classifications'),
                    ),
                  ],
                  onChanged: (v) => setState(
                    () => classification = v ?? 'All Classifications',
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
                  ],
                  onChanged: (v) =>
                      setState(() => status = v ?? 'All Statuses'),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _openAddTypeDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B233F),
                ),
                child: const Text('+ Add Pet Type'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Column(
            children: [
              for (var t in filtered)
                Container(
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
                                  color: const Color(0xFFFDF3E9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.pets),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        (t['title'] as String),
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
                                          color: const Color(0xFFF3F4F6),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          (t['title'] as String),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFFAF1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          (t['status'] as String),
                                          style: const TextStyle(
                                            color: Color(0xFF2F9C76),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    (t['subtitle'] as String),
                                    style: TextStyle(color: Colors.grey.shade700),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Store: ${(t['store'] as String)}',
                                    style: TextStyle(color: Colors.grey.shade700),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  final initial = t;
                                  final nm = TextEditingController(
                                    text: initial['title'] as String? ?? '',
                                  );
                                  final ic = TextEditingController(
                                    text: initial['icon'] as String? ?? '',
                                  );
                                  String classVal =
                                      initial['classification'] as String? ??
                                      'Mammal';
                                  final ds = TextEditingController(
                                    text: initial['subtitle'] as String? ?? '',
                                  );
                                  final br = TextEditingController(
                                    text:
                                        (initial['breeds'] as List?)?.join(', ') ?? '',
                                  );
                                  final st = TextEditingController(
                                    text: initial['store'] as String? ?? '',
                                  );
                                  String stat =
                                      (initial['status'] as String?)?.toLowerCase() ??
                                      'active';

                                  showDialog<void>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      title: const Text('Edit Pet Type'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: nm,
                                              decoration: InputDecoration(
                                                hintText: 'Pet Type Name',
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            TextField(
                                              controller: ic,
                                              decoration: InputDecoration(
                                                hintText: 'Icon (Emoji)\ne.g., 🐶',
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            DropdownButtonFormField<String>(
                                              value: classVal,
                                              items: const [
                                                DropdownMenuItem(
                                                  value: 'Mammal',
                                                  child: Text('Mammal'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'Bird',
                                                  child: Text('Bird'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'Reptile',
                                                  child: Text('Reptile'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'Fish',
                                                  child: Text('Fish'),
                                                ),
                                              ],
                                              onChanged: (v) =>
                                                  classVal = v ?? 'Mammal',
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            TextField(
                                              controller: ds,
                                              maxLines: 3,
                                              decoration: InputDecoration(
                                                hintText: 'Description',
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            TextField(
                                              controller: br,
                                              maxLines: 2,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Default Breeds (comma-separated)\ne.g., Labrador, Golden Retriever, Poodle',
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            TextField(
                                              controller: st,
                                              decoration: InputDecoration(
                                                hintText: 'Store',
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            DropdownButtonFormField<String>(
                                              value:
                                                  stat[0].toUpperCase() +
                                                  stat.substring(1),
                                              items: const [
                                                DropdownMenuItem(
                                                  value: 'Active',
                                                  child: Text('Active'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'Inactive',
                                                  child: Text('Inactive'),
                                                ),
                                              ],
                                              onChanged: (v) =>
                                                  stat = (v ?? 'Active').toLowerCase(),
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
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
                                          onPressed: () {
                                            if (nm.text.trim().isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Please enter a pet type name',
                                                  ),
                                                ),
                                              );
                                              return;
                                            }
                                            final breeds = br.text
                                                .split(',')
                                                .map((s) => s.trim())
                                                .where((s) => s.isNotEmpty)
                                                .toList();
                                            final map = {
                                              'title': nm.text.trim(),
                                              'icon': ic.text.trim(),
                                              'classification': classVal,
                                              'subtitle': ds.text.trim(),
                                              'breeds': breeds,
                                              'store': st.text.trim(),
                                              'status': stat,
                                            };
                                            setState(() {
                                              final idx = types.indexOf(t);
                                              if (idx >= 0) types[idx] = map;
                                            });
                                            Navigator.of(ctx).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text('Pet type updated'),
                                              ),
                                            );
                                          },
                                          child: const Text('Save'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final ok = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Delete Pet Type'),
                                      content: const Text(
                                        'Are you sure you want to delete this pet type?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(true),
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (ok == true) {
                                    setState(() => types.remove(t));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Pet type deleted'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      const Text('Default Breeds:'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (var b in (t['breeds'] as List<String>))
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F6F6),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(b),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
