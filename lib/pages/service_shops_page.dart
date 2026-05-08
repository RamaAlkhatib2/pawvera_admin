import 'package:flutter/material.dart';
import '../widgets/page_scaffold.dart';

class ServiceShopsPage extends StatefulWidget {
  final Function(String) onNavigate;
  const ServiceShopsPage({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<ServiceShopsPage> createState() => _ServiceShopsPageState();
}

class _ServiceShopsPageState extends State<ServiceShopsPage> {
  String q = '';

  final shops = [
    {
      'name': 'Pawfect Spa',
      'category': 'Grooming',
      'owner': 'Emma Wilson',
      'email': 'emma@pawfectspa.com',
      'location': 'Downtown Plaza',
      'bookings': '78',
      'status': 'active',
    },
    {
      'name': 'Happy Tails Training',
      'category': 'Training',
      'owner': 'Mike Brown',
      'email': 'mike@happytails.com',
      'location': 'Park Avenue',
      'bookings': '45',
      'status': 'active',
    },
  ];

  void _openAddServiceDialog() {
    final nameCtl = TextEditingController();
    String category = 'Grooming';
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
              DropdownButtonFormField<String>(
                value: category,
                items: const [
                  DropdownMenuItem(value: 'Grooming', child: Text('Grooming')),
                  DropdownMenuItem(value: 'Training', child: Text('Training')),
                  DropdownMenuItem(value: 'Boarding', child: Text('Boarding')),
                ],
                onChanged: (v) => category = v ?? 'Grooming',
                decoration: const InputDecoration(border: OutlineInputBorder()),
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
            onPressed: () {
              final map = {
                'name': nameCtl.text.isEmpty ? 'New Shop' : nameCtl.text,
                'category': category,
                'owner': ownerCtl.text,
                'email': emailCtl.text,
                'location': locationCtl.text,
                'bookings': '0',
                'status': 'active',
              };
              setState(() => shops.insert(0, map));
              Navigator.of(ctx).pop();
            },
            child: const Text('Add Shop'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = shops
        .where((s) => s['name']!.toLowerCase().contains(q.toLowerCase()))
        .toList();

    return PageScaffold(
      title: 'Service Providers Shops',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage pet care service providers shops and their offerings.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => q = v),
                  decoration: InputDecoration(
                    hintText: 'Search shops, owners, categories...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _openAddServiceDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B233F),
                ),
                child: const Text('+ Add Shop'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Column(
            children: [
              for (var s in filtered)
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
                                  color: const Color(0xFFF0F6F4),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.build),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        s['name']!,
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
                                          s['category']!,
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
                                          s['status']!,
                                          style: const TextStyle(
                                            color: Color(0xFF2F9C76),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Owner: ${s['owner']}',
                                    style: TextStyle(color: Colors.grey.shade700),
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

                      Row(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.email, size: 16, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text(
                                s['email']!,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                          const SizedBox(width: 24),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text(
                                s['location']!,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Bookings: ${s['bookings']}',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          Row(
                            children: [
                              OutlinedButton(
                                onPressed: () {},
                                child: const Text('Deactivate'),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
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
