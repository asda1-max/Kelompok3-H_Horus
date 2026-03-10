// ============================================================
// calculator_page.dart - Menu Penjumlahan & Pengurangan
// Dua input field angka + tombol hitung hasil tambah & kurang
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Halaman kalkulator penjumlahan dan pengurangan
class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  // Controller untuk kedua input angka
  final _angka1Controller = TextEditingController();
  final _angka2Controller = TextEditingController();

  // Variabel untuk menyimpan hasil perhitungan
  String? _hasilTambah;
  String? _hasilKurang;

  @override
  void dispose() {
    _angka1Controller.dispose();
    _angka2Controller.dispose();
    super.dispose();
  }

  /// Fungsi utama untuk menghitung penjumlahan & pengurangan
  void _hitung() {
    // Parsing input ke double
    final angka1 = double.tryParse(_angka1Controller.text);
    final angka2 = double.tryParse(_angka2Controller.text);

    // Validasi input
    if (angka1 == null || angka2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Masukkan angka yang valid!'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    // Hitung dan simpan hasil
    setState(() {
      final tambah = angka1 + angka2;
      final kurang = angka1 - angka2;

      // Format: hilangkan .0 jika bilangan bulat
      _hasilTambah = tambah == tambah.roundToDouble() && tambah % 1 == 0
          ? tambah.toInt().toString()
          : tambah.toStringAsFixed(2);
      _hasilKurang = kurang == kurang.roundToDouble() && kurang % 1 == 0
          ? kurang.toInt().toString()
          : kurang.toStringAsFixed(2);
    });
  }

  /// Reset semua input dan hasil
  void _reset() {
    setState(() {
      _angka1Controller.clear();
      _angka2Controller.clear();
      _hasilTambah = null;
      _hasilKurang = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // ---- AppBar ----
      appBar: AppBar(
        title: const Text('Penjumlahan & Pengurangan'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),

      // ---- Body ----
      body: SingleChildScrollView(
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
                    // Judul section
                    Row(
                      children: [
                        Icon(Icons.edit_rounded, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Masukkan Angka',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Input Angka 1
                    TextFormField(
                      controller: _angka1Controller,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        // Hanya izinkan angka, titik, dan minus
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^-?\d*\.?\d*')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Angka Pertama',
                        hintText: 'Contoh: 10',
                        prefixIcon: Icon(Icons.looks_one_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Input Angka 2
                    TextFormField(
                      controller: _angka2Controller,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^-?\d*\.?\d*')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Angka Kedua',
                        hintText: 'Contoh: 5',
                        prefixIcon: Icon(Icons.looks_two_rounded),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tombol Hitung & Reset
                    Row(
                      children: [
                        // Tombol Hitung
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _hitung,
                            icon: const Icon(Icons.calculate_rounded),
                            label: const Text('Hitung'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Tombol Reset
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

            // ---- Card Hasil (hanya tampil jika sudah dihitung) ----
            if (_hasilTambah != null && _hasilKurang != null) ...[
              // Hasil Penjumlahan
              _buildHasilCard(
                context,
                icon: Icons.add_circle_outline_rounded,
                label: 'Penjumlahan',
                expression:
                    '${_angka1Controller.text} + ${_angka2Controller.text}',
                result: _hasilTambah!,
                color: Colors.green,
              ),
              const SizedBox(height: 12),

              // Hasil Pengurangan
              _buildHasilCard(
                context,
                icon: Icons.remove_circle_outline_rounded,
                label: 'Pengurangan',
                expression:
                    '${_angka1Controller.text} - ${_angka2Controller.text}',
                result: _hasilKurang!,
                color: Colors.red,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Widget card untuk menampilkan hasil perhitungan
  Widget _buildHasilCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String expression,
    required String result,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Icon operasi
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            // Detail hasil
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$expression = $result',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
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
