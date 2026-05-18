import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/page_scaffold.dart';

class ConversationsPage extends StatefulWidget {
  final Function(String) onNavigate;
  const ConversationsPage({super.key, required this.onNavigate});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  String _search = '';

  String _fmt(dynamic value) {
    if (value == null) return '—';
    if (value is Timestamp) {
      final d = value.toDate();
      final h = d.hour.toString().padLeft(2, '0');
      final m = d.minute.toString().padLeft(2, '0');
      return '${d.day}/${d.month}/${d.year} $h:$m';
    }
    return value.toString();
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  void _showMessages(String conversationId, Map<String, dynamic> d) {
    final adopterName = d['adopterName'] as String? ?? 'Adopter';
    final ownerName = d['ownerName'] as String? ?? 'Owner';
    final petName = d['petName'] as String? ?? 'Pet';

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          width: 500,
          height: 560,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline, color: Color(0xFF5A9B7E)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Chat about $petName', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text('$adopterName → $ownerName', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                        ],
                      ),
                    ),
                    IconButton(onPressed: () => Navigator.of(ctx).pop(), icon: const Icon(Icons.close)),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('conversations')
                      .doc(conversationId)
                      .collection('messages')
                      .orderBy('createdAt', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final msgs = snapshot.data?.docs ?? [];
                    if (msgs.isEmpty) {
                      return Center(
                        child: Text('No messages in this conversation.', style: TextStyle(color: Colors.grey.shade500)),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: msgs.length,
                      itemBuilder: (_, i) {
                        final msg = msgs[i].data() as Map<String, dynamic>;
                        final text = msg['text'] as String? ?? msg['message'] as String? ?? '';
                        final senderId = msg['senderId'] as String? ?? '';
                        final adopterId = d['adopterId'] as String? ?? '';
                        final isAdopter = senderId == adopterId;
                        final time = _fmt(msg['createdAt']);
                        final senderName = isAdopter ? adopterName : ownerName;

                        return Align(
                          alignment: isAdopter ? Alignment.centerRight : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: isAdopter ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(senderName, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                              const SizedBox(height: 2),
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                constraints: const BoxConstraints(maxWidth: 320),
                                decoration: BoxDecoration(
                                  color: isAdopter ? const Color(0xFF5A9B7E) : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(text, style: TextStyle(color: isAdopter ? Colors.white : Colors.black87)),
                                    const SizedBox(height: 4),
                                    Text(time, style: TextStyle(fontSize: 10, color: isAdopter ? Colors.white70 : Colors.grey.shade500)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Conversations',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('View adoption conversations between pet owners and adopters.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: SizedBox(
              width: 300,
              child: TextField(
                onChanged: (v) => setState(() => _search = v),
                decoration: InputDecoration(
                  hintText: 'Search by name or pet...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('conversations')
                .orderBy('lastMessageTime', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Padding(padding: EdgeInsets.all(48), child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) {
                return _errorBox('Error loading conversations: ${snapshot.error}');
              }

              final docs = snapshot.data?.docs ?? [];
              final q = _search.toLowerCase();
              final filtered = docs.where((doc) {
                final d = doc.data() as Map<String, dynamic>;
                return q.isEmpty ||
                    (d['adopterName'] as String? ?? '').toLowerCase().contains(q) ||
                    (d['ownerName'] as String? ?? '').toLowerCase().contains(q) ||
                    (d['petName'] as String? ?? '').toLowerCase().contains(q);
              }).toList();

              if (filtered.isEmpty) {
                return _emptyState(docs.isEmpty ? 'No conversations found.' : 'No conversations match your search.');
              }

              return Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: filtered.asMap().entries.map((entry) {
                    final i = entry.key;
                    final doc = entry.value;
                    final d = doc.data() as Map<String, dynamic>;
                    return _buildConversationTile(d, doc.id, isLast: i == filtered.length - 1);
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(Map<String, dynamic> d, String docId, {bool isLast = false}) {
    final adopterName = d['adopterName'] as String? ?? 'Unknown Adopter';
    final ownerName = d['ownerName'] as String? ?? 'Unknown Owner';
    final petName = d['petName'] as String? ?? 'Unknown Pet';
    final lastMessage = d['lastMessage'] as String? ?? '';
    final lastTime = _fmt(d['lastMessageTime']);

    return InkWell(
      onTap: () => _showMessages(docId, d),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFB39DDB),
                  child: Text(
                    _initials(adopterName),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 11,
                    backgroundColor: const Color(0xFF5A9B7E),
                    child: Text(
                      _initials(ownerName),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '$adopterName  ↔  $ownerName',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(lastTime, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.pets, size: 13, color: Colors.grey.shade400),
                      const SizedBox(width: 4),
                      Text(petName, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    ],
                  ),
                  if (lastMessage.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

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
              Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(msg, style: TextStyle(color: Colors.grey.shade500)),
            ],
          ),
        ),
      );
}
