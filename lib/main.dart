import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String currentPage = 'dashboard';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawVera Admin',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5A9B7E),
        ),
      ),
      home: _buildPage(),
    );
  }

  Widget _buildPage() {
    switch (currentPage) {
      case 'users':
        return UsersPage(onNavigate: (page) {
          setState(() => currentPage = page);
        });
      case 'stores':
        return PetSuppliesStoresPage(onNavigate: (page) {
          setState(() => currentPage = page);
        });
      case 'services':
        return ServiceProvidersShopsPage(onNavigate: (page) {
          setState(() => currentPage = page);
        });
      case 'types':
        return PetTypesPage(onNavigate: (page) {
          setState(() => currentPage = page);
        });
      case 'pets':
        return PetsPage(onNavigate: (page) {
          setState(() => currentPage = page);
        });
      case 'adoption':
        return PetAdoptionPage(onNavigate: (page) {
          setState(() => currentPage = page);
        });
      default:
        return DashboardPage(onNavigate: (page) {
          setState(() => currentPage = page);
        });
    }
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, this.onNavigate});

  final Function(String)? onNavigate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          SizedBox(
            width: 250,
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
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
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  // Navigation Items
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildNavItem(
                          icon: Icons.dashboard,
                          label: 'Dashboard',
                          isActive: true,
                          onTap: () => onNavigate?.call('dashboard'),
                        ),
                        _buildNavItem(
                          icon: Icons.people,
                          label: 'Users',
                          isActive: false,
                          onTap: () => onNavigate?.call('users'),
                        ),
                        _buildNavItem(
                          icon: Icons.store,
                          label: 'Pet Supplies Stores',
                          isActive: false,
                          onTap: () => onNavigate?.call('stores'),
                        ),
                        _buildNavItem(
                          icon: Icons.health_and_safety,
                          label: 'Service Providers Shops',
                          isActive: false,
                          onTap: () => onNavigate?.call('services'),
                        ),
                        _buildNavItem(
                          icon: Icons.local_hospital,
                          label: 'Clinics',
                          isActive: false,
                          onTap: () => onNavigate?.call('clinics'),
                        ),
                        _buildNavItem(
                          icon: Icons.category,
                          label: 'Pet Types',
                          isActive: false,
                          onTap: () => onNavigate?.call('types'),
                        ),
                        _buildNavItem(
                          icon: Icons.favorite,
                          label: 'Pets',
                          isActive: false,
                          onTap: () => onNavigate?.call('pets'),
                        ),
                        _buildNavItem(
                          icon: Icons.favorite_border,
                          label: 'Pet Adoption',
                          isActive: false,
                          onTap: () => onNavigate?.call('adoption'),
                        ),
                        _buildNavItem(
                          icon: Icons.qr_code,
                          label: 'QR Tags',
                          isActive: false,
                          onTap: () => onNavigate?.call('qrtags'),
                        ),
                        _buildNavItem(
                          icon: Icons.notifications,
                          label: 'Reminders',
                          isActive: false,
                          onTap: () => onNavigate?.call('reminders'),
                        ),
                        _buildNavItem(
                          icon: Icons.phone_iphone,
                          label: 'Mobile App Preview',
                          isActive: false,
                          onTap: () => onNavigate?.call('preview'),
                        ),
                        _buildNavItem(
                          icon: Icons.history,
                          label: 'Audit Logs',
                          isActive: false,
                          onTap: () => onNavigate?.call('logs'),
                        ),
                      ],
                    ),
                  ),
                  // Help Section
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
          ),
          // Main Content
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: Column(
                children: [
                  // Header
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Search Bar
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search users, pets, or records...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Notification Icon
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
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Admin User
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Text(
                                  'Admin User',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'admin@pawvera.com',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
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
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        // Dashboard Title
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dashboard',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Welcome back! Here\'s what\'s happening with your platform.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Statistics Cards
                        GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.6,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildStatCard(
                              icon: Icons.people,
                              iconColor: Colors.green,
                              title: 'Total Users',
                              value: '1,247',
                            ),
                            _buildStatCard(
                              icon: Icons.pets,
                              iconColor: Colors.green,
                              title: 'Registered Pets',
                              value: '2,134',
                            ),
                            _buildStatCard(
                              icon: Icons.qr_code_2,
                              iconColor: Colors.blue,
                              title: 'QR Tags',
                              value: '2,134',
                            ),
                            _buildStatCard(
                              icon: Icons.local_hospital,
                              iconColor: Colors.red,
                              title: 'Vet Clinics',
                              value: '3',
                            ),
                            _buildStatCard(
                              icon: Icons.storefront,
                              iconColor: Colors.cyan,
                              title: 'Online Stores',
                              value: '2',
                            ),
                            _buildStatCard(
                              icon: Icons.miscellaneous_services,
                              iconColor: Colors.orange,
                              title: 'Service Shops',
                              value: '3',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Pending Approvals Alert
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF9E6),
                            border: Border.all(color: Colors.yellow.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.yellow.shade600,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.info,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      '2 Pending Adoption Approvals',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Review required',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'Review',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Charts and Activity Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // User & Pet Growth Chart
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'User & Pet Growth',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'Monthly registration trends',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      height: 200,
                                      child: _buildChart(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Recent Activity
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Recent Activity',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildActivityItem(
                                      icon: Icons.person_add,
                                      color: Colors.blue,
                                      title: 'New user registered',
                                      name: 'Sarah Johnson',
                                      time: '5 minutes ago',
                                    ),
                                    const Divider(),
                                    _buildActivityItem(
                                      icon: Icons.pets,
                                      color: Colors.green,
                                      title: 'Pet profile created',
                                      name: 'Max (Golden Retriever)',
                                      time: '12 minutes ago',
                                    ),
                                    const Divider(),
                                    _buildActivityItem(
                                      icon: Icons.calendar_today,
                                      color: Colors.purple,
                                      title: 'Appointment booked',
                                      name: 'Mike Chen',
                                      time: '28 minutes ago',
                                    ),
                                    const Divider(),
                                    _buildActivityItem(
                                      icon: Icons.favorite,
                                      color: Colors.red,
                                      title: 'Health record updated',
                                      name: 'Luna (Cat)',
                                      time: '1 hour ago',
                                    ),
                                    const Divider(),
                                    _buildActivityItem(
                                      icon: Icons.person_add,
                                      color: Colors.blue,
                                      title: 'New user registered',
                                      name: 'Emma Davis',
                                      time: '2 hours ago',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Quick Actions
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Quick Actions',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildQuickActionButton(
                                    icon: Icons.add,
                                    label: 'Add Veterinary Clinic',
                                    color: Colors.red,
                                  ),
                                  _buildQuickActionButton(
                                    icon: Icons.add,
                                    label: 'Add Pet Care Service Shop',
                                    color: Colors.orange,
                                  ),
                                  _buildQuickActionButton(
                                    icon: Icons.add,
                                    label: 'Add Pet Supplies Store',
                                    color: Colors.cyan,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: isActive
          ? BoxDecoration(
              color: const Color(0xFF5A9B7E),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.white : Colors.grey,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontSize: 13,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildChartBar('Jan', 1000, 800),
        _buildChartBar('Feb', 1500, 1200),
        _buildChartBar('Mar', 2200, 1800),
        _buildChartBar('Apr', 2800, 2300),
        _buildChartBar('May', 3500, 2900),
        _buildChartBar('Jun', 4200, 3600),
      ],
    );
  }

  Widget _buildChartBar(String month, double usersHeight, double petsHeight) {
    const maxHeight = 180.0;
    final usersPercent = usersHeight / 4500;
    final petsPercent = petsHeight / 4500;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(height: maxHeight * usersPercent),
        Container(
          width: 12,
          height: maxHeight * usersPercent,
          color: Colors.blue.shade300,
        ),
        Container(
          width: 12,
          height: maxHeight * petsPercent,
          color: Colors.green.shade500,
          margin: const EdgeInsets.only(top: 2),
        ),
        const SizedBox(height: 8),
        Text(
          month,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color color,
    required String title,
    required String name,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: color),
      label: Text(
        label,
        style: TextStyle(color: color),
      ),
    );
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key, this.onNavigate});

  final Function(String)? onNavigate;

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String searchQuery = '';
  String statusFilter = 'All Status';

  final List<Map<String, dynamic>> users = [
    {
      'name': 'Sarah Johnson',
      'email': 'sarah.j@email.com',
      'phone': '+1 (555) 123-4567',
      'location': 'New York, NY',
      'pets': 2,
      'joined': '1/15/2024',
      'status': 'active',
      'initials': 'SJ',
      'color': const Color(0xFF5B5FFF),
    },
    {
      'name': 'Mike Chen',
      'email': 'mike.chen@email.com',
      'phone': '+1 (555) 234-5678',
      'location': 'San Francisco, CA',
      'pets': 1,
      'joined': '2/20/2024',
      'status': 'active',
      'initials': 'MC',
      'color': const Color(0xFF6D28D9),
    },
    {
      'name': 'Emma Davis',
      'email': 'emma.d@email.com',
      'phone': '+1 (555) 345-6789',
      'location': 'Austin, TX',
      'pets': 3,
      'joined': '3/10/2024',
      'status': 'active',
      'initials': 'ED',
      'color': const Color(0xFF9333EA),
    },
    {
      'name': 'James Wilson',
      'email': 'j.wilson@email.com',
      'phone': '+1 (555) 456-7890',
      'location': 'Seattle, WA',
      'pets': 1,
      'joined': '12/5/2023',
      'status': 'inactive',
      'initials': 'JW',
      'color': const Color(0xFFF59E0B),
    },
    {
      'name': 'Lisa Anderson',
      'email': 'lisa.a@email.com',
      'phone': '+1 (555) 567-8901',
      'location': 'Boston, MA',
      'pets': 2,
      'joined': '4/22/2024',
      'status': 'active',
      'initials': 'LA',
      'color': const Color(0xFFF97316),
    },
  ];

  List<Map<String, dynamic>> get filteredUsers {
    return users
        .where((user) {
          final matchesSearch = user['name']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              user['email']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
          final matchesStatus = statusFilter == 'All Status' ||
              user['status'].toString().toLowerCase() ==
                  statusFilter.toLowerCase();
          return matchesSearch && matchesStatus;
        })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          SizedBox(
            width: 250,
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
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
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  // Navigation Items
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildNavItem(
                          icon: Icons.dashboard,
                          label: 'Dashboard',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('dashboard'),
                        ),
                        _buildNavItem(
                          icon: Icons.people,
                          label: 'Users',
                          isActive: true,
                          onTap: () => widget.onNavigate?.call('users'),
                        ),
                        _buildNavItem(
                          icon: Icons.store,
                          label: 'Pet Supplies Stores',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('stores'),
                        ),
                        _buildNavItem(
                          icon: Icons.health_and_safety,
                          label: 'Service Providers Shops',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('services'),
                        ),
                        _buildNavItem(
                          icon: Icons.local_hospital,
                          label: 'Clinics',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('clinics'),
                        ),
                        _buildNavItem(
                          icon: Icons.category,
                          label: 'Pet Types',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('types'),
                        ),
                        _buildNavItem(
                          icon: Icons.favorite,
                          label: 'Pets',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('pets'),
                        ),
                        _buildNavItem(
                          icon: Icons.favorite_border,
                          label: 'Pet Adoption',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('adoption'),
                        ),
                        _buildNavItem(
                          icon: Icons.qr_code,
                          label: 'QR Tags',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('qrtags'),
                        ),
                        _buildNavItem(
                          icon: Icons.notifications,
                          label: 'Reminders',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('reminders'),
                        ),
                        _buildNavItem(
                          icon: Icons.phone_iphone,
                          label: 'Mobile App Preview',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('preview'),
                        ),
                        _buildNavItem(
                          icon: Icons.history,
                          label: 'Audit Logs',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('logs'),
                        ),
                      ],
                    ),
                  ),
                  // Help Section
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
          ),
          // Main Content
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: Column(
                children: [
                  // Header
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Search Bar
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search users, pets, or records...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Notification Icon
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
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Admin User
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Text(
                                  'Admin User',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'admin@pawvera.com',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
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
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        // Page Title
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User Management',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Manage and monitor pet owner accounts',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Search and Filter
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() => searchQuery = value);
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Search users by name or email...',
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: DropdownButton<String>(
                                  value: statusFilter,
                                  underline: const SizedBox(),
                                  items: [
                                    'All Status',
                                    'Active',
                                    'Inactive',
                                  ]
                                      .map((status) =>
                                          DropdownMenuItem(
                                            value: status,
                                            child: Text(status),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() =>
                                        statusFilter = value ?? 'All Status');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Users Table
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 24,
                              columns: const [
                                DataColumn(label: Text('User')),
                                DataColumn(label: Text('Contact')),
                                DataColumn(label: Text('Location')),
                                DataColumn(label: Text('Pets')),
                                DataColumn(label: Text('Joined')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Actions')),
                              ],
                              rows: filteredUsers
                                  .map(
                                    (user) => DataRow(
                                      cells: [
                                        DataCell(
                                          Row(
                                            children: [
                                              Container(
                                                width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  color: user['color'],
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    user['initials'],
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    user['name'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    user['email'],
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        DataCell(
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.email,
                                                    size: 16,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(user['email']),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.phone,
                                                    size: 16,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(user['phone']),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                size: 16,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(user['location']),
                                            ],
                                          ),
                                        ),
                                        DataCell(
                                          Text('${user['pets']} pets'),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today,
                                                size: 16,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(user['joined']),
                                            ],
                                          ),
                                        ),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: user['status'] ==
                                                      'active'
                                                  ? Colors.green.shade100
                                                  : Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              user['status'],
                                              style: TextStyle(
                                                color: user['status'] ==
                                                        'active'
                                                    ? Colors.green.shade700
                                                    : Colors.grey.shade700,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          IconButton(
                                            icon: const Icon(
                                              Icons.more_vert,
                                              size: 18,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: isActive
          ? BoxDecoration(
              color: const Color(0xFF5A9B7E),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.white : Colors.grey,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontSize: 13,
          ),
        ),
        onTap: onTap,
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
  String searchQuery = '';

  final List<Map<String, dynamic>> pets = [
    {
      'name': 'Buddy',
      'type': 'Dog',
      'breed': 'Golden Retriever',
      'age': 3,
      'color': 'Golden',
      'owner': 'John Doe',
      'registrationDate': '2023-05-15',
      'hasQRTag': true,
      'icon': '🐕',
    },
    {
      'name': 'Max',
      'type': 'Dog',
      'breed': 'Labrador',
      'age': 2,
      'color': 'Black',
      'owner': 'Jane Smith',
      'registrationDate': '2023-08-22',
      'hasQRTag': false,
      'icon': '🐕',
    },
    {
      'name': 'Charlie',
      'type': 'Cat',
      'breed': 'Persian',
      'age': 1,
      'color': 'White',
      'owner': 'Alice Brown',
      'registrationDate': '2024-01-10',
      'hasQRTag': true,
      'icon': '🐱',
    },
  ];

  List<Map<String, dynamic>> get filteredPets {
    if (searchQuery.isEmpty) {
      return pets;
    }
    return pets.where((pet) {
      final query = searchQuery.toLowerCase();
      return pet['name'].toString().toLowerCase().contains(query) ||
          pet['breed'].toString().toLowerCase().contains(query) ||
          pet['owner'].toString().toLowerCase().contains(query);
    }).toList();
  }

  Map<String, List<Map<String, dynamic>>> get petsByType {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var pet in filteredPets) {
      final type = pet['type'] as String;
      grouped.putIfAbsent(type, () => []);
      grouped[type]!.add(pet);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'PawVera Admin',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Divider(color: Colors.grey[200]),
                  _buildNavItem(
                    icon: Icons.dashboard,
                    label: 'Dashboard',
                    isActive: false,
                    onTap: () => widget.onNavigate('dashboard'),
                  ),
                  _buildNavItem(
                    icon: Icons.people,
                    label: 'Users',
                    isActive: false,
                    onTap: () => widget.onNavigate('users'),
                  ),
                  _buildNavItem(
                    icon: Icons.store,
                    label: 'Pet Supplies Stores',
                    isActive: false,
                    onTap: () => widget.onNavigate('stores'),
                  ),
                  _buildNavItem(
                    icon: Icons.business,
                    label: 'Service Provider Shops',
                    isActive: false,
                    onTap: () => widget.onNavigate('services'),
                  ),
                  _buildNavItem(
                    icon: Icons.category,
                    label: 'Pet Types',
                    isActive: false,
                    onTap: () => widget.onNavigate('types'),
                  ),
                  _buildNavItem(
                    icon: Icons.pets,
                    label: 'Pets',
                    isActive: true,
                    onTap: () {},
                  ),
                  _buildNavItem(
                    icon: Icons.favorite,
                    label: 'Pet Adoption',
                    isActive: false,
                    onTap: () => widget.onNavigate('adoption'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pets',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.account_circle, color: Colors.grey),
                          const SizedBox(width: 12),
                          const Icon(Icons.notifications, color: Colors.grey),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('Admin', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() => searchQuery = value);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search by name, breed, or owner',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Column(
                                children: [
                                  const Text('Total Pets', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${filteredPets.length}',
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Column(
                                children: [
                                  const Text('With QR Tags', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${filteredPets.where((p) => p['hasQRTag']).length}',
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Column(
                                children: [
                                  const Text('Pet Types', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${petsByType.keys.length}',
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ...petsByType.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${entry.key}s (${entry.value.length})',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              GridView.count(
                                crossAxisCount: 3,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.2,
                                children: entry.value.map((pet) => _buildPetCard(pet)).toList(),
                              ),
                              const SizedBox(height: 32),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetCard(Map<String, dynamic> pet) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pet['icon'],
                  style: const TextStyle(fontSize: 24),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: pet['type'] == 'Dog' ? Colors.brown[100] : Colors.orange[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    pet['type'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: pet['type'] == 'Dog' ? Colors.brown : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pet['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      if (pet['hasQRTag'])
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const Text(
                            'QR',
                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${pet['breed']} • ${pet['age']} years',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pet['color'],
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Owner: ${pet['owner']}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Reg: ${pet['registrationDate']}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.visibility, size: 14),
                    label: const Text('View'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: isActive
          ? BoxDecoration(
              color: const Color(0xFF5A9B7E),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.white : Colors.grey,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontSize: 13,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}


class PetAdoptionPage extends StatefulWidget {
  const PetAdoptionPage({super.key, this.onNavigate});

  final Function(String)? onNavigate;

  @override
  State<PetAdoptionPage> createState() => _PetAdoptionPageState();
}

class _PetAdoptionPageState extends State<PetAdoptionPage> {
  String searchQuery = '';
  String statusFilter = 'all';

  final List<Map<String, dynamic>> adoptions = [
    {
      'name': 'Max',
      'type': 'Dog',
      'breed': 'Labrador',
      'age': 2,
      'color': 'Black',
      'status': 'pending',
      'requester': 'Alice Brown',
      'description': 'Friendly and energetic dog looking for a loving home',
      'icon': '🐕',
    },
    {
      'name': 'Charlie',
      'type': 'Dog',
      'breed': 'Golden Retriever',
      'age': 3,
      'color': 'Golden',
      'status': 'pending',
      'requester': 'Bob Wilson',
      'description': 'Gentle and affectionate companion',
      'icon': '🐕',
    },
    {
      'name': 'Whiskers',
      'type': 'Cat',
      'breed': 'Persian',
      'age': 1,
      'color': 'White',
      'status': 'approved',
      'requester': 'Carol Davis',
      'description': 'Playful kitten ready for adoption',
      'icon': '🐱',
    },
  ];

  List<Map<String, dynamic>> get filteredAdoptions {
    var list = adoptions;
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list.where((a) {
        return a['name'].toString().toLowerCase().contains(q) ||
            a['breed'].toString().toLowerCase().contains(q) ||
            a['requester'].toString().toLowerCase().contains(q);
      }).toList();
    }
    if (statusFilter != 'all') {
      list = list.where((a) => a['status'] == statusFilter).toList();
    }
    return list;
  }

  Map<String, List<Map<String, dynamic>>> get byStatus {
    final Map<String, List<Map<String, dynamic>>> map = {};
    for (var a in filteredAdoptions) {
      final s = a['status'] as String;
      map.putIfAbsent(s, () => []);
      map[s]!.add(a);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          SizedBox(
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
                            Text('PawVera Admin', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            Text('Platform Management', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                        _buildNavItem(icon: Icons.dashboard, label: 'Dashboard', isActive: false, onTap: () => widget.onNavigate?.call('dashboard')),
                        _buildNavItem(icon: Icons.people, label: 'Users', isActive: false, onTap: () => widget.onNavigate?.call('users')),
                        _buildNavItem(icon: Icons.store, label: 'Pet Supplies Stores', isActive: false, onTap: () => widget.onNavigate?.call('stores')),
                        _buildNavItem(icon: Icons.business, label: 'Service Provider Shops', isActive: false, onTap: () => widget.onNavigate?.call('services')),
                        _buildNavItem(icon: Icons.category, label: 'Pet Types', isActive: false, onTap: () => widget.onNavigate?.call('types')),
                        _buildNavItem(icon: Icons.pets, label: 'Pets', isActive: false, onTap: () => widget.onNavigate?.call('pets')),
                        _buildNavItem(icon: Icons.favorite, label: 'Pet Adoption', isActive: true, onTap: () {}),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main content
          Expanded(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Pet Adoption', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Icon(Icons.account_circle, color: Colors.grey),
                          const SizedBox(width: 12),
                          const Icon(Icons.notifications, color: Colors.grey),
                          const SizedBox(width: 16),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)), child: const Text('Admin', style: TextStyle(fontSize: 12))),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (v) => setState(() => searchQuery = v),
                                decoration: InputDecoration(hintText: 'Search by name, breed, or requester', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
                              ),
                            ),
                            const SizedBox(width: 16),
                            DropdownButton<String>(
                              value: statusFilter,
                              items: const [
                                DropdownMenuItem(value: 'all', child: Text('All Statuses')),
                                DropdownMenuItem(value: 'pending', child: Text('Pending Approval')),
                                DropdownMenuItem(value: 'approved', child: Text('Approved')),
                              ],
                              onChanged: (v) => setState(() => statusFilter = v ?? 'all'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        if (byStatus.containsKey('pending')) ...[
                          Text('Pending Approval (${byStatus['pending']!.length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          GridView.count(
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.3,
                            children: byStatus['pending']!.map((a) => _adoptionCard(a, true)).toList(),
                          ),
                          const SizedBox(height: 32),
                        ],
                        if (byStatus.containsKey('approved')) ...[
                          Text('Approved Listings (${byStatus['approved']!.length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          GridView.count(
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.3,
                            children: byStatus['approved']!.map((a) => _adoptionCard(a, false)).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _adoptionCard(Map<String, dynamic> a, bool pending) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: pending ? Colors.orange : Colors.grey[300]!, width: pending ? 2 : 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: pending ? Colors.orange[50] : Colors.grey[50],
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(a['icon'], style: const TextStyle(fontSize: 24)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: pending ? Colors.orange[100] : Colors.green[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(pending ? 'Pending' : 'Approved', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: pending ? Colors.orange : Colors.green)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 6),
                Text('${a['type']} • ${a['breed']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 4),
                Text('${a['age']} years • ${a['color']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 8),
                Text('Requester: ${a['requester']}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(a['description'], maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 8),
                if (pending)
                  Row(
                    children: [
                      IconButton(icon: const Icon(Icons.check_circle, color: Colors.green, size: 20), onPressed: () {}),
                      const SizedBox(width: 8),
                      IconButton(icon: const Icon(Icons.cancel, color: Colors.red, size: 20), onPressed: () {}),
                    ],
                  )
                else
                  OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.visibility, size: 14), label: const Text('View')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required bool isActive, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: isActive ? BoxDecoration(color: const Color(0xFF5A9B7E), borderRadius: BorderRadius.circular(8)) : null,
      child: ListTile(
        leading: Icon(icon, color: isActive ? Colors.white : Colors.grey),
        title: Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.black, fontSize: 13)),
        onTap: onTap,
      ),
    );
  }

}


class PetSuppliesStoresPage extends StatefulWidget {
  const PetSuppliesStoresPage({super.key, this.onNavigate});

  final Function(String)? onNavigate;

  @override
  State<PetSuppliesStoresPage> createState() => _PetSuppliesStoresPageState();
}

class _PetSuppliesStoresPageState extends State<PetSuppliesStoresPage> {
  String searchQuery = '';
  String statusFilter = 'All Statuses';

  final List<Map<String, dynamic>> stores = [
    {
      'name': 'Pet Supplies Plus',
      'status': 'Active',
      'owner': 'John Anderson',
      'email': 'john@petsupplies.com',
      'location': 'Online Store',
      'commission': '15%',
      'products': 245,
      'orders': 156,
      'icon': Icons.shopping_bag,
    },
    {
      'name': 'Furry Friends Store',
      'status': 'Active',
      'owner': 'Sarah Lee',
      'email': 'sarah@furryfriends.com',
      'location': 'East Mall, Suite 100',
      'commission': '12%',
      'products': 180,
      'orders': 89,
      'icon': Icons.shopping_bag,
    },
  ];

  List<Map<String, dynamic>> get filteredStores {
    return stores
        .where((store) {
          final matchesSearch = store['name']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              store['owner']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
          final matchesStatus = statusFilter == 'All Statuses' ||
              store['status'].toString() == statusFilter;
          return matchesSearch && matchesStatus;
        })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          SizedBox(
            width: 250,
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
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
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  // Navigation Items
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildNavItem(
                          icon: Icons.dashboard,
                          label: 'Dashboard',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('dashboard'),
                        ),
                        _buildNavItem(
                          icon: Icons.people,
                          label: 'Users',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('users'),
                        ),
                        _buildNavItem(
                          icon: Icons.store,
                          label: 'Pet Supplies Stores',
                          isActive: true,
                          onTap: () => widget.onNavigate?.call('stores'),
                        ),
                        _buildNavItem(
                          icon: Icons.health_and_safety,
                          label: 'Service Providers Shops',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('services'),
                        ),
                        _buildNavItem(
                          icon: Icons.local_hospital,
                          label: 'Clinics',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('clinics'),
                        ),
                        _buildNavItem(
                          icon: Icons.category,
                          label: 'Pet Types',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('types'),
                        ),
                        _buildNavItem(
                          icon: Icons.favorite,
                          label: 'Pets',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('pets'),
                        ),
                        _buildNavItem(
                          icon: Icons.favorite_border,
                          label: 'Pet Adoption',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('adoption'),
                        ),
                        _buildNavItem(
                          icon: Icons.qr_code,
                          label: 'QR Tags',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('qrtags'),
                        ),
                        _buildNavItem(
                          icon: Icons.notifications,
                          label: 'Reminders',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('reminders'),
                        ),
                        _buildNavItem(
                          icon: Icons.phone_iphone,
                          label: 'Mobile App Preview',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('preview'),
                        ),
                        _buildNavItem(
                          icon: Icons.history,
                          label: 'Audit Logs',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('logs'),
                        ),
                      ],
                    ),
                  ),
                  // Help Section
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
          ),
          // Main Content
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: Column(
                children: [
                  // Header
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Search Bar
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search users, pets, or records...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Notification Icon
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
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Admin User
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Text(
                                  'Admin User',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'admin@pawvera.com',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
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
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        // Page Title
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pet Supplies Stores',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Manage pet supplies stores and their product inventory.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Search and Filter and Add Button
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() => searchQuery = value);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search stores...',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: DropdownButton<String>(
                                value: statusFilter,
                                underline: const SizedBox(),
                                items: [
                                  'All Statuses',
                                  'Active',
                                  'Inactive',
                                ]
                                    .map((status) => DropdownMenuItem(
                                          value: status,
                                          child: Text(status),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() =>
                                      statusFilter = value ?? 'All Statuses');
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.add),
                              label: const Text('Add Store'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Stores List
                        Column(
                          children: filteredStores
                              .map((store) => _buildStoreCard(store))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(Map<String, dynamic> store) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      store['icon'],
                      color: const Color(0xFF5A9B7E),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            store['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              store['status'],
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Owner: ${store['owner']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.email,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            store['email'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            store['location'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.percent,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Commission: ${store['commission']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, size: 20),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Products: ${store['products']}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 24),
              Text(
                'Orders: ${store['orders']}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: isActive
          ? BoxDecoration(
              color: const Color(0xFF5A9B7E),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.white : Colors.grey,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontSize: 13,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class ServiceProvidersShopsPage extends StatefulWidget {
  const ServiceProvidersShopsPage({super.key, this.onNavigate});

  final Function(String)? onNavigate;

  @override
  State<ServiceProvidersShopsPage> createState() =>
      _ServiceProvidersShopsPageState();
}

class _ServiceProvidersShopsPageState extends State<ServiceProvidersShopsPage> {
  String searchQuery = '';

  final List<Map<String, dynamic>> shops = [
    {
      'name': 'Pawfect Spa',
      'category': 'Grooming',
      'status': 'Active',
      'owner': 'Emma Wilson',
      'email': 'emma@pawfectspa.com',
      'location': 'Downtown Plaza',
      'bookings': 78,
      'icon': Icons.cut,
    },
    {
      'name': 'Happy Tails Training',
      'category': 'Training',
      'status': 'Active',
      'owner': 'Mike Brown',
      'email': 'mike@happytails.com',
      'location': 'Park Avenue',
      'bookings': 45,
      'icon': Icons.school,
    },
  ];

  List<Map<String, dynamic>> get filteredShops {
    return shops
        .where((shop) {
          final matchesSearch = shop['name']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              shop['owner']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              shop['category']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
          return matchesSearch;
        })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          SizedBox(
            width: 250,
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
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
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  // Navigation Items
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildNavItem(
                          icon: Icons.dashboard,
                          label: 'Dashboard',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('dashboard'),
                        ),
                        _buildNavItem(
                          icon: Icons.people,
                          label: 'Users',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('users'),
                        ),
                        _buildNavItem(
                          icon: Icons.store,
                          label: 'Pet Supplies Stores',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('stores'),
                        ),
                        _buildNavItem(
                          icon: Icons.health_and_safety,
                          label: 'Service Providers Shops',
                          isActive: true,
                          onTap: () => widget.onNavigate?.call('services'),
                        ),
                        _buildNavItem(
                          icon: Icons.local_hospital,
                          label: 'Clinics',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('clinics'),
                        ),
                        _buildNavItem(
                          icon: Icons.category,
                          label: 'Pet Types',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('types'),
                        ),
                        _buildNavItem(
                          icon: Icons.favorite,
                          label: 'Pets',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('pets'),
                        ),
                        _buildNavItem(
                          icon: Icons.favorite_border,
                          label: 'Pet Adoption',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('adoption'),
                        ),
                        _buildNavItem(
                          icon: Icons.qr_code,
                          label: 'QR Tags',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('qrtags'),
                        ),
                        _buildNavItem(
                          icon: Icons.notifications,
                          label: 'Reminders',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('reminders'),
                        ),
                        _buildNavItem(
                          icon: Icons.phone_iphone,
                          label: 'Mobile App Preview',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('preview'),
                        ),
                        _buildNavItem(
                          icon: Icons.history,
                          label: 'Audit Logs',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('logs'),
                        ),
                      ],
                    ),
                  ),
                  // Help Section
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
          ),
          // Main Content
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: Column(
                children: [
                  // Header
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Search Bar
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search users, pets, or records...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Notification Icon
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
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Admin User
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Text(
                                  'Admin User',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'admin@pawvera.com',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
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
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        // Page Title
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Service Providers Shops',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Manage pet care service providers shops and their offerings.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Search and Add Button
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() => searchQuery = value);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search shops, owners, categories...',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.add),
                              label: const Text('Add Shop'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Shops List
                        Column(
                          children: filteredShops
                              .map((shop) => _buildShopCard(shop))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopCard(Map<String, dynamic> shop) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      shop['icon'],
                      color: const Color(0xFF5A9B7E),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            shop['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              shop['category'],
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          shop['status'],
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Owner: ${shop['owner']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.email,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            shop['email'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            shop['location'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Bookings: ${shop['bookings']}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, size: 20),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {},
                child: const Text('Deactivate'),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: isActive
          ? BoxDecoration(
              color: const Color(0xFF5A9B7E),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.white : Colors.grey,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontSize: 13,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class PetTypesPage extends StatefulWidget {
  const PetTypesPage({super.key, this.onNavigate});

  final Function(String)? onNavigate;

  @override
  State<PetTypesPage> createState() => _PetTypesPageState();
}

class _PetTypesPageState extends State<PetTypesPage> {
  String searchQuery = '';
  String classificationFilter = 'All Classifications';
  String statusFilter = 'All Statuses';

  final List<Map<String, dynamic>> petTypes = [
    {
      'name': 'Dog',
      'classification': 'Dog',
      'status': 'Active',
      'description': 'Domesticated canine companion',
      'store': 'Pet Store A',
      'breeds': ['Labrador Retriever', 'Golden Retriever', 'German Shepherd', 'Bulldog', 'Poodle'],
      'icon': '🐕',
    },
    {
      'name': 'Cat',
      'classification': 'Cat',
      'status': 'Active',
      'description': 'Domesticated feline companion',
      'store': 'Pet Store B',
      'breeds': ['Persian', 'Maine Coon', 'Siamese', 'British Shorthair', 'Ragdoll'],
      'icon': '🐈',
    },
  ];

  List<Map<String, dynamic>> get filteredPetTypes {
    return petTypes
        .where((type) {
          final matchesSearch = type['name']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              type['description']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
          final matchesClassification = classificationFilter == 'All Classifications' ||
              type['classification'].toString() == classificationFilter;
          final matchesStatus = statusFilter == 'All Statuses' ||
              type['status'].toString() == statusFilter;
          return matchesSearch && matchesClassification && matchesStatus;
        })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          SizedBox(
            width: 250,
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
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
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  // Navigation Items
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildNavItem(
                          icon: Icons.dashboard,
                          label: 'Dashboard',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('dashboard'),
                        ),
                        _buildNavItem(
                          icon: Icons.people,
                          label: 'Users',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('users'),
                        ),
                        _buildNavItem(
                          icon: Icons.store,
                          label: 'Pet Supplies Stores',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('stores'),
                        ),
                        _buildNavItem(
                          icon: Icons.health_and_safety,
                          label: 'Service Providers Shops',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('services'),
                        ),
                        _buildNavItem(
                          icon: Icons.local_hospital,
                          label: 'Clinics',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('clinics'),
                        ),
                        _buildNavItem(
                          icon: Icons.category,
                          label: 'Pet Types',
                          isActive: true,
                          onTap: () => widget.onNavigate?.call('types'),
                        ),
                        _buildNavItem(
                          icon: Icons.favorite,
                          label: 'Pets',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('pets'),
                        ),
                        _buildNavItem(
                          icon: Icons.favorite_border,
                          label: 'Pet Adoption',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('adoption'),
                        ),
                        _buildNavItem(
                          icon: Icons.qr_code,
                          label: 'QR Tags',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('qrtags'),
                        ),
                        _buildNavItem(
                          icon: Icons.notifications,
                          label: 'Reminders',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('reminders'),
                        ),
                        _buildNavItem(
                          icon: Icons.phone_iphone,
                          label: 'Mobile App Preview',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('preview'),
                        ),
                        _buildNavItem(
                          icon: Icons.history,
                          label: 'Audit Logs',
                          isActive: false,
                          onTap: () => widget.onNavigate?.call('logs'),
                        ),
                      ],
                    ),
                  ),
                  // Help Section
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
          ),
          // Main Content
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: Column(
                children: [
                  // Header
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Search Bar
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search users, pets, or records...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Notification Icon
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
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Admin User
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Text(
                                  'Admin User',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'admin@pawvera.com',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
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
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        // Page Title
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pet Types Management',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Manage pet species and their default breeds',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Search and Filters and Add Button
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                onChanged: (value) {
                                  setState(() => searchQuery = value);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search pet types...',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: DropdownButton<String>(
                                value: classificationFilter,
                                underline: const SizedBox(),
                                items: [
                                  'All Classifications',
                                  'Dog',
                                  'Cat',
                                  'Bird',
                                  'Rabbit',
                                ]
                                    .map((filter) => DropdownMenuItem(
                                          value: filter,
                                          child: Text(filter),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() =>
                                      classificationFilter = value ?? 'All Classifications');
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: DropdownButton<String>(
                                value: statusFilter,
                                underline: const SizedBox(),
                                items: [
                                  'All Statuses',
                                  'Active',
                                  'Inactive',
                                ]
                                    .map((status) => DropdownMenuItem(
                                          value: status,
                                          child: Text(status),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() =>
                                      statusFilter = value ?? 'All Statuses');
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.add),
                              label: const Text('Add Pet Type'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Pet Types List
                        Column(
                          children: filteredPetTypes
                              .map((petType) => _buildPetTypeCard(petType))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetTypeCard(Map<String, dynamic> petType) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                petType['icon'],
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          petType['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            petType['classification'],
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            petType['status'],
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      petType['description'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Store: ${petType['store']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Default Breeds:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (petType['breeds'] as List<String>)
                    .map((breed) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            breed,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit'),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: isActive
          ? BoxDecoration(
              color: const Color(0xFF5A9B7E),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.white : Colors.grey,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontSize: 13,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
