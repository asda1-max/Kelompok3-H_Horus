// ============================================================
// geometri_page.dart - Menu Geometri (Piramida / Limas Segiempat)
// Menghitung Luas Permukaan dan Volume berdasarkan alas & tinggi
//
// Rumus Limas Segiempat:
// - Volume = (1/3) × a² × t
// - Tinggi sisi miring (slant) = √((a/2)² + t²)
// - Luas Permukaan = a² + 2 × a × slant
// ============================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' show Matrix4, Vector3;

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
  bool _isSolidMode = true;

  double get _previewBase {
    final v = double.tryParse(_alasController.text);
    if (v == null || v <= 0) return 1.2;
    return (0.9 + (v / 30)).clamp(0.8, 2.2);
  }

  double get _previewHeight {
    final v = double.tryParse(_tinggiController.text);
    if (v == null || v <= 0) return 1.6;
    return (0.8 + (v / 18)).clamp(0.8, 2.8);
  }

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
          _tinggiMiring = math.sqrt((alas / 2) * (alas / 2) + tinggi * tinggi);

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
                    // Preview 3D limas (wireframe + transparan)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: SizedBox(
                        height: 290,
                        width: double.infinity,
                        child: _PyramidWireframePreview(
                          baseValue: _previewBase,
                          heightValue: _previewHeight,
                          solidMode: _isSolidMode,
                        ),
                      ),
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
                      'Preview 3D interaktif (geser untuk memutar). Bentuk mengikuti input alas & tinggi.',
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer
                            .withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        ChoiceChip(
                          label: const Text('Solid'),
                          selected: _isSolidMode,
                          onSelected: (_) {
                            setState(() => _isSolidMode = true);
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Wireframe'),
                          selected: !_isSolidMode,
                          onSelected: (_) {
                            setState(() => _isSolidMode = false);
                          },
                        ),
                      ],
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
                      onChanged: (_) => setState(() {}),
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
                      onChanged: (_) => setState(() {}),
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

class _PyramidWireframePreview extends StatefulWidget {
  final double baseValue;
  final double heightValue;
  final bool solidMode;

  const _PyramidWireframePreview({
    required this.baseValue,
    required this.heightValue,
    required this.solidMode,
  });

  @override
  State<_PyramidWireframePreview> createState() =>
      _PyramidWireframePreviewState();
}

class _PyramidWireframePreviewState extends State<_PyramidWireframePreview> {
  double _yaw = -0.65;
  double _pitch = 0.38;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.10),
            colorScheme.secondary.withValues(alpha: 0.08),
          ],
        ),
      ),
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _yaw += details.delta.dx * 0.01;
            _pitch -= details.delta.dy * 0.01;
            _pitch = _pitch.clamp(-1.1, 1.1);
          });
        },
        child: CustomPaint(
          painter: _PyramidWireframePainter(
            yaw: _yaw,
            pitch: _pitch,
            edgeColor: colorScheme.primary,
            baseValue: widget.baseValue,
            heightValue: widget.heightValue,
            solidMode: widget.solidMode,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _PyramidWireframePainter extends CustomPainter {
  final double yaw;
  final double pitch;
  final Color edgeColor;
  final double baseValue;
  final double heightValue;
  final bool solidMode;

  const _PyramidWireframePainter({
    required this.yaw,
    required this.pitch,
    required this.edgeColor,
    required this.baseValue,
    required this.heightValue,
    required this.solidMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 18);
    final modelMax = math.max(baseValue, heightValue);
    const cameraDistance = 4.2;
    const nearPlane = 0.55;
    final scale = size.shortestSide * (1.45 / (modelMax + 0.8));

    final halfBase = baseValue / 2;

    final vertices = <Vector3>[
      Vector3(-halfBase, 0.0, -halfBase), // A
      Vector3(halfBase, 0.0, -halfBase), // B
      Vector3(halfBase, 0.0, halfBase), // C
      Vector3(-halfBase, 0.0, halfBase), // D
      Vector3(0.0, heightValue, 0.0), // Puncak
    ];

    final transform = Matrix4.identity()
      ..rotateX(pitch)
      ..rotateY(yaw);

    Vector3 toView(Vector3 v) {
      final tv = transform.transform3(v);
      return Vector3(tv.x, tv.y - (heightValue * 0.2), tv.z);
    }

    final transformed = vertices.map(toView).toList();

    Offset? tryProject(Vector3 v) {
      final denom = cameraDistance - v.z;
      if (denom <= nearPlane) return null;

      final perspective = scale / denom;
      if (!perspective.isFinite) return null;

      return Offset(
        center.dx + v.x * perspective,
        center.dy - v.y * perspective,
      );
    }

    Offset project(Vector3 v) {
      return tryProject(v) ?? center;
    }

    final projected = transformed.map(project).toList();

    // ---- Lantai + Grid sebagai patokan bawah ----
    final floorExtent = math.max(baseValue, heightValue) * 2.0;
    final floorHalf = floorExtent / 2;
    final step = floorExtent / 6;

    final floorCorners = [
      Vector3(-floorHalf, 0, -floorHalf),
      Vector3(floorHalf, 0, -floorHalf),
      Vector3(floorHalf, 0, floorHalf),
      Vector3(-floorHalf, 0, floorHalf),
    ].map((p) => tryProject(toView(p))).toList();

    if (floorCorners.every((c) => c != null)) {
      final floorPath = Path()
        ..moveTo(floorCorners[0]!.dx, floorCorners[0]!.dy)
        ..lineTo(floorCorners[1]!.dx, floorCorners[1]!.dy)
        ..lineTo(floorCorners[2]!.dx, floorCorners[2]!.dy)
        ..lineTo(floorCorners[3]!.dx, floorCorners[3]!.dy)
        ..close();

      final floorFillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.black.withValues(alpha: 0.05);
      canvas.drawPath(floorPath, floorFillPaint);
    }

    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = edgeColor.withValues(alpha: 0.22);

    final axisPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..color = edgeColor.withValues(alpha: 0.36);

    // Garis grid arah X dan Z
    for (double g = -floorHalf; g <= floorHalf + 0.0001; g += step) {
      final a = tryProject(toView(Vector3(-floorHalf, 0, g)));
      final b = tryProject(toView(Vector3(floorHalf, 0, g)));
      final c = tryProject(toView(Vector3(g, 0, -floorHalf)));
      final d = tryProject(toView(Vector3(g, 0, floorHalf)));

      final isAxis = g.abs() < (step / 3);
      if (a != null && b != null) {
        canvas.drawLine(a, b, isAxis ? axisPaint : gridPaint);
      }
      if (c != null && d != null) {
        canvas.drawLine(c, d, isAxis ? axisPaint : gridPaint);
      }
    }

    final faces = <_FaceData>[
      _FaceData([0, 1, 4], Colors.indigo),
      _FaceData([1, 2, 4], Colors.blue),
      _FaceData([2, 3, 4], Colors.teal),
      _FaceData([3, 0, 4], Colors.purple),
      _FaceData([0, 1, 2], Colors.grey),
      _FaceData([0, 2, 3], Colors.grey),
    ];

    if (solidMode) {
      // Painter's algorithm: gambar dari belakang ke depan
      faces.sort((a, b) {
        double zAvg(List<int> idx) =>
            idx.map((i) => transformed[i].z).reduce((x, y) => x + y) /
            idx.length;
        return zAvg(a.indices).compareTo(zAvg(b.indices));
      });

      // Isi sisi transparan + berwarna
      for (final face in faces) {
        final path = Path()
          ..moveTo(projected[face.indices[0]].dx, projected[face.indices[0]].dy)
          ..lineTo(projected[face.indices[1]].dx, projected[face.indices[1]].dy)
          ..lineTo(projected[face.indices[2]].dx, projected[face.indices[2]].dy)
          ..close();

        final isBaseFace =
            (face.indices[0] == 0 && face.indices[1] == 1 && face.indices[2] == 2) ||
            (face.indices[0] == 0 && face.indices[1] == 2 && face.indices[2] == 3);

        final fillPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = face.color.withValues(alpha: isBaseFace ? 0.14 : 0.24);

        canvas.drawPath(path, fillPaint);
      }
    }

    // Garis tebal pada semua rusuk
    final edges = <List<int>>[
      [0, 1],
      [1, 2],
      [2, 3],
      [3, 0],
      [0, 4],
      [1, 4],
      [2, 4],
      [3, 4],
    ];

    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = solidMode ? 3.8 : 4.8
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = edgeColor;

    for (final edge in edges) {
      canvas.drawLine(
        projected[edge[0]],
        projected[edge[1]],
        edgePaint,
      );
    }

    // Highlight titik sudut
    final pointPaint = Paint()..color = edgeColor;
    for (final p in projected) {
      canvas.drawCircle(p, solidMode ? 3.0 : 3.6, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PyramidWireframePainter oldDelegate) {
    return oldDelegate.yaw != yaw ||
        oldDelegate.pitch != pitch ||
        oldDelegate.edgeColor != edgeColor ||
        oldDelegate.baseValue != baseValue ||
        oldDelegate.heightValue != heightValue ||
        oldDelegate.solidMode != solidMode;
  }
}

class _FaceData {
  final List<int> indices;
  final Color color;

  const _FaceData(this.indices, this.color);
}
