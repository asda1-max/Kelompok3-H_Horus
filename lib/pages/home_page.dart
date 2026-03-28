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
import 'kalender_konversi_page.dart';

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
      _MenuItem(
        title: 'Tanggal & Konversi',
        icon: Icons.calendar_month_rounded,
        color: Colors.indigo,
        page: const KalenderKonversiPage(),
      ),
    ];

    return Scaffold(
      backgroundColor: colorScheme.surface,
      // ---- AppBar ----
      appBar: AppBar(
        title: const Text('Horus Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: colorScheme.onSurface,
      ),

      // ---- Drawer (Menu Samping) ----
      drawer: _buildDrawer(context, menuItems),

      // ---- Body: Grid Menu ----
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withValues(alpha: 0.07),
              colorScheme.surface,
              colorScheme.surface,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroCard(context),
              const SizedBox(height: 20),

              // Label section
              Row(
                children: [
                  Text(
                    'Menu Fitur',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${menuItems.length} menu',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // List menu
              Expanded(
                child: ListView.separated(
                  itemCount: menuItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    return _buildMenuCard(context, item, index + 1);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.86),
            colorScheme.tertiary.withValues(alpha: 0.72),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.24),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pilih fitur favoritmu dengan tampilan baru yang lebih clean ✨',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun Drawer navigasi
  Widget _buildDrawer(BuildContext context, List<_MenuItem> menuItems) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
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
  Widget _buildMenuCard(BuildContext context, _MenuItem item, int number) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => item.page),
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: colorScheme.surface,
            border: Border.all(
              color: item.color.withValues(alpha: 0.15),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: item.color.withValues(alpha: 0.12),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    item.icon,
                    size: 24,
                    color: item.color,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '#$number',
                              style: TextStyle(
                                color:
                                    colorScheme.onSurface.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tap untuk membuka',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: item.color,
                  ),
                ),
              ],
            ),
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
