import 'package:flutter/material.dart';
import '../widgets/page_scaffold.dart';

class QrTagsPage extends StatefulWidget {
  final Function(String) onNavigate;
  const QrTagsPage({super.key, required this.onNavigate});

  @override
  State<QrTagsPage> createState() => _QrTagsPageState();
}

class _QrTagsPageState extends State<QrTagsPage> {
  String q = '';

  final tags = [
    {
      'id': 'QR-2025-001',
      'pet': 'Max',
      'owner': 'Sarah Johnson',
      'date': '1/5/2025',
      'scans': '24',
    },
    {
      'id': 'QR-2025-002',
      'pet': 'Luna',
      'owner': 'Mike Chen',
      'date': '1/3/2025',
      'scans': '15',
    },
    {
      'id': 'QR-2024-158',
      'pet': 'Charlie',
      'owner': 'Emma Davis',
      'date': '12/20/2024',
      'scans': '8',
    },
    {
      'id': 'QR-2025-003',
      'pet': 'Bella',
      'owner': 'John Smith',
      'date': '1/2/2025',
      'scans': '32',
    },
    {
      'id': 'QR-2024-145',
      'pet': 'Rocky',
      'owner': 'Lisa Brown',
      'date': '12/15/2024',
      'scans': '5',
    },
  ];

  int get totalScans =>
      tags.fold<int>(0, (s, t) => s + (int.tryParse(t['scans']!) ?? 0));

  double get avgScans => tags.isEmpty ? 0 : totalScans / tags.length;

  Widget _statCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final qLower = q.toLowerCase();
    final filtered = tags
        .where(
          (t) =>
              t['id']!.toLowerCase().contains(qLower) ||
              t['pet']!.toLowerCase().contains(qLower) ||
              t['owner']!.toLowerCase().contains(qLower),
        )
        .toList();

    return PageScaffold(
      title: 'QR Tags',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monitor QR tag usage and scan analytics across the platform.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _statCard(
                'Total Tags',
                tags.length.toString(),
                const Color(0xFF9B7BD7),
                Icons.qr_code,
              ),
              _statCard(
                'Total Scans',
                totalScans.toString(),
                const Color(0xFF6FB4FF),
                Icons.bar_chart,
              ),
              _statCard(
                'Avg Scans/Tag',
                avgScans.toStringAsFixed(0),
                const Color(0xFF7EE9D1),
                Icons.show_chart,
              ),
            ],
          ),

          const SizedBox(height: 12),

          TextField(
            onChanged: (v) => setState(() => q = v),
            decoration: InputDecoration(
              hintText: 'Search by pet name, owner, or QR code...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'All QR Tags',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.grey.shade200),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      const SizedBox(width: 36),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Tag ID',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Pet Name',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Owner',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Created Date',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Total Scans',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                Column(
                  children: [
                    for (var t in filtered)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4E7FF),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.qr_code,
                                color: Color(0xFF8F56D6),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: Text(
                                t['id']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                t['pet']!,
                                style: TextStyle(color: Colors.grey.shade800),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                t['owner']!,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                t['date']!,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  t['scans']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
