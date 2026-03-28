// ============================================================
// kalender_konversi_page.dart - Fitur Tanggal & Konversi
// 1) Input tanggal -> Hari & Weton
// 2) Input tanggal lahir (tahun, bulan, hari, jam, menit)
// 3) Input tanggal Masehi -> Hijriah
// ============================================================

import 'package:flutter/material.dart';

class KalenderKonversiPage extends StatefulWidget {
  const KalenderKonversiPage({super.key});

  @override
  State<KalenderKonversiPage> createState() => _KalenderKonversiPageState();
}

class _KalenderKonversiPageState extends State<KalenderKonversiPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // ---- Feature 1: Hari & Weton ----
  DateTime? _tanggalWeton;
  String? _hasilHari;
  String? _hasilWeton;

  // ---- Feature 2: Tanggal Lahir (Y-M-D + H:M) ----
  DateTime? _tanggalLahir;
  TimeOfDay? _jamLahir;
  _AgeResult? _hasilUsia;

  // ---- Feature 3: Masehi -> Hijriah ----
  DateTime? _tanggalMasehi;
  _HijriDate? _hasilHijriah;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // -----------------------------
  // Util Umum
  // -----------------------------

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  String _namaHari(DateTime date) {
    const hari = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return hari[date.weekday - 1];
  }

  // -----------------------------
  // Feature 1: Hari & Weton
  // -----------------------------

  String _hitungWeton(DateTime date) {
    // Acuan yang umum dipakai: 17-08-1945 = Jumat Legi
    final acuan = DateTime(1945, 8, 17);
    const pasaran = ['Legi', 'Pahing', 'Pon', 'Wage', 'Kliwon'];

    final d1 = DateTime(date.year, date.month, date.day);
    final d2 = DateTime(acuan.year, acuan.month, acuan.day);
    final selisihHari = d1.difference(d2).inDays;
    final index = ((selisihHari % 5) + 5) % 5;
    return pasaran[index];
  }

  Future<void> _pilihTanggalWeton() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalWeton ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: 'Pilih tanggal',
    );

    if (picked == null) return;

    setState(() {
      _tanggalWeton = picked;
      _hasilHari = _namaHari(picked);
      _hasilWeton = _hitungWeton(picked);
    });
  }

  void _resetWeton() {
    setState(() {
      _tanggalWeton = null;
      _hasilHari = null;
      _hasilWeton = null;
    });
  }

  // -----------------------------
  // Feature 2: Tanggal Lahir
  // -----------------------------

  Future<void> _pilihTanggalLahir() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Pilih tanggal lahir',
    );

    if (picked == null) return;

    setState(() {
      _tanggalLahir = picked;
      _hasilUsia = null;
    });
  }

  Future<void> _pilihJamLahir() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _jamLahir ?? const TimeOfDay(hour: 0, minute: 0),
      helpText: 'Pilih jam lahir',
    );

    if (picked == null) return;

    setState(() {
      _jamLahir = picked;
      _hasilUsia = null;
    });
  }

  _AgeResult _hitungUsia(DateTime lahirDateTime, DateTime now) {
    int years = now.year - lahirDateTime.year;
    int months = now.month - lahirDateTime.month;
    int days = now.day - lahirDateTime.day;

    if (days < 0) {
      final prevMonthLastDay = DateTime(now.year, now.month, 0).day;
      days += prevMonthLastDay;
      months -= 1;
    }

    if (months < 0) {
      months += 12;
      years -= 1;
    }

    final totalDays = now.difference(lahirDateTime).inDays;
    final totalHours = now.difference(lahirDateTime).inHours;

    return _AgeResult(
      years: years,
      months: months,
      days: days,
      totalDays: totalDays,
      totalHours: totalHours,
      hariLahir: _namaHari(lahirDateTime),
    );
  }

  void _prosesTanggalLahir() {
    if (_tanggalLahir == null || _jamLahir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lengkapi tanggal lahir dan jam lahir dahulu.'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final lahir = DateTime(
      _tanggalLahir!.year,
      _tanggalLahir!.month,
      _tanggalLahir!.day,
      _jamLahir!.hour,
      _jamLahir!.minute,
    );

    if (lahir.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tanggal lahir tidak boleh di masa depan.'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _hasilUsia = _hitungUsia(lahir, DateTime.now());
    });
  }

  void _resetTanggalLahir() {
    setState(() {
      _tanggalLahir = null;
      _jamLahir = null;
      _hasilUsia = null;
    });
  }

  // -----------------------------
  // Feature 3: Masehi -> Hijriah
  // -----------------------------

  Future<void> _pilihTanggalMasehi() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalMasehi ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: 'Pilih tanggal Masehi',
    );

    if (picked == null) return;

    setState(() {
      _tanggalMasehi = picked;
      _hasilHijriah = _gregorianToHijri(picked);
    });
  }

  void _resetHijriah() {
    setState(() {
      _tanggalMasehi = null;
      _hasilHijriah = null;
    });
  }

  _HijriDate _gregorianToHijri(DateTime date) {
    final jd = _gregorianToJdn(date.year, date.month, date.day);

    int l = jd - 1948440 + 10632;
    final n = ((l - 1) / 10631).floor();
    l = l - 10631 * n + 354;

    final j = (((10985 - l) / 5316).floor()) * (((50 * l) / 17719).floor()) +
        ((l / 5670).floor()) * (((43 * l) / 15238).floor());

    l = l - (((30 - j) / 15).floor()) * (((17719 * j) / 50).floor()) -
        ((j / 16).floor()) * (((15238 * j) / 43).floor()) +
        29;

    final m = ((24 * l) / 709).floor();
    final d = l - ((709 * m) / 24).floor();
    final y = 30 * n + j - 30;

    return _HijriDate(day: d, month: m, year: y);
  }

  int _gregorianToJdn(int year, int month, int day) {
    final a = ((14 - month) / 12).floor();
    final y = year + 4800 - a;
    final m = month + 12 * a - 3;

    return day +
        ((153 * m + 2) / 5).floor() +
        365 * y +
        (y / 4).floor() -
        (y / 100).floor() +
        (y / 400).floor() -
        32045;
  }

  String _namaBulanHijriah(int month) {
    const nama = [
      'Muharram',
      'Safar',
      'Rabiul Awal',
      'Rabiul Akhir',
      'Jumadil Awal',
      'Jumadil Akhir',
      'Rajab',
      'Syaban',
      'Ramadan',
      'Syawal',
      'Zulkaidah',
      'Zulhijah',
    ];
    return nama[month - 1];
  }

  // -----------------------------
  // UI
  // -----------------------------

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitur Tanggal & Konversi'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.event_note_rounded), text: 'Hari & Weton'),
            Tab(icon: Icon(Icons.cake_rounded), text: 'Tanggal Lahir'),
            Tab(icon: Icon(Icons.mosque_rounded), text: 'Masehi-Hijriah'),
          ],
        ),
      ),
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
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHariWetonTab(context),
                _buildTanggalLahirTab(context),
                _buildHijriahTab(context),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildHariWetonTab(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.event_note_rounded, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Input Tanggal',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_month_rounded),
                    title: Text(
                      _tanggalWeton == null
                          ? 'Belum memilih tanggal'
                          : _formatDate(_tanggalWeton!),
                    ),
                    trailing: FilledButton(
                      onPressed: _pilihTanggalWeton,
                      child: const Text('Pilih'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _pilihTanggalWeton,
                          icon: const Icon(Icons.check_rounded),
                          label: const Text('Konversi'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: _resetWeton,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_hasilHari != null && _hasilWeton != null)
            Card(
              color: colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Hasil Konversi',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_hasilHari!} ${_hasilWeton!}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _tanggalWeton != null ? _formatDate(_tanggalWeton!) : '',
                      style: TextStyle(
                        color:
                            colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTanggalLahirTab(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.cake_rounded, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Input Tanggal Lahir',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today_rounded),
                    title: Text(
                      _tanggalLahir == null
                          ? 'Tanggal belum dipilih'
                          : _formatDate(_tanggalLahir!),
                    ),
                    trailing: FilledButton(
                      onPressed: _pilihTanggalLahir,
                      child: const Text('Tanggal'),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.access_time_rounded),
                    title: Text(
                      _jamLahir == null
                          ? 'Jam belum dipilih'
                          : _formatTime(_jamLahir!),
                    ),
                    trailing: FilledButton(
                      onPressed: _pilihJamLahir,
                      child: const Text('Jam'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _prosesTanggalLahir,
                          icon: const Icon(Icons.calculate_rounded),
                          label: const Text('Proses'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: _resetTanggalLahir,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_hasilUsia != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hasil Data Kelahiran',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Hari lahir', _hasilUsia!.hariLahir),
                    _buildInfoRow(
                      'Usia',
                      '${_hasilUsia!.years} tahun ${_hasilUsia!.months} bulan ${_hasilUsia!.days} hari',
                    ),
                    _buildInfoRow('Total hari hidup', '${_hasilUsia!.totalDays} hari'),
                    _buildInfoRow('Total jam hidup', '${_hasilUsia!.totalHours} jam'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHijriahTab(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.mosque_rounded, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Input Tanggal Masehi',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.date_range_rounded),
                    title: Text(
                      _tanggalMasehi == null
                          ? 'Belum memilih tanggal'
                          : _formatDate(_tanggalMasehi!),
                    ),
                    trailing: FilledButton(
                      onPressed: _pilihTanggalMasehi,
                      child: const Text('Pilih'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _pilihTanggalMasehi,
                          icon: const Icon(Icons.swap_horiz_rounded),
                          label: const Text('Konversi'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: _resetHijriah,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_hasilHijriah != null)
            Card(
              color: colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Hasil Konversi Hijriah',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSecondaryContainer,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_hasilHijriah!.day} ${_namaBulanHijriah(_hasilHijriah!.month)} ${_hasilHijriah!.year} H',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSecondaryContainer,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _tanggalMasehi != null ? _formatDate(_tanggalMasehi!) : '',
                      style: TextStyle(
                        color: colorScheme.onSecondaryContainer
                            .withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _AgeResult {
  final int years;
  final int months;
  final int days;
  final int totalDays;
  final int totalHours;
  final String hariLahir;

  const _AgeResult({
    required this.years,
    required this.months,
    required this.days,
    required this.totalDays,
    required this.totalHours,
    required this.hariLahir,
  });
}

class _HijriDate {
  final int day;
  final int month;
  final int year;

  const _HijriDate({
    required this.day,
    required this.month,
    required this.year,
  });
}
