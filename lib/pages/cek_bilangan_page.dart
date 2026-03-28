// ============================================================
// cek_bilangan_page.dart - Menu Cek Bilangan
// Input sebuah bilangan → cek Ganjil/Genap & Prima/Bukan Prima
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Halaman untuk mengecek properti sebuah bilangan
class CekBilanganPage extends StatefulWidget {
  const CekBilanganPage({super.key});

  @override
  State<CekBilanganPage> createState() => _CekBilanganPageState();
}

class _CekBilanganPageState extends State<CekBilanganPage> {
  // Controller input bilangan
  final _bilanganController = TextEditingController();

  // Hasil pengecekan
  int? _bilangan;
  bool? _isGenap;
  bool? _isPrima;

  @override
  void dispose() {
    _bilanganController.dispose();
    super.dispose();
  }

  /// Fungsi untuk mengecek apakah sebuah bilangan adalah bilangan prima
  /// Bilangan prima: bilangan > 1 yang hanya habis dibagi 1 dan dirinya sendiri
  bool _cekPrima(int n) {
    if (n <= 1) return false; // 0 dan 1 bukan prima
    if (n <= 3) return true; // 2 dan 3 adalah prima
    if (n % 2 == 0 || n % 3 == 0) return false; // Kelipatan 2 & 3

    // Cek faktor dari 5 hingga √n
    for (int i = 5; i * i <= n; i += 6) {
      if (n % i == 0 || n % (i + 2) == 0) return false;
    }
    return true;
  }

  /// Fungsi utama untuk memproses pengecekan
  void _cekBilangan() {
    final bilangan = int.tryParse(_bilanganController.text);

    if (bilangan == null || bilangan < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Masukkan bilangan bulat positif yang valid!'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() {
      _bilangan = bilangan;
      _isGenap = bilangan % 2 == 0; // Genap jika habis dibagi 2
      _isPrima = _cekPrima(bilangan); // Cek prima
    });
  }

  /// Reset semua
  void _reset() {
    setState(() {
      _bilanganController.clear();
      _bilangan = null;
      _isGenap = null;
      _isPrima = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // ---- AppBar ----
      appBar: AppBar(
        title: const Text('Cek Bilangan'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),

      // ---- Body ----
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
            child: Image.asset(
              'images/bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: colorScheme.surface.withValues(alpha: 0.85),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
          children: [
            // ---- Card Input ----
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.search_rounded, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Masukkan Bilangan',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Input bilangan
                    TextFormField(
                      controller: _bilanganController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        // Hanya izinkan angka saja
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Bilangan',
                        hintText: 'Contoh: 17',
                        prefixIcon: Icon(Icons.tag_rounded),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tombol
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _cekBilangan,
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Cek'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: _reset,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Reset'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ---- Card Hasil (tampil jika sudah dicek) ----
            if (_bilangan != null && _isGenap != null && _isPrima != null) ...[
              // Tampilkan bilangan yang dicek
              Card(
                color: colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Bilangan',
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_bilangan',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ---- Hasil Ganjil/Genap ----
              _buildResultCard(
                context,
                icon: _isGenap!
                    ? Icons.drag_indicator_rounded
                    : Icons.looks_one_rounded,
                label: 'Jenis Bilangan',
                value: _isGenap! ? 'GENAP' : 'GANJIL',
                description: _isGenap!
                    ? '$_bilangan habis dibagi 2 (sisa = 0)'
                    : '$_bilangan tidak habis dibagi 2 (sisa = ${_bilangan! % 2})',
                color: _isGenap! ? Colors.blue : Colors.orange,
              ),
              const SizedBox(height: 12),

              // ---- Hasil Prima/Bukan Prima ----
              _buildResultCard(
                context,
                icon: _isPrima! ? Icons.star_rounded : Icons.star_border_rounded,
                label: 'Bilangan Prima',
                value: _isPrima! ? 'PRIMA' : 'BUKAN PRIMA',
                description: _isPrima!
                    ? '$_bilangan hanya bisa dibagi 1 dan $_bilangan'
                    : '$_bilangan memiliki faktor selain 1 dan dirinya sendiri',
                color: _isPrima! ? Colors.green : Colors.red,
              ),
            ],
          ],
        ),
      ),
      ),
        ],
      ),
      ),
    );
  }

  /// Widget card untuk menampilkan hasil pengecekan
  Widget _buildResultCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String description,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Icon status
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            // Detail
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
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
