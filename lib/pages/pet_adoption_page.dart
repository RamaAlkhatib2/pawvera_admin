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

  final apps = <Map<String, String>>[];

  void _approve(Map<String, String> app) {
    setState(() {
      final idx = apps.indexOf(app);
      if (idx != -1) apps[idx]['status'] = 'approved';
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Application approved')));
  }

  void _reject(Map<String, String> app) {
    setState(() {
      final idx = apps.indexOf(app);
      if (idx != -1) apps[idx]['status'] = 'rejected';
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Application rejected')));
  }

  Widget _buildCard(Map<String, String> a, {required bool pending}) {
    final border = pending
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
                      a['name']!,
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
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        a['type']!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    if (pending)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF2D6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Pending',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFB37B00),
                          ),
                        ),
                      )
                    else if (a['status'] == 'approved')
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFFAF1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Approved',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF2F9C76),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${a['breed']} • ${a['age']}',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 6),
                Text(
                  'By ${a['owner']}',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                Text(a['desc']!, style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.remove_red_eye, size: 18),
                  label: const Text('View Details'),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (pending)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () => _approve(a),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F9C76),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check, size: 16),
                          SizedBox(width: 8),
                          Text('Approve'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _reject(a),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD93D3D),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.close, size: 16),
                          SizedBox(width: 8),
                          Text('Reject'),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final qLower = q.toLowerCase();
    final searched = apps
        .where(
          (a) =>
              a['name']!.toLowerCase().contains(qLower) ||
              a['breed']!.toLowerCase().contains(qLower) ||
              a['owner']!.toLowerCase().contains(qLower),
        )
        .toList();

    List<Map<String, String>> filtered;
    if (statusFilter == 'Pending') {
      filtered = searched.where((a) => a['status'] == 'pending').toList();
    } else if (statusFilter == 'Approved') {
      filtered = searched.where((a) => a['status'] == 'approved').toList();
    } else {
      filtered = searched;
    }

    final pending = filtered.where((a) => a['status'] == 'pending').toList();
    final approved = filtered.where((a) => a['status'] == 'approved').toList();

    return PageScaffold(
      title: 'Adoption Listings',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage pet adoption requests and approvals',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => q = v),
                  decoration: InputDecoration(
                    hintText: 'Search by name, breed, or owner',
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
                  value: statusFilter,
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(
                      value: 'All Statuses',
                      child: Text('All Statuses'),
                    ),
                    DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                    DropdownMenuItem(
                      value: 'Approved',
                      child: Text('Approved'),
                    ),
                  ],
                  onChanged: (v) =>
                      setState(() => statusFilter = v ?? 'All Statuses'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          if (pending.isEmpty && approved.isEmpty)
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
                      'No adoption listings yet',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            ),

          if (statusFilter == 'All Statuses' || statusFilter == 'Pending') ...[
            Text(
              'Pending Approval (${pending.length})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            for (var a in pending) _buildCard(a, pending: true),
            const SizedBox(height: 12),
          ],

          if (statusFilter == 'All Statuses' || statusFilter == 'Approved') ...[
            Text(
              'Approved Listings (${approved.length})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            for (var a in approved) _buildCard(a, pending: false),
          ],
        ],
      ),
    );
  }
}
