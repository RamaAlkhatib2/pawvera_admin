import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MainApp());
  } catch (error, stackTrace) {
    runApp(FirebaseSetupErrorApp(error: error, stackTrace: stackTrace));
  }
}

class FirebaseSetupErrorApp extends StatelessWidget {
  final Object error;
  final StackTrace stackTrace;

  const FirebaseSetupErrorApp({
    Key? key,
    required this.error,
    required this.stackTrace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Firebase setup is incomplete',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text('Firebase could not be initialized: $error'),
                  const SizedBox(height: 8),
                  const Text(
                    'Add your Firebase platform config files and, for web, generate firebase_options.dart with FlutterFire CLI.',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'If you are using Android, make sure the package name matches your Firebase app registration.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);
  @override
  State<MainApp> createState() => _MainAppState();
}

class SimplePage extends StatelessWidget {
  final String title;
  const SimplePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: title,
      child: Center(child: Text('$title (placeholder)')),
    );
  }
}

class _MainAppState extends State<MainApp> {
  String currentPage = 'dashboard';

  void _navigate(String page) => setState(() => currentPage = page);

  Widget _buildContent() {
    switch (currentPage) {
      case 'users':
        return UsersPage(onNavigate: _navigate);
      case 'stores':
        return StoresPage(onNavigate: _navigate);
      case 'services':
        return ServiceShopsPage(onNavigate: _navigate);
      case 'clinics':
        return const SimplePage(title: 'Clinics');
      case 'types':
        return PetTypesPage(onNavigate: _navigate);
      case 'pets':
        return PetsPage(onNavigate: _navigate);
      case 'adoption':
        return PetAdoptionPage(onNavigate: _navigate);
      case 'qrtags':
        return QrTagsPage(onNavigate: _navigate);
      case 'reminders':
        return RemindersPage(onNavigate: _navigate);
      case 'preview':
        return const SimplePage(title: 'Mobile App Preview');
      case 'logs':
        return AuditLogsPage(onNavigate: _navigate);
      default:
        return DashboardPage(onNavigate: _navigate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawVera Admin',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5A9B7E)),
      ),
      home: Scaffold(
        body: Row(
          children: [
            AppSidebar(activePage: currentPage, onNavigate: _navigate),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }
}

class AppSidebar extends StatelessWidget {
  final String activePage;
  final void Function(String) onNavigate;

  const AppSidebar({
    Key? key,
    required this.activePage,
    required this.onNavigate,
  }) : super(key: key);

  Widget _navItem({
    required IconData icon,
    required String label,
    required String page,
  }) {
    final isActive = activePage == page;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: isActive
          ? BoxDecoration(
              color: const Color(0xFF5A9B7E),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: ListTile(
        leading: Icon(icon, color: isActive ? Colors.white : Colors.grey),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontSize: 13,
          ),
        ),
        onTap: () => onNavigate(page),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5A9B7E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.pets, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'PawVera Admin',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Platform Management',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _navItem(
                    icon: Icons.dashboard,
                    label: 'Dashboard',
                    page: 'dashboard',
                  ),
                  _navItem(icon: Icons.people, label: 'Users', page: 'users'),
                  _navItem(
                    icon: Icons.store,
                    label: 'Pet Supplies Stores',
                    page: 'stores',
                  ),
                  _navItem(
                    icon: Icons.health_and_safety,
                    label: 'Service Providers Shops',
                    page: 'services',
                  ),
                  _navItem(
                    icon: Icons.local_hospital,
                    label: 'Clinics',
                    page: 'clinics',
                  ),
                  _navItem(
                    icon: Icons.category,
                    label: 'Pet Types',
                    page: 'types',
                  ),
                  _navItem(icon: Icons.favorite, label: 'Pets', page: 'pets'),
                  _navItem(
                    icon: Icons.favorite_border,
                    label: 'Pet Adoption',
                    page: 'adoption',
                  ),
                  _navItem(
                    icon: Icons.qr_code,
                    label: 'QR Tags',
                    page: 'qrtags',
                  ),
                  _navItem(
                    icon: Icons.notifications,
                    label: 'Reminders',
                    page: 'reminders',
                  ),
                  _navItem(
                    icon: Icons.phone_iphone,
                    label: 'Mobile App Preview',
                    page: 'preview',
                  ),
                  _navItem(
                    icon: Icons.history,
                    label: 'Audit Logs',
                    page: 'logs',
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFD4E8E4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Need Help?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Check our documentation',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text(
                        'View Docs',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final Function(String)? onNavigate;

  const PageScaffold({
    Key? key,
    required this.title,
    required this.child,
    this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search users, pets, or records...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none),
                      onPressed: () {},
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text('Admin User', style: TextStyle(fontSize: 12)),
                        Text(
                          'admin@pawvera.com',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5A9B7E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Title + body
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(children: []),
                  ],
                ),
                const SizedBox(height: 24),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final Function(String) onNavigate;
  const DashboardPage({Key? key, required this.onNavigate}) : super(key: key);

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
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
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

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

          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.6,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _statCard(
                'Total Users',
                '1,247',
                Icons.people,
                const Color(0xFF2D9CDB),
              ),
              _statCard(
                'Registered Pets',
                '2,134',
                Icons.pets,
                const Color(0xFF2FCF77),
              ),
              _statCard(
                'QR Tags',
                '2,134',
                Icons.qr_code,
                const Color(0xFF7BD7D0),
              ),
              _statCard(
                'Vet Clinics',
                '3',
                Icons.local_hospital,
                const Color(0xFFF5A623),
              ),
              _statCard(
                'Online Stores',
                '2',
                Icons.store,
                const Color(0xFF6FC7FF),
              ),
              _statCard(
                'Service Shops',
                '3',
                Icons.build,
                const Color(0xFFF7B267),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Pending banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4DB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFE4A3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1D6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.info_outline,
                        color: Color(0xFFF7A600),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '2 Pending Adoption Approvals',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Review required',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B233F),
                  ),
                  child: const Text('Review'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Main content: chart + activity
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    // Chart card
                    Container(
                      height: 220,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'User & Pet Growth',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Expanded(
                            child: Center(child: Text('Chart placeholder')),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Quick actions
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quick Actions',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF1F1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '+ Add Veterinary Clinic',
                                      style: TextStyle(
                                        color: Color(0xFFDF5A5A),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF6EE),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '+ Add Pet Care Service Shop',
                                      style: TextStyle(
                                        color: Color(0xFFDF8A5A),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFFAF8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '+ Add Pet Supplies Store',
                                      style: TextStyle(
                                        color: Color(0xFF2F9C76),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Recent Activity',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 12),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(child: Icon(Icons.person)),
                            title: Text('New user registered'),
                            subtitle: Text('Sarah Johnson • 5 minutes ago'),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: Color(0xFFE8FAF2),
                              child: Icon(Icons.pets, color: Color(0xFF2F9C76)),
                            ),
                            title: Text('Pet profile created'),
                            subtitle: Text(
                              'Max (Golden Retriever) • 12 minutes ago',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UsersPage extends StatefulWidget {
  final Function(String) onNavigate;
  const UsersPage({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String search = '';
  String statusFilter = 'All Status';

  final users = [
    {
      'name': 'Sarah Johnson',
      'email': 'sarah.j@email.com',
      'phone': '+1 (555) 123-4567',
      'location': 'New York, NY',
      'pets': '2 pets',
      'joined': '1/15/2024',
      'status': 'active',
    },
    {
      'name': 'Mike Chen',
      'email': 'mike.chen@email.com',
      'phone': '+1 (555) 234-5678',
      'location': 'San Francisco, CA',
      'pets': '1 pet',
      'joined': '2/20/2024',
      'status': 'active',
    },
    {
      'name': 'Emma Davis',
      'email': 'emma.d@email.com',
      'phone': '+1 (555) 345-6789',
      'location': 'Austin, TX',
      'pets': '3 pets',
      'joined': '3/10/2024',
      'status': 'active',
    },
    {
      'name': 'James Wilson',
      'email': 'j.wilson@email.com',
      'phone': '+1 (555) 456-7890',
      'location': 'Seattle, WA',
      'pets': '1 pet',
      'joined': '12/5/2023',
      'status': 'inactive',
    },
    {
      'name': 'Lisa Anderson',
      'email': 'lisa.a@email.com',
      'phone': '+1 (555) 567-8901',
      'location': 'Boston, MA',
      'pets': '2 pets',
      'joined': '4/22/2024',
      'status': 'active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = users
        .where(
          (u) =>
              u['name']!.toLowerCase().contains(search.toLowerCase()) &&
              (statusFilter == 'All Status' ||
                  u['status'] == statusFilter.toLowerCase()),
        )
        .toList();

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
                // Search + filter row
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

                // Table headers
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
                        'Pets',
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
                    SizedBox(width: 40, child: Text('')),
                  ],
                ),

                const SizedBox(height: 8),

                // Rows
                Column(
                  children: [
                    for (var u in filtered)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0xFFF0F0F0)),
                          ),
                        ),
                        child: Row(
                          children: [
                            // User
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: const Color(0xFFB39DDB),
                                    child: Text(
                                      u['name']!
                                          .split(' ')
                                          .map((s) => s[0])
                                          .take(2)
                                          .join(),
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
                                          u['name']!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          u['email']!,
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

                            // Contact
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    u['email']!,
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    u['phone']!,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Location
                            Expanded(
                              flex: 2,
                              child: Text(
                                u['location']!,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ),

                            // Pets
                            Expanded(
                              flex: 1,
                              child: Text(
                                u['pets']!,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ),

                            // Joined
                            Expanded(
                              flex: 1,
                              child: Text(
                                u['joined']!,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ),

                            // Status
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
                                    color: u['status'] == 'active'
                                        ? const Color(0xFFEFFAF1)
                                        : const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    u['status']!,
                                    style: TextStyle(
                                      color: u['status'] == 'active'
                                          ? const Color(0xFF2F9C76)
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Actions
                            SizedBox(
                              width: 40,
                              child: IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {},
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

class StoresPage extends StatefulWidget {
  final Function(String) onNavigate;
  const StoresPage({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class ServiceShopsPage extends StatefulWidget {
  final Function(String) onNavigate;
  const ServiceShopsPage({Key? key, required this.onNavigate})
    : super(key: key);

  @override
  State<ServiceShopsPage> createState() => _ServiceShopsPageState();
}

class PetTypesPage extends StatefulWidget {
  final Function(String) onNavigate;
  const PetTypesPage({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<PetTypesPage> createState() => _PetTypesPageState();
}

class _PetTypesPageState extends State<PetTypesPage> {
  String q = '';
  String classification = 'All Classifications';
  String status = 'All Statuses';

  final types = [
    {
      'title': 'Dog',
      'subtitle': 'Domesticated canine companion',
      'store': 'Pet Store A',
      'breeds': [
        'Labrador Retriever',
        'Golden Retriever',
        'German Shepherd',
        'Bulldog',
        'Poodle',
      ],
      'status': 'active',
    },
    {
      'title': 'Cat',
      'subtitle': 'Domesticated feline companion',
      'store': 'Pet Store B',
      'breeds': [
        'Persian',
        'Maine Coon',
        'Siamese',
        'British Shorthair',
        'Ragdoll',
      ],
      'status': 'active',
    },
  ];

  void _openAddTypeDialog() {
    final nameCtl = TextEditingController();
    final iconCtl = TextEditingController();
    String classificationVal = 'Mammal';
    final descCtl = TextEditingController();
    final breedsCtl = TextEditingController();
    final storeCtl = TextEditingController();
    String statusVal = 'Active';

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Add Pet Type'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtl,
                decoration: InputDecoration(
                  hintText: 'Pet Type Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: iconCtl,
                decoration: InputDecoration(
                  hintText: 'Icon (Emoji)\ne.g., 🐶',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: classificationVal,
                items: const [
                  DropdownMenuItem(value: 'Mammal', child: Text('Mammal')),
                  DropdownMenuItem(value: 'Bird', child: Text('Bird')),
                  DropdownMenuItem(value: 'Reptile', child: Text('Reptile')),
                  DropdownMenuItem(value: 'Fish', child: Text('Fish')),
                ],
                onChanged: (v) => classificationVal = v ?? 'Mammal',
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: breedsCtl,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText:
                      'Default Breeds (comma-separated)\ne.g., Labrador, Golden Retriever, Poodle',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: storeCtl,
                decoration: InputDecoration(
                  hintText: 'Store',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: statusVal,
                items: const [
                  DropdownMenuItem(value: 'Active', child: Text('Active')),
                  DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
                ],
                onChanged: (v) => statusVal = v ?? 'Active',
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final breeds = breedsCtl.text
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();
              final map = {
                'title': nameCtl.text.isEmpty ? 'New Type' : nameCtl.text,
                'icon': iconCtl.text,
                'subtitle': descCtl.text,
                'store': storeCtl.text,
                'breeds': breeds,
                'classification': classificationVal,
                'status': statusVal.toLowerCase(),
              };
              setState(() => types.insert(0, map));
              Navigator.of(ctx).pop();
            },
            child: const Text('Add Pet Type'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = types
        .where(
          (t) => (t['title'] as String).toLowerCase().contains(q.toLowerCase()),
        )
        .toList();

    return PageScaffold(
      title: 'Pet Types Management',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage pet species and their default breeds',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => q = v),
                  decoration: InputDecoration(
                    hintText: 'Search pet types...',
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
                  value: classification,
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(
                      value: 'All Classifications',
                      child: Text('All Classifications'),
                    ),
                  ],
                  onChanged: (v) => setState(
                    () => classification = v ?? 'All Classifications',
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
                  value: status,
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(
                      value: 'All Statuses',
                      child: Text('All Statuses'),
                    ),
                    DropdownMenuItem(value: 'Active', child: Text('Active')),
                  ],
                  onChanged: (v) =>
                      setState(() => status = v ?? 'All Statuses'),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _openAddTypeDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B233F),
                ),
                child: const Text('+ Add Pet Type'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Column(
            children: [
              for (var t in filtered)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        (t['title'] as String),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3F4F6),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          (t['title'] as String),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFFAF1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          (t['status'] as String),
                                          style: const TextStyle(
                                            color: Color(0xFF2F9C76),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    (t['subtitle'] as String),
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Store: ${(t['store'] as String)}',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  final initial = t;
                                  // show dialog prefilled
                                  final nm = TextEditingController(
                                    text: initial['title'] as String? ?? '',
                                  );
                                  final ic = TextEditingController(
                                    text: initial['icon'] as String? ?? '',
                                  );
                                  String classVal =
                                      initial['classification'] as String? ??
                                      'Mammal';
                                  final ds = TextEditingController(
                                    text: initial['subtitle'] as String? ?? '',
                                  );
                                  final br = TextEditingController(
                                    text:
                                        (initial['breeds'] as List?)?.join(
                                          ', ',
                                        ) ??
                                        '',
                                  );
                                  final st = TextEditingController(
                                    text: initial['store'] as String? ?? '',
                                  );
                                  String stat =
                                      (initial['status'] as String?)
                                          ?.toLowerCase() ??
                                      'active';

                                  showDialog<void>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      title: const Text('Edit Pet Type'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: nm,
                                              decoration: InputDecoration(
                                                hintText: 'Pet Type Name',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            TextField(
                                              controller: ic,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Icon (Emoji)\ne.g., 🐶',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            DropdownButtonFormField<String>(
                                              value: classVal,
                                              items: const [
                                                DropdownMenuItem(
                                                  value: 'Mammal',
                                                  child: Text('Mammal'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'Bird',
                                                  child: Text('Bird'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'Reptile',
                                                  child: Text('Reptile'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'Fish',
                                                  child: Text('Fish'),
                                                ),
                                              ],
                                              onChanged: (v) =>
                                                  classVal = v ?? 'Mammal',
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            TextField(
                                              controller: ds,
                                              maxLines: 3,
                                              decoration: InputDecoration(
                                                hintText: 'Description',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            TextField(
                                              controller: br,
                                              maxLines: 2,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Default Breeds (comma-separated)\ne.g., Labrador, Golden Retriever, Poodle',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            TextField(
                                              controller: st,
                                              decoration: InputDecoration(
                                                hintText: 'Store',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            DropdownButtonFormField<String>(
                                              value:
                                                  stat[0].toUpperCase() +
                                                  stat.substring(1),
                                              items: const [
                                                DropdownMenuItem(
                                                  value: 'Active',
                                                  child: Text('Active'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'Inactive',
                                                  child: Text('Inactive'),
                                                ),
                                              ],
                                              onChanged: (v) => stat =
                                                  (v ?? 'Active').toLowerCase(),
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (nm.text.trim().isEmpty) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Please enter a pet type name',
                                                  ),
                                                ),
                                              );
                                              return;
                                            }
                                            final breeds = br.text
                                                .split(',')
                                                .map((s) => s.trim())
                                                .where((s) => s.isNotEmpty)
                                                .toList();
                                            final map = {
                                              'title': nm.text.trim(),
                                              'icon': ic.text.trim(),
                                              'classification': classVal,
                                              'subtitle': ds.text.trim(),
                                              'breeds': breeds,
                                              'store': st.text.trim(),
                                              'status': stat,
                                            };
                                            setState(() {
                                              final idx = types.indexOf(t);
                                              if (idx >= 0) types[idx] = map;
                                            });
                                            Navigator.of(ctx).pop();
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Pet type updated',
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text('Save'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  final ok = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Delete Pet Type'),
                                      content: const Text(
                                        'Are you sure you want to delete this pet type?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(true),
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (ok == true) {
                                    setState(() => types.remove(t));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Pet type deleted'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      const Text('Default Breeds:'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (var b in (t['breeds'] as List<String>))
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F6F6),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(b),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceShopsPageState extends State<ServiceShopsPage> {
  String q = '';

  final shops = [
    {
      'name': 'Pawfect Spa',
      'category': 'Grooming',
      'owner': 'Emma Wilson',
      'email': 'emma@pawfectspa.com',
      'location': 'Downtown Plaza',
      'bookings': '78',
      'status': 'active',
    },
    {
      'name': 'Happy Tails Training',
      'category': 'Training',
      'owner': 'Mike Brown',
      'email': 'mike@happytails.com',
      'location': 'Park Avenue',
      'bookings': '45',
      'status': 'active',
    },
  ];

  void _openAddServiceDialog() {
    final nameCtl = TextEditingController();
    String category = 'Grooming';
    final ownerCtl = TextEditingController();
    final emailCtl = TextEditingController();
    final locationCtl = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Add New Shop'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtl,
                decoration: InputDecoration(
                  hintText: 'Shop Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: category,
                items: const [
                  DropdownMenuItem(value: 'Grooming', child: Text('Grooming')),
                  DropdownMenuItem(value: 'Training', child: Text('Training')),
                  DropdownMenuItem(value: 'Boarding', child: Text('Boarding')),
                ],
                onChanged: (v) => category = v ?? 'Grooming',
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ownerCtl,
                decoration: InputDecoration(
                  hintText: 'Owner Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCtl,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationCtl,
                decoration: InputDecoration(
                  hintText: 'Location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final map = {
                'name': nameCtl.text.isEmpty ? 'New Shop' : nameCtl.text,
                'category': category,
                'owner': ownerCtl.text,
                'email': emailCtl.text,
                'location': locationCtl.text,
                'bookings': '0',
                'status': 'active',
              };
              setState(() => shops.insert(0, map));
              Navigator.of(ctx).pop();
            },
            child: const Text('Add Shop'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = shops
        .where((s) => s['name']!.toLowerCase().contains(q.toLowerCase()))
        .toList();

    return PageScaffold(
      title: 'Service Providers Shops',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage pet care service providers shops and their offerings.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Top row: search + add
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => q = v),
                  decoration: InputDecoration(
                    hintText: 'Search shops, owners, categories...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _openAddServiceDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B233F),
                ),
                child: const Text('+ Add Shop'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Column(
            children: [
              for (var s in filtered)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F6F4),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.build),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        s['name']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3F4F6),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          s['category']!,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFFAF1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          s['status']!,
                                          style: const TextStyle(
                                            color: Color(0xFF2F9C76),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Owner: ${s['owner']}',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {},
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.email,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                s['email']!,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                          const SizedBox(width: 24),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                s['location']!,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Bookings: ${s['bookings']}',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          Row(
                            children: [
                              OutlinedButton(
                                onPressed: () {},
                                child: const Text('Deactivate'),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StoresPageState extends State<StoresPage> {
  String q = '';
  String status = 'All Statuses';

  final stores = [
    {
      'name': 'Pet Supplies Plus',
      'owner': 'John Anderson',
      'email': 'john@petsupplies.com',
      'location': 'Online Store',
      'commission': '15%',
      'products': '245',
      'orders': '156',
      'status': 'active',
    },
    {
      'name': 'Furry Friends Store',
      'owner': 'Sarah Lee',
      'email': 'sarah@furryfriends.com',
      'location': 'East Mall, Suite 100',
      'commission': '12%',
      'products': '180',
      'orders': '89',
      'status': 'active',
    },
  ];

  void _openAddStoreDialog() {
    final nameCtl = TextEditingController();
    String category = 'Select category';
    final ownerCtl = TextEditingController();
    final emailCtl = TextEditingController();
    final locationCtl = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Add New Shop'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtl,
                decoration: InputDecoration(
                  hintText: 'Shop Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: category,
                items: const [
                  DropdownMenuItem(
                    value: 'Select category',
                    child: Text('Select category'),
                  ),
                  DropdownMenuItem(value: 'Retail', child: Text('Retail')),
                  DropdownMenuItem(value: 'Online', child: Text('Online')),
                ],
                onChanged: (v) => category = v ?? 'Select category',
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ownerCtl,
                decoration: InputDecoration(
                  hintText: 'Owner Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCtl,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationCtl,
                decoration: InputDecoration(
                  hintText: 'Location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final map = {
                'name': nameCtl.text.isEmpty ? 'New Store' : nameCtl.text,
                'owner': ownerCtl.text,
                'email': emailCtl.text,
                'location': locationCtl.text,
                'commission': '0%',
                'products': '0',
                'orders': '0',
                'status': 'active',
              };
              setState(() => stores.insert(0, map));
              Navigator.of(ctx).pop();
            },
            child: const Text('Add Shop'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = stores
        .where((s) => s['name']!.toLowerCase().contains(q.toLowerCase()))
        .toList();

    return PageScaffold(
      title: 'Pet Supplies Stores',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage pet supplies stores and their product inventory.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => q = v),
                    decoration: InputDecoration(
                      hintText: 'Search stores...',
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
                    value: status,
                    underline: const SizedBox.shrink(),
                    items: const [
                      DropdownMenuItem(
                        value: 'All Statuses',
                        child: Text('All Statuses'),
                      ),
                      DropdownMenuItem(value: 'Active', child: Text('Active')),
                      DropdownMenuItem(
                        value: 'Inactive',
                        child: Text('Inactive'),
                      ),
                    ],
                    onChanged: (v) =>
                        setState(() => status = v ?? 'All Statuses'),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _openAddStoreDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B233F),
                  ),
                  child: const Text('+ Add Store'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Store cards
          Column(
            children: [
              for (var s in filtered)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F6F4),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.store),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        s['name']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFFAF1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          s['status']!,
                                          style: const TextStyle(
                                            color: Color(0xFF2F9C76),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Owner: ${s['owner']}',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {},
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Details row
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.email,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                s['email']!,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                s['location']!,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                '%',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                ' Commission: ${s['commission']}',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Text(
                            'Products: ${s['products']}',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Orders: ${s['orders']}',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

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
    final withQr = pets
        .where((p) => (p['qr'] as bool) == true)
        .length
        .toString();
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
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

          // Groups
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
                        // left
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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

class PetAdoptionPage extends StatefulWidget {
  final Function(String) onNavigate;
  const PetAdoptionPage({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<PetAdoptionPage> createState() => _PetAdoptionPageState();
}

class _PetAdoptionPageState extends State<PetAdoptionPage> {
  String q = '';
  String statusFilter = 'All Statuses';

  final apps = [
    {
      'name': 'Max',
      'type': 'Dog',
      'breed': 'Labrador',
      'age': '2 years',
      'owner': 'Alice Brown',
      'desc': 'Friendly and energetic dog looking for a loving home',
      'status': 'pending',
    },
    {
      'name': 'Charlie',
      'type': 'Dog',
      'breed': 'Golden Retriever',
      'age': '1 years',
      'owner': 'Carol Davis',
      'desc': 'Playful puppy needs an active family',
      'status': 'pending',
    },
    {
      'name': 'Whiskers',
      'type': 'Cat',
      'breed': 'Persian',
      'age': '3 years',
      'owner': 'Samantha Grey',
      'desc': 'Calm indoor cat, great with kids',
      'status': 'approved',
    },
  ];

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
                Row(
                  children: [
                    Text(
                      a['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
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
                    const SizedBox(width: 8),
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
                        child: Text(
                          'Pending',
                          style: const TextStyle(
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
                        child: Text(
                          'Approved',
                          style: const TextStyle(
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
            children: [
              if (pending)
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _approve(a as Map<String, String>),
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
                      onPressed: () => _reject(a as Map<String, String>),
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
    final filtered = apps
        .where(
          (a) =>
              a['name']!.toLowerCase().contains(qLower) ||
              a['breed']!.toLowerCase().contains(qLower) ||
              a['owner']!.toLowerCase().contains(qLower),
        )
        .toList();
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

          // Search + filter row
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

          // Pending section
          Text(
            'Pending Approval (${pending.length})',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          for (var a in pending)
            _buildCard(a as Map<String, String>, pending: true),

          const SizedBox(height: 12),
          Text(
            'Approved Listings (${approved.length})',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          for (var a in approved)
            _buildCard(a as Map<String, String>, pending: false),
        ],
      ),
    );
  }
}

class QrTagsPage extends StatefulWidget {
  final Function(String) onNavigate;
  const QrTagsPage({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<QrTagsPage> createState() => _QrTagsPageState();
}

class RemindersPage extends StatefulWidget {
  final Function(String) onNavigate;
  const RemindersPage({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  String q = '';

  final types = [
    {
      'title': 'Vaccination',
      'category': 'Health',
      'desc': 'Annual or periodic vaccination reminders',
    },
    {
      'title': 'Grooming',
      'category': 'Grooming',
      'desc': 'Regular grooming appointments',
    },
    {
      'title': 'Vet Checkup',
      'category': 'Health',
      'desc': 'Routine veterinary checkups',
    },
    {
      'title': 'Medication',
      'category': 'Health',
      'desc': 'Medication administration reminders',
    },
  ];

  void _openAddDialog() {
    final titleCtl = TextEditingController();
    final descCtl = TextEditingController();
    String cat = 'Health';

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Add Reminder Type'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtl,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: cat,
                items: const [
                  DropdownMenuItem(value: 'Health', child: Text('Health')),
                  DropdownMenuItem(value: 'Grooming', child: Text('Grooming')),
                ],
                onChanged: (v) => cat = v ?? 'Health',
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleCtl.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a title')),
                );
                return;
              }
              setState(
                () => types.insert(0, {
                  'title': titleCtl.text.trim(),
                  'category': cat,
                  'desc': descCtl.text.trim(),
                }),
              );
              Navigator.of(ctx).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = types
        .where((t) => t['title']!.toLowerCase().contains(q.toLowerCase()))
        .toList();
    final total = types.length;
    final health = types
        .where((t) => (t['category'] as String).toLowerCase() == 'health')
        .length;
    final grooming = types
        .where((t) => (t['category'] as String).toLowerCase() == 'grooming')
        .length;

    return PageScaffold(
      title: 'Reminders',
      onNavigate: widget.onNavigate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage reminder types for pet care',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Reminder Types',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: _openAddDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B233F),
                      ),
                      child: const Text('+ Add Type'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Search
                TextField(
                  onChanged: (v) => setState(() => q = v),
                  decoration: InputDecoration(
                    hintText: 'Search reminder types...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),

                Column(
                  children: [
                    for (var t in filtered)
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F6F4),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.notifications),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          t['title']!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF3F4F6),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            t['category']!,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      t['desc']!,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() => types.remove(t));
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Stats cards
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Reminder Types',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$total',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Health Reminders',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$health',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Grooming Reminders',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$grooming',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFFAF4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD9F0E7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'About Reminders',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Reminder types help pet owners stay on top of their pet\'s care schedule. Each reminder type can be customized with specific intervals and notifications to ensure pets receive timely care.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
            // Ensure large stat number scales down instead of overflowing
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
            // reduce aspect ratio so cards have more vertical room on short screens
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

                // Table header
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

                // Rows
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
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 16,
                  ),
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
              child: Text(
                log['category']!,
                style: const TextStyle(fontSize: 12),
              ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
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
