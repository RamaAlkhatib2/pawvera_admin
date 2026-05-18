import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/page_scaffold.dart';

class NotificationsPage extends StatefulWidget {
  final Function(String) onNavigate;
  const NotificationsPage({super.key, required this.onNavigate});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String _search = '';
  String _typeFilter = 'All';
  String _readFilter = 'All';

  static const _typeOptions = ['All', 'reminder', 'order', 'booking', 'system'];
  static const _readOptions = ['All', 'Read', 'Unread'];

  static const _typeIcons = <String, IconData>{
    'reminder': Icons.alarm,
    'order': Icons.shopping_bag_outlined,
    'booking': Icons.event_note,
    'system': Icons.info_outline,
  };

  static const _typeColors = <String, Color>{
    'reminder': Color(0xFFFFF3CD),
    'order': Color(0xFFCCE5FF),
    'booking': Color(0xFFD4EDDA),
    'system': Color(0xFFF3F4F6),
  };

  String _fmt(dynamic value) {
    if (value == null) return '—';
    if (value is Timestamp) {
      final d = value.toDate();
      final h = d.hour.toString().padLeft(2, '0');
      final m = d.minute.toString().padLeft(2, '0');
      return '${d.day}/${d.month}/${d.year}  $h:$m';
    }
    return value.toString();
  }

  Future<void> _confirmDelete(String docId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Notification'),
        content: const Text('Delete this notification permanently?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await FirebaseFirestore.instance.collection('notifications').doc(docId).delete();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification deleted'), backgroundColor: Color(0xFF2F9C76)),
      );
    }
  }

  Future<void> _markRead(String docId, bool current) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(docId)
        .update({'isRead': !current});
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Notifications',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('View all user notifications sent by the platform.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 280,
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    decoration: InputDecoration(
                      hintText: 'Search by title or description...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                _dropdownWidget(_typeFilter, _typeOptions, 'Type', (v) => setState(() => _typeFilter = v ?? 'All')),
                _dropdownWidget(_readFilter, _readOptions, 'Status', (v) => setState(() => _readFilter = v ?? 'All')),
              ],
            ),
          ),

          const SizedBox(height: 16),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('notifications')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Padding(padding: EdgeInsets.all(48), child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) {
                return _errorBox('Error loading notifications: ${snapshot.error}');
              }

              final docs = snapshot.data?.docs ?? [];
              final q = _search.toLowerCase();
              final filtered = docs.where((doc) {
                final d = doc.data() as Map<String, dynamic>;
                final title = (d['title'] as String? ?? '').toLowerCase();
                final desc = (d['description'] as String? ?? '').toLowerCase();
                final isRead = d['isRead'] as bool? ?? false;
                final matchSearch = q.isEmpty || title.contains(q) || desc.contains(q);
                final matchType = _typeFilter == 'All' || d['type'] == _typeFilter;
                final matchRead = _readFilter == 'All' ||
                    (_readFilter == 'Read' && isRead) ||
                    (_readFilter == 'Unread' && !isRead);
                return matchSearch && matchType && matchRead;
              }).toList();

              if (filtered.isEmpty) {
                return _emptyState(docs.isEmpty ? 'No notifications found.' : 'No notifications match your filter.');
              }

              final unreadCount = filtered.where((d) => !(((d.data() as Map<String, dynamic>)['isRead']) as bool? ?? false)).length;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (unreadCount > 0) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3CD),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.notifications_active, size: 16, color: Color(0xFF856404)),
                          const SizedBox(width: 8),
                          Text(
                            '$unreadCount unread notification${unreadCount == 1 ? '' : 's'}',
                            style: const TextStyle(color: Color(0xFF856404), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: filtered.asMap().entries.map((entry) {
                        final i = entry.key;
                        final doc = entry.value;
                        final d = doc.data() as Map<String, dynamic>;
                        return _buildNotificationTile(d, doc.id, isLast: i == filtered.length - 1);
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _dropdownWidget(String value, List<String> options, String label, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
      child: DropdownButton<String>(
        value: value,
        underline: const SizedBox.shrink(),
        items: options.map((s) => DropdownMenuItem(value: s, child: Text(s == 'All' ? 'All $label' : s))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> d, String docId, {bool isLast = false}) {
    final title = d['title'] as String? ?? 'No Title';
    final description = d['description'] as String? ?? '';
    final type = (d['type'] as String? ?? 'system').toLowerCase();
    final isRead = d['isRead'] as bool? ?? false;
    final createdAt = _fmt(d['createdAt']);
    final userId = d['userId'] as String? ?? '';

    final icon = _typeIcons[type] ?? Icons.notifications_outlined;
    final bgColor = isRead ? Colors.white : const Color(0xFFF0F6F4);
    final iconBg = _typeColors[type] ?? const Color(0xFFF3F4F6);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 20, color: const Color(0xFF5A9B7E)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(color: Color(0xFF5A9B7E), shape: BoxShape.circle),
                      ),
                  ],
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(description, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                ],
                const SizedBox(height: 6),
                Wrap(
                  spacing: 12,
                  children: [
                    _chip(Icons.access_time, createdAt),
                    if (userId.isNotEmpty) _chip(Icons.person_outline, 'UID: ${userId.length > 12 ? userId.substring(0, 12) : userId}…'),
                    _chip(Icons.label_outline, type),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Actions',
            icon: const Icon(Icons.more_vert, size: 20),
            onSelected: (v) async {
              if (v == 'toggle') await _markRead(docId, isRead);
              if (v == 'delete') await _confirmDelete(docId);
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'toggle',
                child: Row(children: [
                  Icon(isRead ? Icons.mark_email_unread_outlined : Icons.mark_email_read_outlined, size: 18),
                  const SizedBox(width: 8),
                  Text(isRead ? 'Mark Unread' : 'Mark Read'),
                ]),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(children: [
                  Icon(Icons.delete_outline, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String text) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey),
          const SizedBox(width: 3),
          Text(text, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        ],
      );

  Widget _errorBox(String msg) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: const Color(0xFFFFECEC), borderRadius: BorderRadius.circular(8)),
        child: Text(msg, style: const TextStyle(color: Colors.red)),
      );

  Widget _emptyState(String msg) => Container(
        padding: const EdgeInsets.symmetric(vertical: 48),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.notifications_none, size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(msg, style: TextStyle(color: Colors.grey.shade500)),
            ],
          ),
        ),
      );
}
