import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/page_scaffold.dart';

class PetsPage extends StatefulWidget {
  final Function(String) onNavigate;
  const PetsPage({super.key, required this.onNavigate});

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  String q = '';

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Pet Profiles',
      onNavigate: widget.onNavigate,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('pets')
            .snapshots(),
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

          final allDocs = snapshot.data?.docs ?? []
            ..sort((a, b) {
              final aTs = (a.data() as Map<String, dynamic>)['createdAt'] as Timestamp?;
              final bTs = (b.data() as Map<String, dynamic>)['createdAt'] as Timestamp?;
              if (aTs == null && bTs == null) return 0;
              if (aTs == null) return 1;
              if (bTs == null) return -1;
              return bTs.compareTo(aTs);
            });
          final qLower = q.toLowerCase();

          final filtered = allDocs.where((doc) {
            final d = doc.data() as Map<String, dynamic>;
            final name = (d['name'] as String? ?? '').toLowerCase();
            final breed = (d['breed'] as String? ?? '').toLowerCase();
            final type = (d['type'] as String? ?? (d['category'] as String? ?? '')).toLowerCase();
            final owner = (d['ownerName'] as String? ?? '').toLowerCase();
            return q.isEmpty ||
                name.contains(qLower) ||
                breed.contains(qLower) ||
                type.contains(qLower) ||
                owner.contains(qLower);
          }).toList();

          // Group by type/category
          final grouped = <String, List<QueryDocumentSnapshot>>{};
          for (final doc in filtered) {
            final d = doc.data() as Map<String, dynamic>;
            final type = d['type'] as String? ?? d['category'] as String? ?? 'Other';
            grouped.putIfAbsent(type, () => []).add(doc);
          }

          final totalPets = allDocs.length;
          final withQr = allDocs.where((doc) {
            final d = doc.data() as Map<String, dynamic>;
            return (d['hasQrTag'] as bool? ?? d['qrCode'] != null && (d['qrCode'] as String).isNotEmpty) == true;
          }).length;
          final typeCount = <String>{
            for (final doc in allDocs)
              (doc.data() as Map<String, dynamic>)['type'] as String? ??
                  (doc.data() as Map<String, dynamic>)['category'] as String? ??
                  'Other'
          }.length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'View and manage all registered pets',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 12),

              // Search + count
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => q = v),
                      decoration: InputDecoration(
                        hintText: 'Search by name, breed, type, or owner...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B233F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${filtered.length} pets',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Stat cards
              Row(
                children: [
                  Expanded(child: _statCard('Total Pets', '$totalPets')),
                  const SizedBox(width: 12),
                  Expanded(child: _statCard('With QR Tags', '$withQr')),
                  const SizedBox(width: 12),
                  Expanded(child: _statCard('Pet Types', '$typeCount')),
                ],
              ),

              const SizedBox(height: 18),

              if (filtered.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.pets, size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          allDocs.isEmpty
                              ? 'No pets registered yet'
                              : 'No pets match your search',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                )
              else
                for (final entry in grouped.entries) ...[
                  Text(
                    '${entry.key} (${entry.value.length})',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  for (final doc in entry.value)
                    _buildPetCard(
                        doc.data() as Map<String, dynamic>, doc.id),
                  const SizedBox(height: 16),
                ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildPetCard(Map<String, dynamic> d, String docId) {
    final name = d['name'] as String? ?? 'Unknown';
    final breed = d['breed'] as String? ?? '';
    final age = d['age'] as String? ?? d['age']?.toString() ?? '';
    final color = d['color'] as String? ?? '';
    final gender = d['gender'] as String? ?? '';
    final ownerName = d['ownerName'] as String? ?? '';
    final hasQr = d['hasQrTag'] as bool? ??
        ((d['qrCode'] as String? ?? '').isNotEmpty);
    final createdAt = d['createdAt'] as Timestamp?;
    final isVaccinated = d['isVaccinated'] as bool? ?? false;
    final isNeutered = d['isNeutered'] as bool? ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF3E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.pets, color: Color(0xFFF5A623)),
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
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    if (hasQr)
                      _chip('QR Tag', const Color(0xFFEFF6FF),
                          const Color(0xFF2F9C76)),
                    if (isVaccinated)
                      _chip('Vaccinated', const Color(0xFFE8F5E9),
                          const Color(0xFF388E3C)),
                    if (isNeutered)
                      _chip('Neutered', const Color(0xFFE3F2FD),
                          const Color(0xFF1565C0)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  [
                    if (breed.isNotEmpty) breed,
                    if (age.isNotEmpty) age,
                    if (gender.isNotEmpty) gender,
                    if (color.isNotEmpty) color,
                  ].join(' • '),
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
                if (ownerName.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text('Owner: $ownerName',
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 13)),
                ],
                if (createdAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Registered: ${_formatDate(createdAt.toDate())}',
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value) => Container(
        padding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );

  Widget _chip(String label, Color bg, Color fg) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(12)),
        child: Text(label,
            style: TextStyle(
                fontSize: 11, color: fg, fontWeight: FontWeight.w600)),
      );

  String _formatDate(DateTime dt) =>
      '${dt.day}/${dt.month}/${dt.year}';
}
