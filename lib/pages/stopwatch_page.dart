// ============================================================
// stopwatch_page.dart - Menu Stopwatch
// Fitur: Start, Stop, Reset waktu
// Menggunakan Timer dari dart:async untuk update setiap 10ms
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';

/// Halaman Stopwatch dengan fitur Start, Stop, Reset
class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  // Stopwatch bawaan Dart untuk tracking waktu
  final Stopwatch _stopwatch = Stopwatch();

  // Timer untuk update UI setiap 30ms (sekitar 33 fps)
  Timer? _timer;

  // State untuk mengetahui apakah stopwatch sedang berjalan
  bool _isRunning = false;

  // Daftar lap time
  final List<Duration> _laps = [];

  @override
  void dispose() {
    // Hentikan timer saat widget dihapus
    _timer?.cancel();
    super.dispose();
  }

  /// Mulai stopwatch
  void _start() {
    _stopwatch.start();
    // Buat timer periodik untuk update tampilan
    _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      setState(() {}); // Rebuild UI setiap 30ms
    });
    setState(() => _isRunning = true);
  }

  /// Berhenti / pause stopwatch
  void _stop() {
    _stopwatch.stop();
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  /// Reset stopwatch ke 00:00:00.00
  void _reset() {
    _stopwatch.reset();
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _laps.clear();
    });
  }

  /// Catat lap time
  void _lap() {
    setState(() {
      _laps.add(_stopwatch.elapsed);
    });
  }

  /// Format Duration ke string MM:SS.mm
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final milliseconds = (duration.inMilliseconds.remainder(1000) ~/ 10)
        .toString()
        .padLeft(2, '0');
    return '$minutes:$seconds.$milliseconds';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final elapsed = _stopwatch.elapsed;

    return Scaffold(
      // ---- AppBar ----
      appBar: AppBar(
        title: const Text('Stopwatch'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),

      // ---- Body ----
      body: Column(
        children: [
          // ---- Bagian atas: Display waktu ----
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.primaryContainer.withValues(alpha: 0.3),
                    colorScheme.surface,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tampilan waktu utama
                  Text(
                    _formatDuration(elapsed),
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Label status
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _isRunning
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _isRunning ? '● Berjalan' : '○ Berhenti',
                      style: TextStyle(
                        color: _isRunning ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---- Tombol kontrol ----
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Tombol Reset / Lap
                _buildControlButton(
                  label: _isRunning ? 'Lap' : 'Reset',
                  icon: _isRunning
                      ? Icons.flag_rounded
                      : Icons.replay_rounded,
                  color: Colors.grey,
                  onPressed: _isRunning ? _lap : _reset,
                ),

                // Tombol Start / Stop (besar)
                SizedBox(
                  width: 80,
                  height: 80,
                  child: FilledButton(
                    onPressed: _isRunning ? _stop : _start,
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          _isRunning ? Colors.red : Colors.green,
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(
                      _isRunning
                          ? Icons.stop_rounded
                          : Icons.play_arrow_rounded,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Placeholder untuk keseimbangan layout
                _buildControlButton(
                  label: 'Reset',
                  icon: Icons.replay_rounded,
                  color: Colors.red,
                  onPressed: _reset,
                ),
              ],
            ),
          ),

          // ---- Daftar Lap ----
          if (_laps.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Icon(Icons.format_list_numbered_rounded,
                      size: 20, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Lap Times',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 2,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _laps.length,
                itemBuilder: (context, index) {
                  // Tampilkan dari yang terbaru
                  final lapIndex = _laps.length - 1 - index;
                  final lapTime = _laps[lapIndex];

                  // Hitung selisih dengan lap sebelumnya
                  final prevLapTime =
                      lapIndex > 0 ? _laps[lapIndex - 1] : Duration.zero;
                  final diff = lapTime - prevLapTime;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: colorScheme.primaryContainer,
                        child: Text(
                          '${lapIndex + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      title: Text(
                        _formatDuration(lapTime),
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Text(
                        '+${_formatDuration(diff)}',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else
            // Pesan jika belum ada lap
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined,
                        size: 48, color: Colors.grey[300]),
                    const SizedBox(height: 8),
                    Text(
                      'Tekan Lap saat stopwatch berjalan\nuntuk mencatat waktu',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Widget tombol kontrol bulat kecil
  Widget _buildControlButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              side: BorderSide(color: color.withValues(alpha: 0.5)),
            ),
            child: Icon(icon, color: color),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: color),
        ),
      ],
    );
  }
}
