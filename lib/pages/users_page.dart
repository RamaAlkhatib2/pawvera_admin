import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/page_scaffold.dart';

class UsersPage extends StatefulWidget {
  final Function(String) onNavigate;
  const UsersPage({super.key, required this.onNavigate});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String search = '';
  String statusFilter = 'All Status';

  String _formatDate(dynamic value) {
    if (value == null) return '—';
    if (value is Timestamp) {
      final d = value.toDate();
      return '${d.month}/${d.day}/${d.year}';
    }
    return value.toString();
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'User Management',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage and monitor pet owner accounts',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => search = v),
                        decoration: InputDecoration(
                          hintText: 'Search users by name or email...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
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
                            value: 'All Status',
                            child: Text('All Status'),
                          ),
                          DropdownMenuItem(
                            value: 'active',
                            child: Text('Active'),
                          ),
                          DropdownMenuItem(
                            value: 'inactive',
                            child: Text('Inactive'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => statusFilter = v ?? 'All Status'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'User',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Contact',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Location',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Joined',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Status',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),

                const SizedBox(height: 8),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(48),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (snapshot.hasError) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFECEC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Error loading users: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    final allDocs = snapshot.data?.docs ?? [];

                    final filtered = allDocs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final role = data['role'] as String? ?? '';
                      if (role == 'provider') return false;

                      final name = (data['name'] as String? ??
                              data['displayName'] as String? ??
                              '')
                          .toLowerCase();
                      final email =
                          (data['email'] as String? ?? '').toLowerCase();
                      final q = search.toLowerCase();
                      final matchesSearch =
                          name.contains(q) || email.contains(q);

                      final isActive = data['isActive'] as bool? ?? true;
                      final matchesStatus = statusFilter == 'All Status' ||
                          (statusFilter == 'active' && isActive) ||
                          (statusFilter == 'inactive' && !isActive);

                      return matchesSearch && matchesStatus;
                    }).toList();

                    if (filtered.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 48,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                allDocs.isEmpty
                                    ? 'No users found in the database.'
                                    : 'No users match your search.',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: filtered.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final name = data['name'] as String? ??
                            data['displayName'] as String? ??
                            data['fullName'] as String? ??
                            'Unknown';
                        final email = data['email'] as String? ?? '—';
                        final phone = data['phone'] as String? ??
                            data['phoneNumber'] as String? ??
                            '—';
                        final location = data['location'] as String? ??
                            data['address'] as String? ??
                            data['city'] as String? ??
                            '—';
                        final joined = _formatDate(data['createdAt']);
                        final isActive = data['isActive'] as bool? ?? true;

                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xFFF0F0F0)),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          const Color(0xFFB39DDB),
                                      child: Text(
                                        _initials(name),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            email,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      email,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      phone,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                flex: 2,
                                child: Text(
                                  location,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      TextStyle(color: Colors.grey.shade700),
                                ),
                              ),

                              Expanded(
                                flex: 1,
                                child: Text(
                                  joined,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      TextStyle(color: Colors.grey.shade700),
                                ),
                              ),

                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? const Color(0xFFEFFAF1)
                                          : const Color(0xFFF3F4F6),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      isActive ? 'active' : 'inactive',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: isActive
                                            ? const Color(0xFF2F9C76)
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: 40,
                                child: IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {},
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
    );
  }
}
