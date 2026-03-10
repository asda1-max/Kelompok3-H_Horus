// ============================================================
// data_kelompok_page.dart - Halaman Data Kelompok
// Menampilkan informasi anggota kelompok (Nama & NIM)
// ============================================================

import 'package:flutter/material.dart';

/// Model data untuk satu anggota kelompok
class _Anggota {
  final String nama;
  final String nim;
  final String peran; // Peran dalam kelompok
  final IconData avatar;

  const _Anggota({
    required this.nama,
    required this.nim,
    required this.peran,
    required this.avatar,
  });
}

/// Halaman yang menampilkan daftar anggota kelompok
class DataKelompokPage extends StatelessWidget {
  const DataKelompokPage({super.key});

  // Daftar anggota kelompok (ganti sesuai data asli)
  static const List<_Anggota> _anggota = [
    _Anggota(
      nama: 'Rakha Taufiqurrahman Faisal Aziz',
      nim: '123230071',
      peran: 'anggota',
      avatar: Icons.person,
    ),
    _Anggota(
      nama: 'Elyuzar Fazlurahman',
      nim: '123230216',
      peran: 'anggota',
      avatar: Icons.person_outline,
    ),
    _Anggota(
      nama: 'Muhammad Rizal Wahyu Dharmawan',
      nim: '123230200',
      peran: 'anggota',
      avatar: Icons.person_outline,
    ),
    _Anggota(
      nama: 'Anak Agung Ngurah Sadewa Tedja Jayanegara',
      nim: '123230050',
      peran: 'anggota',
      avatar: Icons.person_outline,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // ---- AppBar ----
      appBar: AppBar(
        title: const Text('Data Kelompok'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),

      // ---- Body ----
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---- Header informasi kelompok ----
          Card(
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.groups_rounded,
                    size: 48,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kelompok 3 kelas H',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mata Kuliah: Pemrograman Mobile',
                    style: TextStyle(
                      color:
                          colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ---- Label ----
          Text(
            'Anggota Kelompok',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),

          // ---- Daftar anggota ----
          ...List.generate(_anggota.length, (index) {
            final anggota = _anggota[index];
            return _buildAnggotaCard(context, anggota, index);
          }),
        ],
      ),
    );
  }

  /// Membangun card untuk setiap anggota
  Widget _buildAnggotaCard(
      BuildContext context, _Anggota anggota, int index) {
    final colorScheme = Theme.of(context).colorScheme;

    // Daftar warna untuk avatar yang berbeda-beda
    final colors = [
      Colors.blue,
      Colors.pink,
      Colors.green,
      Colors.orange,
    ];

    final avatarColor = colors[index % colors.length];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // ---- Avatar ----
            CircleAvatar(
              radius: 28,
              backgroundColor: avatarColor.withValues(alpha: 0.15),
              child: Text(
                // Ambil inisial dari nama
                anggota.nama.split(' ').map((e) => e[0]).take(2).join(),
                style: TextStyle(
                  color: avatarColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // ---- Info anggota ----
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama
                  Text(
                    anggota.nama,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  // NIM
                  Text(
                    'NIM: ${anggota.nim}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),

            // ---- Badge peran ----
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: anggota.peran == ''
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                anggota.peran,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: anggota.peran == ''
                      ? colorScheme.primary
                      : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
