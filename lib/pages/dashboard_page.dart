import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/page_scaffold.dart';

class DashboardPage extends StatelessWidget {
  final Function(String) onNavigate;
  const DashboardPage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Dashboard',
      onNavigate: onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Welcome back! Here's what's happening with your platform.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // ── Stat cards ──────────────────────────────────────────
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 16.0;
              final cardWidth = (constraints.maxWidth - spacing * 3) / 4;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: _CountCard(
                      label: 'Total Users',
                      icon: Icons.people,
                      color: const Color(0xFF2D9CDB),
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .snapshots(),
                      countFilter: (d) => d['role'] != 'provider' && d['role'] != 'admin',
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _CountCard(
                      label: 'Registered Pets',
                      icon: Icons.pets,
                      color: const Color(0xFF2FCF77),
                      stream: FirebaseFirestore.instance
                          .collectionGroup('pets')
                          .snapshots(),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _CountCard(
                      label: 'Online Stores',
                      icon: Icons.store,
                      color: const Color(0xFF6FC7FF),
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('role', isEqualTo: 'provider')
                          .where('providerType', isEqualTo: 'Pet Supplies Store')
                          .snapshots(),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _CountCard(
                      label: 'Service Shops',
                      icon: Icons.build,
                      color: const Color(0xFFF7B267),
                      stream: FirebaseFirestore.instance
                          .collection('service_shops')
                          .snapshots(),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // ── Adoption pending banner ──────────────────────────────
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('adoption_posts')
                .where('isActive', isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              final count = snapshot.data?.docs.length ?? 0;
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: count > 0
                      ? const Color(0xFFFFF4DB)
                      : const Color(0xFFEFFAF1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: count > 0
                        ? const Color(0xFFFFE4A3)
                        : const Color(0xFFB6E2CF),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: count > 0
                                  ? const Color(0xFFFFF1D6)
                                  : const Color(0xFFDDF5EA),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              count > 0
                                  ? Icons.info_outline
                                  : Icons.check_circle_outline,
                              color: count > 0
                                  ? const Color(0xFFF7A600)
                                  : const Color(0xFF2F9C76),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  count > 0
                                      ? '$count pending adoption approval${count > 1 ? 's' : ''}'
                                      : 'No pending adoption approvals',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  count > 0
                                      ? 'Tap Review to manage listings'
                                      : 'All adoption posts are active',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => onNavigate('adoption'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B233F),
                      ),
                      child: const Text('Review'),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Left column ──────────────────────────────────────
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    // Quick Actions
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Quick Actions',
                              style:
                                  TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _quickAction(
                                  label: '+ Add Provider',
                                  color: const Color(0xFFEFF6FF),
                                  textColor: const Color(0xFF2D9CDB),
                                  onTap: () => onNavigate('services'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _quickAction(
                                  label: '+ Add Service Shop',
                                  color: const Color(0xFFFFF6EE),
                                  textColor: const Color(0xFFDF8A5A),
                                  onTap: () => onNavigate('providerShops'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _quickAction(
                                  label: '+ Add Supplies Store',
                                  color: const Color(0xFFEFFAF8),
                                  textColor: const Color(0xFF2F9C76),
                                  onTap: () => onNavigate('stores'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Adoption posts summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Recent Adoption Posts',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              TextButton(
                                onPressed: () => onNavigate('adoption'),
                                child: const Text('View all'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('adoption_posts')
                                .orderBy('createdAt', descending: true)
                                .limit(5)
                                .snapshots(),
                            builder: (context, snapshot) {
                              final docs = snapshot.data?.docs ?? [];
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (docs.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16),
                                  child: Center(
                                    child: Text('No adoption posts yet',
                                        style: TextStyle(
                                            color: Colors.grey.shade500)),
                                  ),
                                );
                              }
                              return Column(
                                children: docs.map((doc) {
                                  final d = doc.data()
                                      as Map<String, dynamic>;
                                  final name =
                                      d['name'] as String? ?? '—';
                                  final category =
                                      d['category'] as String? ?? '';
                                  final owner =
                                      d['ownerName'] as String? ?? '';
                                  final isActive =
                                      d['isActive'] as bool? ?? false;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.pets,
                                            size: 16,
                                            color: Color(0xFF5A9B7E)),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            '$name ($category) — $owner',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 13),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isActive
                                                ? const Color(0xFFEFFAF1)
                                                : const Color(0xFFFFF2D6),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            isActive
                                                ? 'Active'
                                                : 'Inactive',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: isActive
                                                  ? const Color(0xFF2F9C76)
                                                  : const Color(0xFFB37B00),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // ── Right column — Recent users ───────────────────────
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Recent Users',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .orderBy('createdAt', descending: true)
                            .limit(6)
                            .snapshots(),
                        builder: (context, snapshot) {
                          final docs = snapshot.data?.docs ?? [];
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (docs.isEmpty) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: Text('No users yet',
                                    style: TextStyle(
                                        color: Colors.grey.shade500)),
                              ),
                            );
                          }
                          return Column(
                            children: docs.map((doc) {
                              final d =
                                  doc.data() as Map<String, dynamic>;
                              final name = d['name'] as String? ??
                                  d['displayName'] as String? ??
                                  'Unknown';
                              final email =
                                  d['email'] as String? ?? '';
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor:
                                          const Color(0xFF5A9B7E)
                                              .withValues(alpha: 0.15),
                                      child: Text(
                                        name.isNotEmpty
                                            ? name[0].toUpperCase()
                                            : '?',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF5A9B7E),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(name,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight:
                                                      FontWeight.w500)),
                                          Text(email,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors
                                                      .grey.shade500)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickAction({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(label, style: TextStyle(color: textColor)),
        ),
      ),
    );
  }
}

// ── Reusable count card with live StreamBuilder ─────────────────────────────
class _CountCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Stream<QuerySnapshot> stream;
  final bool Function(Map<String, dynamic>)? countFilter;

  const _CountCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.stream,
    this.countFilter,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? [];
        final count = countFilter == null
            ? docs.length
            : docs
                .where((d) =>
                    countFilter!(d.data() as Map<String, dynamic>))
                .length;
        final loading =
            snapshot.connectionState == ConnectionState.waiting;
        return Container(
          padding:
              const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 10),
              loading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: color),
                    )
                  : Text(
                      '$count',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
              const SizedBox(height: 6),
              Text(label,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.grey)),
            ],
          ),
        );
      },
    );
  }
}
