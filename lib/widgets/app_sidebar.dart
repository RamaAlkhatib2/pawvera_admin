import 'package:flutter/material.dart';

class AppSidebar extends StatefulWidget {
  final String activePage;
  final void Function(String) onNavigate;

  const AppSidebar({
    super.key,
    required this.activePage,
    required this.onNavigate,
  });

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  static const _petsPages = {'pets', 'types', 'adoption'};
  static const _providersPages = {
    'services',
    'stores',
    'providerShops',
  };
  late bool _petsExpanded = _petsPages.contains(widget.activePage);
  late bool _providersExpanded =
      _providersPages.contains(widget.activePage);

  @override
  void didUpdateWidget(covariant AppSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_petsPages.contains(widget.activePage) && !_petsExpanded) {
      _petsExpanded = true;
    }
    if (_providersPages.contains(widget.activePage) && !_providersExpanded) {
      _providersExpanded = true;
    }
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required String page,
    double leftPadding = 0,
  }) {
    final isActive = widget.activePage == page;
    return Container(
      margin: EdgeInsets.fromLTRB(8 + leftPadding, 4, 8, 4),
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
        onTap: () => widget.onNavigate(page),
      ),
    );
  }

  Widget _groupHeader({
    required IconData icon,
    required String label,
    required bool isAnyActive,
    required bool expanded,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAnyActive ? const Color(0xFFEFF5F2) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isAnyActive ? const Color(0xFF5A9B7E) : Colors.grey,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isAnyActive ? const Color(0xFF5A9B7E) : Colors.black,
            fontWeight: isAnyActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
        trailing: Icon(
          expanded ? Icons.expand_less : Icons.expand_more,
          color: Colors.grey,
        ),
        onTap: onTap,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'PawVera Admin',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Platform Management',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
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
                  _groupHeader(
                    icon: Icons.business_center,
                    label: 'Providers',
                    isAnyActive: _providersPages.contains(widget.activePage),
                    expanded: _providersExpanded,
                    onTap: () => setState(
                        () => _providersExpanded = !_providersExpanded),
                  ),
                  if (_providersExpanded) ...[
                    _navItem(
                      icon: Icons.health_and_safety,
                      label: 'Add Provider',
                      page: 'services',
                      leftPadding: 16,
                    ),
                    _navItem(
                      icon: Icons.store,
                      label: 'Pet Supplies Stores',
                      page: 'stores',
                      leftPadding: 16,
                    ),
                    _navItem(
                      icon: Icons.storefront,
                      label: 'Service Provider Shops',
                      page: 'providerShops',
                      leftPadding: 16,
                    ),
                  ],
                  _groupHeader(
                    icon: Icons.pets,
                    label: 'Pets',
                    isAnyActive: _petsPages.contains(widget.activePage),
                    expanded: _petsExpanded,
                    onTap: () =>
                        setState(() => _petsExpanded = !_petsExpanded),
                  ),
                  if (_petsExpanded) ...[
                    _navItem(
                      icon: Icons.favorite,
                      label: 'Pets',
                      page: 'pets',
                      leftPadding: 16,
                    ),
                    _navItem(
                      icon: Icons.category,
                      label: 'Pet Types',
                      page: 'types',
                      leftPadding: 16,
                    ),
                    _navItem(
                      icon: Icons.favorite_border,
                      label: 'Pet Adoption',
                      page: 'adoption',
                      leftPadding: 16,
                    ),
                  ],
                  _navItem(
                    icon: Icons.notifications,
                    label: 'Reminders',
                    page: 'reminders',
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
