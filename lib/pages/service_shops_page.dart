import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../widgets/page_scaffold.dart';

class ServiceShopsPage extends StatefulWidget {
  final Function(String) onNavigate;
  const ServiceShopsPage({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<ServiceShopsPage> createState() => _ServiceShopsPageState();
}

class _ServiceShopsPageState extends State<ServiceShopsPage> {
  String q = '';

  static const List<String> _providerTypes = [
    'Pet Supplies Store',
    'Services Provider Shop',
    'Vet Clinic Admin',
    'Doctor Staff',
  ];

  String _generateEmail(String businessName) {
    final cleaned = businessName
        .toLowerCase()
        .replaceAll(RegExp(r"[^a-z0-9\s]"), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '.');
    final suffix = Random().nextInt(9000) + 1000;
    return '$cleaned.$suffix@pawvera.com';
  }

  String _generatePassword() {
    const upper = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    const lower = 'abcdefghjkmnpqrstuvwxyz';
    const digits = '23456789';
    final rand = Random();
    final chars = [
      upper[rand.nextInt(upper.length)],
      upper[rand.nextInt(upper.length)],
      lower[rand.nextInt(lower.length)],
      lower[rand.nextInt(lower.length)],
      digits[rand.nextInt(digits.length)],
      digits[rand.nextInt(digits.length)],
      digits[rand.nextInt(digits.length)],
      digits[rand.nextInt(digits.length)],
    ]..shuffle(rand);
    return 'PawVera@${chars.join()}';
  }

  Future<void> _openAddProviderDialog() async {
    String? selectedType;
    final businessNameCtl = TextEditingController();
    String? generatedEmail;
    String? generatedPassword;
    bool isCreating = false;
    bool showPassword = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Add Provider Account'),
          content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Provider Type',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    hint: const Text('Select provider type'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    items: _providerTypes
                        .map(
                          (t) => DropdownMenuItem(
                            value: t,
                            child: Row(
                              children: [
                                Icon(
                                  _iconForType(t),
                                  size: 18,
                                  color: const Color(0xFF5A9B7E),
                                ),
                                const SizedBox(width: 10),
                                Text(t),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setDialog(() {
                      selectedType = v;
                      generatedEmail = null;
                      generatedPassword = null;
                    }),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Business Name',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: businessNameCtl,
                    decoration: InputDecoration(
                      hintText: 'e.g., Al-Nour Vet Clinic',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.auto_fix_high, size: 18),
                      label: const Text('Generate Credentials'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: selectedType == null ||
                              businessNameCtl.text.trim().isEmpty
                          ? null
                          : () => setDialog(() {
                                generatedEmail = _generateEmail(
                                  businessNameCtl.text.trim(),
                                );
                                generatedPassword = _generatePassword();
                              }),
                    ),
                  ),
                  if (generatedEmail != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFFAF4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFB6E2CF)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.key,
                                size: 16,
                                color: Color(0xFF2F9C76),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Generated Credentials',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2F9C76),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _credRow(
                            label: 'Email',
                            value: generatedEmail!,
                            onCopy: () {
                              Clipboard.setData(
                                ClipboardData(text: generatedEmail!),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Email copied'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          _credRow(
                            label: 'Password',
                            value: showPassword
                                ? generatedPassword!
                                : '●' * generatedPassword!.length,
                            trailing: IconButton(
                              icon: Icon(
                                showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 18,
                                color: Colors.grey,
                              ),
                              onPressed: () =>
                                  setDialog(() => showPassword = !showPassword),
                            ),
                            onCopy: () {
                              Clipboard.setData(
                                ClipboardData(text: generatedPassword!),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Password copied'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Send these credentials to the provider manually. The password is not stored.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isCreating ? null : () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B233F),
              ),
              onPressed: (generatedEmail == null || isCreating)
                  ? null
                  : () async {
                      setDialog(() => isCreating = true);
                      try {
                        // Use secondary Firebase app so admin session is unaffected
                        final secondaryApp = await Firebase.initializeApp(
                          name:
                              'providerCreation_${DateTime.now().millisecondsSinceEpoch}',
                          options: DefaultFirebaseOptions.currentPlatform,
                        );
                        final secondaryAuth = FirebaseAuth.instanceFor(
                          app: secondaryApp,
                        );
                        final cred =
                            await secondaryAuth.createUserWithEmailAndPassword(
                          email: generatedEmail!,
                          password: generatedPassword!,
                        );
                        final uid = cred.user!.uid;
                        await secondaryApp.delete();

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .set({
                          'uid': uid,
                          'email': generatedEmail,
                          'role': 'provider',
                          'providerType': selectedType,
                          'businessName': businessNameCtl.text.trim(),
                          'createdAt': FieldValue.serverTimestamp(),
                          'createdBy': 'admin',
                          'isActive': true,
                        });

                        if (ctx.mounted) Navigator.of(ctx).pop();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Provider "${businessNameCtl.text.trim()}" created successfully',
                              ),
                              backgroundColor: const Color(0xFF2F9C76),
                            ),
                          );
                        }
                      } catch (e) {
                        setDialog(() => isCreating = false);
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
              child: isCreating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _credRow({
    required String label,
    required String value,
    required VoidCallback onCopy,
    Widget? trailing,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
          ),
        ),
        if (trailing != null) trailing,
        IconButton(
          icon: const Icon(Icons.copy, size: 16, color: Colors.grey),
          onPressed: onCopy,
          tooltip: 'Copy',
        ),
      ],
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'Pet Supplies Store':
        return Icons.store;
      case 'Services Provider Shop':
        return Icons.build;
      case 'Vet Clinic Admin':
        return Icons.local_hospital;
      case 'Doctor Staff':
        return Icons.medical_services;
      default:
        return Icons.business;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'Pet Supplies Store':
        return const Color(0xFF2D9CDB);
      case 'Services Provider Shop':
        return const Color(0xFF5A9B7E);
      case 'Vet Clinic Admin':
        return const Color(0xFFF5A623);
      case 'Doctor Staff':
        return const Color(0xFF9B7BD7);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Add Provider',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage provider accounts across all shop types',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => q = v),
                  decoration: InputDecoration(
                    hintText: 'Search by business name or type...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _openAddProviderDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B233F),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Provider'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('role', isEqualTo: 'provider')
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
                    'Error loading providers: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              final docs = snapshot.data?.docs ?? [];
              final filtered = docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final name =
                    (data['businessName'] as String? ?? '').toLowerCase();
                final type =
                    (data['providerType'] as String? ?? '').toLowerCase();
                final search = q.toLowerCase();
                return name.contains(search) || type.contains(search);
              }).toList();

              if (filtered.isEmpty) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.storefront_outlined,
                          size: 48,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          docs.isEmpty
                              ? 'No providers yet. Click "Add Provider" to create one.'
                              : 'No providers match your search.',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: filtered
                    .map(
                      (doc) => _buildProviderCard(
                        doc.data() as Map<String, dynamic>,
                        doc.id,
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProviderCard(Map<String, dynamic> data, String docId) {
    final name = data['businessName'] as String? ?? 'Unnamed';
    final type = data['providerType'] as String? ?? '';
    final email = data['email'] as String? ?? '';
    final isActive = data['isActive'] as bool? ?? false;
    final createdAt = data['createdAt'] as Timestamp?;
    final color = _typeColor(type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_iconForType(type), color: color, size: 22),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                          fontSize: 11,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFFEFFAF1)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 11,
                          color: isActive
                              ? const Color(0xFF2F9C76)
                              : Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.email_outlined, size: 13, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (createdAt != null) ...[
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(createdAt.toDate()),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          Row(
            children: [
              OutlinedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(docId)
                      .update({'isActive': !isActive});
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: isActive ? Colors.orange : const Color(0xFF2F9C76),
                  side: BorderSide(
                    color: isActive ? Colors.orange : const Color(0xFF2F9C76),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(isActive ? 'Deactivate' : 'Activate'),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: const Text('Delete Provider'),
                      content: Text(
                        'Are you sure you want to delete "$name"? This cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (ok == true) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(docId)
                        .delete();
                  }
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                tooltip: 'Delete provider',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
