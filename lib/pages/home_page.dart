// ============================================================
// home_page.dart - Halaman Utama (Dashboard)
// Berisi Drawer navigasi untuk mengakses semua menu fitur
// ============================================================

import 'package:flutter/material.dart';
import 'login_page.dart';
import 'data_kelompok_page.dart';
import 'calculator_page.dart';
import 'cek_bilangan_page.dart';
import 'jumlah_angka_page.dart';
import 'stopwatch_page.dart';
import 'geometri_page.dart';

/// Halaman utama setelah login berhasil
/// Menampilkan dashboard grid dan drawer untuk navigasi
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Daftar menu yang ditampilkan di dashboard
    final List<_MenuItem> menuItems = [
      _MenuItem(
        title: 'Data Kelompok',
        icon: Icons.groups_rounded,
        color: Colors.blue,
        page: const DataKelompokPage(),
      ),
      _MenuItem(
        title: 'Kalkulator +/-',
        icon: Icons.calculate_rounded,
        color: Colors.orange,
        page: const CalculatorPage(),
      ),
      _MenuItem(
        title: 'Cek Bilangan',
        icon: Icons.filter_1_rounded,
        color: Colors.green,
        page: const CekBilanganPage(),
      ),
      _MenuItem(
        title: 'Jumlah Angka',
        icon: Icons.pin_rounded,
        color: Colors.purple,
        page: const JumlahAngkaPage(),
      ),
      _MenuItem(
        title: 'Stopwatch',
        icon: Icons.timer_rounded,
        color: Colors.red,
        page: const StopwatchPage(),
      ),
      _MenuItem(
        title: 'Geometri',
        icon: Icons.change_history_rounded,
        color: Colors.teal,
        page: const GeometriPage(),
      ),
    ];

    return Scaffold(
      // ---- AppBar ----
      appBar: AppBar(
        title: const Text('Horus Dashboard'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),

      // ---- Drawer (Menu Samping) ----
      drawer: _buildDrawer(context, menuItems),

      // ---- Body: Grid Menu ----
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting card
            Card(
              color: colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.waving_hand_rounded,
                      size: 32,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Datang!',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pilih menu di bawah untuk mulai',
                            style: TextStyle(
                              color: colorScheme.onPrimaryContainer
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Label
            Text(
              'Menu Fitur',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Grid menu
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 kolom
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return _buildMenuCard(context, item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Membangun Drawer navigasi
  Widget _buildDrawer(BuildContext context, List<_MenuItem> menuItems) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: Column(
        children: [
          // ---- Header Drawer ----
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary,
                  colorScheme.primaryContainer,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Icon aplikasi
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.remove_red_eye_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Horus App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Aplikasi Tugas Kelompok',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // ---- Daftar Menu di Drawer ----
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Menu Dashboard
                ListTile(
                  leading: const Icon(Icons.dashboard_rounded),
                  title: const Text('Dashboard'),
                  onTap: () => Navigator.pop(context), // Tutup drawer
                ),
                const Divider(),

                // Generate menu dari daftar menuItems
                ...menuItems.map((item) => ListTile(
                      leading: Icon(item.icon, color: item.color),
                      title: Text(item.title),
                      onTap: () {
                        Navigator.pop(context); // Tutup drawer
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => item.page),
                        );
                      },
                    )),

                const Divider(),

                // Menu Logout
                ListTile(
                  leading: Icon(Icons.logout_rounded,
                      color: colorScheme.error),
                  title: Text('Logout',
                      style: TextStyle(color: colorScheme.error)),
                  onTap: () {
                    // Kembali ke halaman login dan hapus semua stack
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun card untuk setiap item menu di grid
  Widget _buildMenuCard(BuildContext context, _MenuItem item) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => item.page),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon menu dalam lingkaran berwarna
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon,
                  size: 32,
                  color: item.color,
                ),
              ),
              const SizedBox(height: 12),
              // Nama menu
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Model data untuk item menu
class _MenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final Widget page;

  _MenuItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.page,
  });
}
