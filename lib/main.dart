import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'widgets/app_sidebar.dart';
import 'widgets/page_scaffold.dart';
import 'pages/dashboard_page.dart';
import 'pages/users_page.dart';
import 'pages/stores_page.dart';
import 'pages/service_shops_page.dart';
import 'pages/pet_types_page.dart';
import 'pages/pets_page.dart';
import 'pages/pet_adoption_page.dart';
import 'pages/qr_tags_page.dart';
import 'pages/reminders_page.dart';
import 'pages/audit_logs_page.dart';

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
