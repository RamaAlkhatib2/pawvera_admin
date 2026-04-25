import 'package:flutter/material.dart';

void main() => runApp(const MainApp());

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String currentPage = 'dashboard';

  void _navigate(String page) => setState(() => currentPage = page);

  Widget _buildContent() {
    switch (currentPage) {
      case 'users':
        return const SimplePage(title: 'Users');
      case 'stores':
        return const SimplePage(title: 'Pet Supplies Stores');
      case 'services':
        return const SimplePage(title: 'Service Providers Shops');
      case 'clinics':
        return const SimplePage(title: 'Clinics');
      case 'types':
        return const SimplePage(title: 'Pet Types');
      case 'pets':
        return const SimplePage(title: 'Pets');
      case 'adoption':
        return const SimplePage(title: 'Pet Adoption');
      case 'qrtags':
        return const SimplePage(title: 'QR Tags');
      case 'reminders':
        return const SimplePage(title: 'Reminders');
      case 'preview':
        return const SimplePage(title: 'Mobile App Preview');
      case 'logs':
        return const SimplePage(title: 'Audit Logs');
      default:
        return const SimplePage(title: 'Dashboard');
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

class SimplePage extends StatelessWidget {
  final String title;
  const SimplePage({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Center(child: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
    );
  }
}
