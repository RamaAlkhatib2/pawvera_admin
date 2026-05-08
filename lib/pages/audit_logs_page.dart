import 'package:flutter/material.dart';
import '../widgets/page_scaffold.dart';

class AuditLogsPage extends StatefulWidget {
  final Function(String) onNavigate;
  const AuditLogsPage({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<AuditLogsPage> createState() => _AuditLogsPageState();
}

class _AuditLogsPageState extends State<AuditLogsPage> {
  String q = '';
  String categoryFilter = 'All Categories';
  String statusFilter = 'All Status';

  final logs = <Map<String, String>>[
    {
      'time': '2025-01-07 14:32:15',
      'admin': 'Admin User',
      'action': 'User Login',
      'category': 'auth',
      'details': 'Successful admin login',
      'ip': '192.168.1.100',
      'status': 'success',
    },
    {
      'time': '2025-01-07 14:28:42',
      'admin': 'Sarah Mitchell',
      'action': 'Updated User Profile',
      'category': 'user',
      'details': 'Modified user profile for Sarah Johnson (ID: 12458)',
      'ip': '192.168.1.105',
      'status': 'success',
    },
    {
      'time': '2025-01-07 14:15:30',
      'admin': 'Admin User',
      'action': 'Deleted Pet Record',
      'category': 'data',
      'details': 'Removed pet record: Max (ID: 3421)',
      'ip': '192.168.1.100',
      'status': 'warning',
    },
    {
      'time': '2025-01-07 13:58:12',
      'admin': 'John Parker',
      'action': 'Changed Settings',
      'category': 'settings',
      'details': 'Updated email notification preferences',
      'ip': '192.168.1.112',
      'status': 'success',
    },
    {
      'time': '2025-01-07 13:45:20',
      'admin': 'Admin User',
      'action': 'Failed Login Attempt',
      'category': 'auth',
      'details': 'Invalid password entered',
      'ip': '192.168.1.100',
      'status': 'failed',
    },
    {
      'time': '2025-01-07 13:30:05',
      'admin': 'Sarah Mitchell',
      'action': 'Created Store Owner',
      'category': 'user',
      'details': 'Added new store owner: Pet Essentials Plus',
      'ip': '192.168.1.105',
      'status': 'success',
    },
    {
      'time': '2025-01-07 12:22:48',
      'admin': 'John Parker',
      'action': 'Database Backup',
      'category': 'data',
      'details': 'Initiated manual database backup',
      'ip': '192.168.1.112',
      'status': 'success',
    },
    {
      'time': '2025-01-07 11:55:33',
      'admin': 'Admin User',
      'action': 'Security Update',
      'category': 'security',
      'details': 'Enabled two-factor authentication',
      'ip': '192.168.1.100',
      'status': 'success',
    },
    {
      'time': '2025-01-07 11:20:17',
      'admin': 'Sarah Mitchell',
      'action': 'Approved Order',
      'category': 'data',
      'details': 'Approved order ORD-2025-003 for Emma Davis',
      'ip': '192.168.1.105',
      'status': 'success',
    },
    {
      'time': '2025-01-07 10:45:59',
      'admin': 'John Parker',
      'action': 'Updated Vet Clinic',
      'category': 'user',
      'details': 'Modified clinic details for Central Vet Hospital',
      'ip': '192.168.1.112',
      'status': 'success',
    },
  ];

  int get totalLogs => logs.length;
  int get successCount => logs.where((l) => l['status'] == 'success').length;
  int get failedCount => logs.where((l) => l['status'] == 'failed').length;
  int get warningCount => logs.where((l) => l['status'] == 'warning').length;

  Color _statusColor(String s) {
    switch (s) {
      case 'success':
        return const Color(0xFFEFFAF1);
      case 'failed':
        return const Color(0xFFFFECEC);
      case 'warning':
        return const Color(0xFFFFF7E6);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color _statusTextColor(String s) {
    switch (s) {
      case 'success':
        return const Color(0xFF2F9C76);
      case 'failed':
        return const Color(0xFFB31B1B);
      case 'warning':
        return const Color(0xFFB37B00);
      default:
        return Colors.grey.shade700;
    }
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
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
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _tableHeaderCell(String label, {int flex = 1, TextAlign? textAlign}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: textAlign,
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }

  Widget _logRow(Map<String, String> log) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              log['time']!,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.deepPurple.shade200,
                  child: const Icon(Icons.person, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
                Text(
                  log['admin']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              log['action']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(log['category']!, style: const TextStyle(fontSize: 12)),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              log['details']!,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              log['ip']!,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _statusColor(log['status']!),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  log['status']!.toUpperCase(),
                  style: TextStyle(
                    color: _statusTextColor(log['status']!),
                    fontSize: 12,
                  ),
                ),
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
    final filtered = logs.where((log) {
      final matchesQuery =
          log['admin']!.toLowerCase().contains(qLower) ||
          log['action']!.toLowerCase().contains(qLower) ||
          log['details']!.toLowerCase().contains(qLower);
      final matchesCategory =
          categoryFilter == 'All Categories' ||
          log['category'] == categoryFilter;
      final matchesStatus =
          statusFilter == 'All Status' || log['status'] == statusFilter;
      return matchesQuery && matchesCategory && matchesStatus;
    }).toList();

    return PageScaffold(
      title: 'Audit Logs',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Track all administrative actions and system events',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.4,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _statCard(
                'Total Logs',
                totalLogs.toString(),
                Icons.show_chart,
                const Color(0xFF6FB4FF),
              ),
              _statCard(
                'Successful Actions',
                successCount.toString(),
                Icons.check_circle,
                const Color(0xFF7EE9D1),
              ),
              _statCard(
                'Failed Actions',
                failedCount.toString(),
                Icons.error,
                const Color(0xFFFFC6C6),
              ),
              _statCard(
                'Warnings',
                warningCount.toString(),
                Icons.warning,
                const Color(0xFFFFE6B3),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 320,
                  child: TextField(
                    onChanged: (value) => setState(() => q = value),
                    decoration: InputDecoration(
                      hintText: 'Search by admin, action, or details...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                DropdownButton<String>(
                  value: categoryFilter,
                  items: const [
                    DropdownMenuItem(
                      value: 'All Categories',
                      child: Text('All Categories'),
                    ),
                    DropdownMenuItem(value: 'auth', child: Text('Auth')),
                    DropdownMenuItem(value: 'user', child: Text('User')),
                    DropdownMenuItem(value: 'data', child: Text('Data')),
                    DropdownMenuItem(
                      value: 'settings',
                      child: Text('Settings'),
                    ),
                    DropdownMenuItem(
                      value: 'security',
                      child: Text('Security'),
                    ),
                  ],
                  onChanged: (value) => setState(
                    () => categoryFilter = value ?? 'All Categories',
                  ),
                ),
                DropdownButton<String>(
                  value: statusFilter,
                  items: const [
                    DropdownMenuItem(
                      value: 'All Status',
                      child: Text('All Status'),
                    ),
                    DropdownMenuItem(value: 'success', child: Text('Success')),
                    DropdownMenuItem(value: 'failed', child: Text('Failed')),
                    DropdownMenuItem(value: 'warning', child: Text('Warning')),
                  ],
                  onChanged: (value) =>
                      setState(() => statusFilter = value ?? 'All Status'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B67C1),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.filter_list),
                      SizedBox(width: 8),
                      Text('Filter'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      _tableHeaderCell('Timestamp', flex: 2),
                      _tableHeaderCell('Admin', flex: 2),
                      _tableHeaderCell('Action', flex: 2),
                      _tableHeaderCell('Category', flex: 2),
                      _tableHeaderCell('Details', flex: 4),
                      _tableHeaderCell('IP Address', flex: 2),
                      _tableHeaderCell(
                        'Status',
                        flex: 1,
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text('No logs match the selected filters.'),
                    ),
                  )
                else
                  Column(children: filtered.map(_logRow).toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
