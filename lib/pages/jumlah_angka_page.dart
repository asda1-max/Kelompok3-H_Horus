// ============================================================
// jumlah_angka_page.dart - Menu Jumlah Total Angka
// Input deret angka (misal: 123), hitung total tiap digit
// Contoh: 123 → 1 + 2 + 3 = 6
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Halaman untuk menghitung jumlah total digit dari suatu angka
class JumlahAngkaPage extends StatefulWidget {
  const JumlahAngkaPage({super.key});

  @override
  State<JumlahAngkaPage> createState() => _JumlahAngkaPageState();
}

class _JumlahAngkaPageState extends State<JumlahAngkaPage> {
  // Controller input
  final _angkaController = TextEditingController();

  // Variabel hasil
  String? _inputAngka;
  int? _totalJumlah;
  List<int>? _digitList;

  @override
  void dispose() {
    _angkaController.dispose();
    super.dispose();
  }

  /// Fungsi untuk menghitung total penjumlahan digit
  /// Contoh: "456" → [4, 5, 6] → 4+5+6 = 15
  void _hitungTotal() {
    final input = _angkaController.text.trim();

    // Validasi: harus berisi angka, dan hanya digit saja (bisa lebih dari 64-bit)
    if (input.isEmpty || !RegExp(r'^\d+$').hasMatch(input)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Masukkan deret angka yang valid!'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() {
      _inputAngka = input;

      // Konversi setiap karakter digit menjadi integer
      // Contoh: "123" → ['1','2','3'] → [1, 2, 3]
      _digitList = input.split('').map((e) => int.parse(e)).toList();

      // Jumlahkan semua digit
      // Contoh: [1, 2, 3] → 1+2+3 = 6
      _totalJumlah = _digitList!.reduce((a, b) => a + b);
    });
  }

  /// Reset semua
  void _reset() {
    setState(() {
      _angkaController.clear();
      _inputAngka = null;
      _totalJumlah = null;
      _digitList = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // ---- AppBar ----
      appBar: AppBar(
        title: const Text('Jumlah Total Angka'),
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
                        Icon(Icons.pin_rounded, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Masukkan Deret Angka',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Input deret angka
                    TextFormField(
                      controller: _angkaController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        // Hanya izinkan digit 0-9
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Deret Angka',
                        hintText: 'Contoh: 12345',
                        prefixIcon: Icon(Icons.numbers_rounded),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tombol
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _hitungTotal,
                            icon: const Icon(Icons.functions_rounded),
                            label: const Text('Hitung Total'),
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
            if (_inputAngka != null &&
                _digitList != null &&
                _totalJumlah != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Label
                      Row(
                        children: [
                          Icon(Icons.assessment_rounded,
                              color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Hasil Perhitungan',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Tampilkan digit satu per satu dalam chip
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: List.generate(_digitList!.length, (index) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Chip digit
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${_digitList![index]}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                              // Tanda + (kecuali digit terakhir)
                              if (index < _digitList!.length - 1)
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    '+',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }),
                      ),
                      const SizedBox(height: 16),

                      // Garis pemisah
                      const Divider(),
                      const SizedBox(height: 12),

                      // Ekspresi lengkap
                      Text(
                        '${_digitList!.join(' + ')} = $_totalJumlah',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                      ),
                      const SizedBox(height: 8),

                      // Total besar
                      Text(
                        'Total = $_totalJumlah',
                        style:
                            Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                      ),
                    ],
                  ),
                ),
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
}
