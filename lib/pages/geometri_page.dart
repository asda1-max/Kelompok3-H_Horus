// ============================================================
// geometri_page.dart - Menu Geometri (Piramida / Limas Segiempat)
// Menghitung Luas Permukaan dan Volume berdasarkan alas & tinggi
//
// Rumus Limas Segiempat:
// - Volume = (1/3) × a² × t
// - Tinggi sisi miring (slant) = √((a/2)² + t²)
// - Luas Permukaan = a² + 2 × a × slant
// ============================================================

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Halaman untuk menghitung geometri piramida (limas segiempat)
class GeometriPage extends StatefulWidget {
  const GeometriPage({super.key});

  @override
  State<GeometriPage> createState() => _GeometriPageState();
}

class _GeometriPageState extends State<GeometriPage> {
  // Controller input
  final _alasController = TextEditingController();
  final _tinggiController = TextEditingController();

  // Variabel hasil
  double? _volume;
  double? _luasPermukaan;
  double? _tinggiMiring;
  double? _alas;
  double? _tinggi;

  @override
  void dispose() {
    _alasController.dispose();
    _tinggiController.dispose();
    super.dispose();
  }

  /// Fungsi utama untuk menghitung volume dan luas permukaan
  void _hitung() {
    final alas = double.tryParse(_alasController.text);
    final tinggi = double.tryParse(_tinggiController.text);

    // Validasi input
    if (alas == null || tinggi == null || alas <= 0 || tinggi <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Masukkan nilai alas dan tinggi yang valid (> 0)!'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() {
      _alas = alas;
      _tinggi = tinggi;

      // ---- Hitung Volume ----
      // Rumus: V = (1/3) × sisi_alas² × tinggi
      _volume = (1 / 3) * alas * alas * tinggi;

      // ---- Hitung Tinggi Miring (Slant Height) ----
      // Rumus: slant = √((a/2)² + t²)
      _tinggiMiring = sqrt((alas / 2) * (alas / 2) + tinggi * tinggi);

      // ---- Hitung Luas Permukaan ----
      // Rumus: LP = a² + 2 × a × slant
      _luasPermukaan = (alas * alas) + (2 * alas * _tinggiMiring!);
    });
  }

  /// Reset semua
  void _reset() {
    setState(() {
      _alasController.clear();
      _tinggiController.clear();
      _volume = null;
      _luasPermukaan = null;
      _tinggiMiring = null;
      _alas = null;
      _tinggi = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // ---- AppBar ----
      appBar: AppBar(
        title: const Text('Geometri Piramida'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),

      // ---- Body ----
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ---- Ilustrasi Piramida ----
            Card(
              color: colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Icon piramida
                    Icon(
                      Icons.change_history_rounded,
                      size: 56,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Limas Segiempat',
                      style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimaryContainer,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Masukkan sisi alas dan tinggi piramida',
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ---- Card Input ----
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.straighten_rounded,
                            color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Input Dimensi',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Input Sisi Alas
                    TextFormField(
                      controller: _alasController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Sisi Alas (a)',
                        hintText: 'Contoh: 10',
                        prefixIcon: Icon(Icons.crop_square_rounded),
                        suffixText: 'cm',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Input Tinggi
                    TextFormField(
                      controller: _tinggiController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Tinggi (t)',
                        hintText: 'Contoh: 12',
                        prefixIcon: Icon(Icons.height_rounded),
                        suffixText: 'cm',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tombol
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _hitung,
                            icon: const Icon(Icons.calculate_rounded),
                            label: const Text('Hitung'),
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

            // ---- Card Hasil ----
            if (_volume != null && _luasPermukaan != null) ...[
              // Rumus yang digunakan
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.functions_rounded,
                              color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Rumus & Perhitungan',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Rumus Volume
                      _buildRumusItem(
                        'Volume',
                        'V = ⅓ × a² × t',
                        'V = ⅓ × ${_alas!.toStringAsFixed(1)}² × ${_tinggi!.toStringAsFixed(1)}',
                      ),
                      const SizedBox(height: 8),

                      // Rumus Tinggi Miring
                      _buildRumusItem(
                        'Tinggi Miring',
                        's = √((a/2)² + t²)',
                        's = √((${_alas!.toStringAsFixed(1)}/2)² + ${_tinggi!.toStringAsFixed(1)}²)',
                      ),
                      const SizedBox(height: 8),

                      // Rumus Luas Permukaan
                      _buildRumusItem(
                        'Luas Permukaan',
                        'LP = a² + 2 × a × s',
                        'LP = ${_alas!.toStringAsFixed(1)}² + 2 × ${_alas!.toStringAsFixed(1)} × ${_tinggiMiring!.toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Hasil akhir
              Row(
                children: [
                  // Card Volume
                  Expanded(
                    child: _buildHasilCard(
                      context,
                      icon: Icons.view_in_ar_rounded,
                      label: 'Volume',
                      value: '${_volume!.toStringAsFixed(2)} cm³',
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Card Luas Permukaan
                  Expanded(
                    child: _buildHasilCard(
                      context,
                      icon: Icons.square_foot_rounded,
                      label: 'Luas Permukaan',
                      value: '${_luasPermukaan!.toStringAsFixed(2)} cm²',
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Widget untuk menampilkan satu baris rumus
  Widget _buildRumusItem(String label, String rumus, String substitusi) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            rumus,
            style: TextStyle(
              fontFamily: 'monospace',
              color: Colors.grey[700],
              fontSize: 13,
            ),
          ),
          Text(
            substitusi,
            style: TextStyle(
              fontFamily: 'monospace',
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Widget card untuk menampilkan hasil akhir
  Widget _buildHasilCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            // Label
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            // Nilai
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
