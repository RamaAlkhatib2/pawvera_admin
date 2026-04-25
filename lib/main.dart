import 'package:flutter/material.dart';

void main() => runApp(const MainApp());

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
        return const SimplePage(title: 'Pet Types');
      case 'pets':
        return PetsPage(onNavigate: _navigate);
      case 'adoption':
        return PetAdoptionPage(onNavigate: _navigate);
      case 'qrtags':
        return const SimplePage(title: 'QR Tags');
      case 'reminders':
        return const SimplePage(title: 'Reminders');
      case 'preview':
        return const SimplePage(title: 'Mobile App Preview');
      case 'logs':
        return const SimplePage(title: 'Audit Logs');
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

  const AppSidebar({Key? key, required this.activePage, required this.onNavigate}) : super(key: key);

  Widget _navItem({required IconData icon, required String label, required String page}) {
    final isActive = activePage == page;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: isActive
          ? BoxDecoration(color: const Color(0xFF5A9B7E), borderRadius: BorderRadius.circular(8))
          : null,
      child: ListTile(
        leading: Icon(icon, color: isActive ? Colors.white : Colors.grey),
        title: Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.black, fontSize: 13)),
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
                    decoration: BoxDecoration(color: const Color(0xFF5A9B7E), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.pets, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                    Text('PawVera Admin', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    Text('Platform Management', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ])
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _navItem(icon: Icons.dashboard, label: 'Dashboard', page: 'dashboard'),
                  _navItem(icon: Icons.people, label: 'Users', page: 'users'),
                  _navItem(icon: Icons.store, label: 'Pet Supplies Stores', page: 'stores'),
                  _navItem(icon: Icons.health_and_safety, label: 'Service Providers Shops', page: 'services'),
                  _navItem(icon: Icons.local_hospital, label: 'Clinics', page: 'clinics'),
                  _navItem(icon: Icons.category, label: 'Pet Types', page: 'types'),
                  _navItem(icon: Icons.favorite, label: 'Pets', page: 'pets'),
                  _navItem(icon: Icons.favorite_border, label: 'Pet Adoption', page: 'adoption'),
                  _navItem(icon: Icons.qr_code, label: 'QR Tags', page: 'qrtags'),
                  _navItem(icon: Icons.notifications, label: 'Reminders', page: 'reminders'),
                  _navItem(icon: Icons.phone_iphone, label: 'Mobile App Preview', page: 'preview'),
                  _navItem(icon: Icons.history, label: 'Audit Logs', page: 'logs'),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFD4E8E4), borderRadius: BorderRadius.circular(8)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Need Help?', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Check our documentation', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {},
                    child: const Text('View Docs', style: TextStyle(color: Colors.grey)),
                  ),
                )
              ]),
            )
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

  const PageScaffold({Key? key, required this.title, required this.child, this.onNavigate}) : super(key: key);

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
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Stack(
                  children: [
                    IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
                    Positioned(right: 8, top: 8, child: Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)))),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: const [Text('Admin User', style: TextStyle(fontSize: 12)), Text('admin@pawvera.com', style: TextStyle(fontSize: 11, color: Colors.grey))]),
                    const SizedBox(width: 12),
                    Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFF5A9B7E), borderRadius: BorderRadius.circular(20)), child: const Icon(Icons.person, color: Colors.white)),
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
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Row(children: [])]),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(width: 48, height: 48, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 24)),
        const SizedBox(height: 10),
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Dashboard',
      onNavigate: onNavigate,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Welcome back! Here's what's happening with your platform.", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 16),

        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.6,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _statCard('Total Users', '1,247', Icons.people, const Color(0xFF2D9CDB)),
            _statCard('Registered Pets', '2,134', Icons.pets, const Color(0xFF2FCF77)),
            _statCard('QR Tags', '2,134', Icons.qr_code, const Color(0xFF7BD7D0)),
            _statCard('Vet Clinics', '3', Icons.local_hospital, const Color(0xFFF5A623)),
            _statCard('Online Stores', '2', Icons.store, const Color(0xFF6FC7FF)),
            _statCard('Service Shops', '3', Icons.build, const Color(0xFFF7B267)),
          ],
        ),

        const SizedBox(height: 24),

        // Pending banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: const Color(0xFFFFF4DB), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFFFE4A3))),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFFFF1D6), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.info_outline, color: Color(0xFFF7A600))),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text('2 Pending Adoption Approvals', style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(height: 4), Text('Review required', style: TextStyle(color: Colors.grey, fontSize: 12))]),
            ]),
            ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B233F)), child: const Text('Review'))
          ]),
        ),

        const SizedBox(height: 24),

        // Main content: chart + activity
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            flex: 2,
            child: Column(children: [
              // Chart card
              Container(
                height: 220,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('User & Pet Growth', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Expanded(child: Center(child: Text('Chart placeholder'))),
                ]),
              ),
              const SizedBox(height: 16),
              // Quick actions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(color: const Color(0xFFFFF1F1), borderRadius: BorderRadius.circular(8)),
                        child: const Center(child: Text('+ Add Veterinary Clinic', style: TextStyle(color: Color(0xFFDF5A5A)))),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(color: const Color(0xFFFFF6EE), borderRadius: BorderRadius.circular(8)),
                        child: const Center(child: Text('+ Add Pet Care Service Shop', style: TextStyle(color: Color(0xFFDF8A5A)))),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(color: const Color(0xFFEFFAF8), borderRadius: BorderRadius.circular(8)),
                        child: const Center(child: Text('+ Add Pet Supplies Store', style: TextStyle(color: Color(0xFF2F9C76)))),
                      ),
                    ),
                  ]),
                ]),
              ),
            ]),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Column(children: [
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text('Recent Activity', style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(height: 12), ListTile(contentPadding: EdgeInsets.zero, leading: CircleAvatar(child: Icon(Icons.person)), title: Text('New user registered'), subtitle: Text('Sarah Johnson • 5 minutes ago')), ListTile(contentPadding: EdgeInsets.zero, leading: CircleAvatar(backgroundColor: Color(0xFFE8FAF2), child: Icon(Icons.pets, color: Color(0xFF2F9C76))), title: Text('Pet profile created'), subtitle: Text('Max (Golden Retriever) • 12 minutes ago'))])),
            ]),
          )
        ])
      ]),
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
      'status': 'active'
    },
    {
      'name': 'Mike Chen',
      'email': 'mike.chen@email.com',
      'phone': '+1 (555) 234-5678',
      'location': 'San Francisco, CA',
      'pets': '1 pet',
      'joined': '2/20/2024',
      'status': 'active'
    },
    {
      'name': 'Emma Davis',
      'email': 'emma.d@email.com',
      'phone': '+1 (555) 345-6789',
      'location': 'Austin, TX',
      'pets': '3 pets',
      'joined': '3/10/2024',
      'status': 'active'
    },
    {
      'name': 'James Wilson',
      'email': 'j.wilson@email.com',
      'phone': '+1 (555) 456-7890',
      'location': 'Seattle, WA',
      'pets': '1 pet',
      'joined': '12/5/2023',
      'status': 'inactive'
    },
    {
      'name': 'Lisa Anderson',
      'email': 'lisa.a@email.com',
      'phone': '+1 (555) 567-8901',
      'location': 'Boston, MA',
      'pets': '2 pets',
      'joined': '4/22/2024',
      'status': 'active'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = users
        .where((u) => u['name']!.toLowerCase().contains(search.toLowerCase()) && (statusFilter == 'All Status' || u['status'] == statusFilter.toLowerCase()))
        .toList();

    return PageScaffold(
      title: 'User Management',
      onNavigate: widget.onNavigate,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Manage and monitor pet owner accounts', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Column(children: [
            // Search + filter row
            Row(children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => search = v),
                  decoration: InputDecoration(hintText: 'Search users by name or email...', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: const EdgeInsets.symmetric(vertical: 12)),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                child: DropdownButton<String>(
                  value: statusFilter,
                  underline: const SizedBox.shrink(),
                  items: const [DropdownMenuItem(value: 'All Status', child: Text('All Status')), DropdownMenuItem(value: 'active', child: Text('Active')), DropdownMenuItem(value: 'inactive', child: Text('Inactive'))],
                  onChanged: (v) => setState(() => statusFilter = v ?? 'All Status'),
                ),
              ),
            ]),

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),

            // Table headers
            Row(children: [
              Expanded(flex: 2, child: Text('User', style: TextStyle(color: Colors.grey.shade600))),
              Expanded(flex: 2, child: Text('Contact', style: TextStyle(color: Colors.grey.shade600))),
              Expanded(flex: 2, child: Text('Location', style: TextStyle(color: Colors.grey.shade600))),
              Expanded(flex: 1, child: Text('Pets', style: TextStyle(color: Colors.grey.shade600))),
              Expanded(flex: 1, child: Text('Joined', style: TextStyle(color: Colors.grey.shade600))),
              Expanded(flex: 1, child: Text('Status', style: TextStyle(color: Colors.grey.shade600))),
              SizedBox(width: 40, child: Text('')),
            ]),

            const SizedBox(height: 8),

            // Rows
            Column(children: [for (var u in filtered)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0)))),
                child: Row(children: [
                  // User
                  Expanded(
                    flex: 2,
                    child: Row(children: [
                      CircleAvatar(backgroundColor: const Color(0xFFB39DDB), child: Text(u['name']!.split(' ').map((s) => s[0]).take(2).join(), style: const TextStyle(color: Colors.white))),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(u['name']!, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(u['email']!, style: TextStyle(color: Colors.grey.shade600))])),
                    ]),
                  ),

                  // Contact
                  Expanded(
                    flex: 2,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(u['email']!, style: TextStyle(color: Colors.grey.shade800)), const SizedBox(height: 6), Text(u['phone']!, style: TextStyle(color: Colors.grey.shade600))]),
                  ),

                  // Location
                  Expanded(flex: 2, child: Text(u['location']!, style: TextStyle(color: Colors.grey.shade700))),

                  // Pets
                  Expanded(flex: 1, child: Text(u['pets']!, style: TextStyle(color: Colors.grey.shade700))),

                  // Joined
                  Expanded(flex: 1, child: Text(u['joined']!, style: TextStyle(color: Colors.grey.shade700))),

                  // Status
                  Expanded(
                    flex: 1,
                    child: Align(alignment: Alignment.centerLeft, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: u['status'] == 'active' ? const Color(0xFFEFFAF1) : const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(20)), child: Text(u['status']!, style: TextStyle(color: u['status'] == 'active' ? const Color(0xFF2F9C76) : Colors.grey.shade600)))),
                  ),

                  // Actions
                  SizedBox(width: 40, child: IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})),
                ]),
              )
            ])
          ]),
        ),
      ]),
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
  const ServiceShopsPage({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<ServiceShopsPage> createState() => _ServiceShopsPageState();
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
      'status': 'active'
    },
    {
      'name': 'Happy Tails Training',
      'category': 'Training',
      'owner': 'Mike Brown',
      'email': 'mike@happytails.com',
      'location': 'Park Avenue',
      'bookings': '45',
      'status': 'active'
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
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: nameCtl, decoration: InputDecoration(hintText: 'Shop Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
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
            TextField(controller: ownerCtl, decoration: InputDecoration(hintText: 'Owner Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
            const SizedBox(height: 12),
            TextField(controller: emailCtl, decoration: InputDecoration(hintText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
            const SizedBox(height: 12),
            TextField(controller: locationCtl, decoration: InputDecoration(hintText: 'Location', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final map = {
                'name': nameCtl.text.isEmpty ? 'New Shop' : nameCtl.text,
                'category': category,
                'owner': ownerCtl.text,
                'email': emailCtl.text,
                'location': locationCtl.text,
                'bookings': '0',
                'status': 'active'
              };
              setState(() => shops.insert(0, map));
              Navigator.of(ctx).pop();
            },
            child: const Text('Add Shop'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = shops.where((s) => s['name']!.toLowerCase().contains(q.toLowerCase())).toList();

    return PageScaffold(
      title: 'Service Providers Shops',
      onNavigate: widget.onNavigate,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Manage pet care service providers shops and their offerings.', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 16),

        // Top row: search + add
        Row(children: [
          Expanded(
            child: TextField(
              onChanged: (v) => setState(() => q = v),
              decoration: InputDecoration(hintText: 'Search shops, owners, categories...', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: const EdgeInsets.symmetric(vertical: 12)),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(onPressed: _openAddServiceDialog, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B233F)), child: const Text('+ Add Shop'))
        ]),

        const SizedBox(height: 16),

        Column(children: [for (var s in filtered)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF0F6F4), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.build)),
                  const SizedBox(width: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [Text(s['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(width: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(8)), child: Text(s['category']!, style: const TextStyle(fontSize: 12)) ), const SizedBox(width: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFEFFAF1), borderRadius: BorderRadius.circular(12)), child: Text(s['status']!, style: const TextStyle(color: Color(0xFF2F9C76))))]),
                    const SizedBox(height: 6),
                    Text('Owner: ${s['owner']}', style: TextStyle(color: Colors.grey.shade700))
                  ])
                ]),
                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
              ]),

              const SizedBox(height: 12),

              Row(children: [
                Row(children: [const Icon(Icons.email, size: 16, color: Colors.grey), const SizedBox(width: 6), Text(s['email']!, style: TextStyle(color: Colors.grey.shade700))]),
                const SizedBox(width: 24),
                Row(children: [const Icon(Icons.location_on, size: 16, color: Colors.grey), const SizedBox(width: 6), Text(s['location']!, style: TextStyle(color: Colors.grey.shade700))]),
              ]),

              const SizedBox(height: 12),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Bookings: ${s['bookings']}', style: TextStyle(color: Colors.grey.shade700)),
                Row(children: [
                  OutlinedButton(onPressed: () {}, child: const Text('Deactivate')),
                  const SizedBox(width: 8),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.delete, color: Colors.red)),
                ])
              ])
            ]),
          )
        ])
      ]),
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
      'status': 'active'
    },
    {
      'name': 'Furry Friends Store',
      'owner': 'Sarah Lee',
      'email': 'sarah@furryfriends.com',
      'location': 'East Mall, Suite 100',
      'commission': '12%',
      'products': '180',
      'orders': '89',
      'status': 'active'
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
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: nameCtl, decoration: InputDecoration(hintText: 'Shop Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: category,
              items: const [
                DropdownMenuItem(value: 'Select category', child: Text('Select category')),
                DropdownMenuItem(value: 'Retail', child: Text('Retail')),
                DropdownMenuItem(value: 'Online', child: Text('Online')),
              ],
              onChanged: (v) => category = v ?? 'Select category',
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(controller: ownerCtl, decoration: InputDecoration(hintText: 'Owner Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
            const SizedBox(height: 12),
            TextField(controller: emailCtl, decoration: InputDecoration(hintText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
            const SizedBox(height: 12),
            TextField(controller: locationCtl, decoration: InputDecoration(hintText: 'Location', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
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
                'status': 'active'
              };
              setState(() => stores.insert(0, map));
              Navigator.of(ctx).pop();
            },
            child: const Text('Add Shop'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = stores.where((s) => s['name']!.toLowerCase().contains(q.toLowerCase())).toList();

    return PageScaffold(
      title: 'Pet Supplies Stores',
      onNavigate: widget.onNavigate,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Manage pet supplies stores and their product inventory.', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Row(children: [
            Expanded(
              child: TextField(
                onChanged: (v) => setState(() => q = v),
                decoration: InputDecoration(hintText: 'Search stores...', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: const EdgeInsets.symmetric(vertical: 12)),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
              child: DropdownButton<String>(
                value: status,
                underline: const SizedBox.shrink(),
                items: const [DropdownMenuItem(value: 'All Statuses', child: Text('All Statuses')), DropdownMenuItem(value: 'Active', child: Text('Active')), DropdownMenuItem(value: 'Inactive', child: Text('Inactive'))],
                onChanged: (v) => setState(() => status = v ?? 'All Statuses'),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(onPressed: _openAddStoreDialog, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B233F)), child: const Text('+ Add Store'))
          ]),
        ),

        const SizedBox(height: 16),

        // Store cards
        Column(children: [for (var s in filtered)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFF0F6F4), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.store),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(s['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: const Color(0xFFEFFAF1), borderRadius: BorderRadius.circular(12)),
                                child: Text(s['status']!, style: const TextStyle(color: Color(0xFF2F9C76))),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('Owner: ${s['owner']}', style: TextStyle(color: Colors.grey.shade700)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
                ],
              ),

              const SizedBox(height: 12),

              // Details row
              Wrap(spacing: 16, runSpacing: 8, children: [
                Row(children: [const Icon(Icons.email, size: 16, color: Colors.grey), const SizedBox(width: 6), Text(s['email']!, style: TextStyle(color: Colors.grey.shade700))]),
                Row(children: [const Icon(Icons.location_on, size: 16, color: Colors.grey), const SizedBox(width: 6), Text(s['location']!, style: TextStyle(color: Colors.grey.shade700))]),
                Row(children: [const Text('%', style: TextStyle(color: Colors.grey)), const SizedBox(width: 6), Text(' Commission: ${s['commission']}', style: TextStyle(color: Colors.grey.shade700))]),
              ]),

              const SizedBox(height: 12),

              Row(children: [Text('Products: ${s['products']}', style: TextStyle(color: Colors.grey.shade700)), const SizedBox(width: 16), Text('Orders: ${s['orders']}', style: TextStyle(color: Colors.grey.shade700))])
            ]),
          )
        ])
      ]),
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
    {'name': 'Buddy', 'breed': 'Golden Retriever'},
    {'name': 'Charlie', 'breed': 'Persian'},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = pets.where((p) => p['name']!.toLowerCase().contains(q.toLowerCase())).toList();
    return PageScaffold(
      title: 'Pets',
      onNavigate: widget.onNavigate,
      child: Column(children: [
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: Row(children: [Expanded(child: TextField(onChanged: (v) => setState(() => q = v), decoration: const InputDecoration(hintText: 'Search pets...', prefixIcon: Icon(Icons.search), border: InputBorder.none))), ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('Add Pet'))])),
        const SizedBox(height: 16),
        Wrap(spacing: 12, runSpacing: 12, children: filtered.map((p) => Container(width: 260, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p['name']!, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 6), Text(p['breed']!, style: const TextStyle(color: Colors.grey)), const SizedBox(height: 8), Row(mainAxisAlignment: MainAxisAlignment.end, children: [OutlinedButton(onPressed: () {}, child: const Text('View'))])]))).toList()),
      ]),
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
  final apps = [
    {'name': 'Max', 'status': 'pending'},
    {'name': 'Whiskers', 'status': 'approved'},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = apps.where((a) => a['name']!.toLowerCase().contains(q.toLowerCase())).toList();
    return PageScaffold(
      title: 'Pet Adoption',
      onNavigate: widget.onNavigate,
      child: Column(children: [
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: Row(children: [Expanded(child: TextField(onChanged: (v) => setState(() => q = v), decoration: const InputDecoration(hintText: 'Search adoptions...', prefixIcon: Icon(Icons.search), border: InputBorder.none))), ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('New Request'))])),
        const SizedBox(height: 16),
        for (var a in filtered)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(a['name']!, style: const TextStyle(fontWeight: FontWeight.bold)), Text('Status: ${a['status']}', style: const TextStyle(color: Colors.grey))])), if (a['status'] == 'pending') Row(children: [TextButton(onPressed: () {}, child: const Text('Approve')), TextButton(onPressed: () {}, child: const Text('Reject'))])]),
          ),
      ]),
    );
  }
}
