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
        return const SimplePage(title: 'Pet Supplies Stores');
      case 'services':
        return const SimplePage(title: 'Service Providers Shops');
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 45, height: 45, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 24)),
        const SizedBox(height: 12),
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Dashboard',
      onNavigate: onNavigate,
      child: Column(children: [
        GridView.count(crossAxisCount: 3, shrinkWrap: true, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.6, physics: const NeverScrollableScrollPhysics(), children: [
          _statCard('Total Users', '1,247', Icons.people, Colors.blue),
          _statCard('Total Pets', '2,134', Icons.pets, Colors.green),
          _statCard('Adoptions', '312', Icons.favorite, Colors.pink),
        ]),
        const SizedBox(height: 24),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: const Text('Recent activity and charts placeholder')),
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
  final users = [
    {'name': 'Sarah Johnson', 'email': 'sarah.j@email.com'},
    {'name': 'Mike Chen', 'email': 'mike.chen@email.com'},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = users.where((u) => u['name']!.toLowerCase().contains(search.toLowerCase())).toList();
    return PageScaffold(
      title: 'Users',
      onNavigate: widget.onNavigate,
      child: Column(children: [
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: Row(children: [
          Expanded(child: TextField(onChanged: (v) => setState(() => search = v), decoration: const InputDecoration(hintText: 'Search users...', prefixIcon: Icon(Icons.search), border: InputBorder.none))),
          ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('Add User'))
        ])),
        const SizedBox(height: 16),
        for (var u in filtered)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Row(children: [CircleAvatar(child: Text(u['name']![0])), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(u['name']!, style: const TextStyle(fontWeight: FontWeight.bold)), Text(u['email']!, style: const TextStyle(color: Colors.grey))])), IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})]),
          ),
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
