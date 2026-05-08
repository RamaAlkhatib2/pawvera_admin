import 'package:flutter/material.dart';
import '../widgets/page_scaffold.dart';

class PetsPage extends StatefulWidget {
  final Function(String) onNavigate;
  const PetsPage({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  String q = '';

  final pets = [
    {
      'name': 'Buddy',
      'type': 'Dog',
      'breed': 'Golden Retriever',
      'age': '3 years',
      'color': 'Golden',
      'owner': 'John Smith',
      'registered': 'Jan 15, 2024',
      'qr': true,
    },
    {
      'name': 'Max',
      'type': 'Dog',
      'breed': 'Labrador',
      'age': '5 years',
      'color': 'Black',
      'owner': 'Sarah Johnson',
      'registered': 'Nov 10, 2023',
      'qr': false,
    },
    {
      'name': 'Charlie',
      'type': 'Dog',
      'breed': 'Beagle',
      'age': '4 years',
      'color': 'Tricolor',
      'owner': 'Mike Chen',
      'registered': 'Mar 02, 2024',
      'qr': false,
    },
  ];

  Map<String, List<Map<String, Object>>> _groupByType() {
    final map = <String, List<Map<String, Object>>>{};
    for (var p in pets) {
      final t = (p['type'] as String?) ?? 'Other';
      map.putIfAbsent(t, () => []).add(Map<String, Object>.from(p));
    }
    return map;
  }

  Widget _statCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = pets
        .where(
          (p) => (p['name'] as String).toLowerCase().contains(q.toLowerCase()),
        )
        .toList();
    final grouped = <String, List<Map<String, Object>>>{};
    for (var p in filtered) {
      final t = (p['type'] as String?) ?? 'Other';
      grouped.putIfAbsent(t, () => []).add(Map<String, Object>.from(p));
    }

    final totalPets = pets.length.toString();
    final withQr =
        pets.where((p) => (p['qr'] as bool) == true).length.toString();
    final petTypes = _groupByType().keys.length.toString();

    return PageScaffold(
      title: 'Pet Profiles',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'View and manage all registered pets',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => q = v),
                  decoration: InputDecoration(
                    hintText: 'Search pets...',
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B233F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${pets.length} pets',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(child: _statCard('Total Pets', totalPets)),
              const SizedBox(width: 12),
              Expanded(child: _statCard('With QR Tags', withQr)),
              const SizedBox(width: 12),
              Expanded(child: _statCard('Pet Types', petTypes)),
            ],
          ),

          const SizedBox(height: 18),

          for (var entry in grouped.entries) ...[
            Text(
              '${entry.key} (${entry.value.length})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                for (var p in entry.value)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
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
                                      p['name'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if ((p['qr'] as bool) == true)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFF6FF),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.qr_code,
                                              size: 14,
                                              color: Color(0xFF2F9C76),
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              'QR Tag',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${p['breed']} • ${p['age']} • ${p['color']}',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Owner: ${p['owner']}',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Registered: ${p['registered']}',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 80,
                          child: OutlinedButton(
                            onPressed: () {},
                            child: const Text('View'),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
