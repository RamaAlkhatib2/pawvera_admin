import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  final String activePage;
  final void Function(String) onNavigate;

  const AppSidebar({
    super.key,
    required this.activePage,
    required this.onNavigate,
  });

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
                    icon: Icons.health_and_safety,
                    label: 'Add Provider',
                    page: 'services',
                  ),
                  _navItem(
                    icon: Icons.store,
                    label: 'Pet Supplies Stores',
                    page: 'stores',
                  ),
                  _navItem(
                    icon: Icons.storefront,
                    label: 'Service Provider Shops',
                    page: 'providerShops',
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
