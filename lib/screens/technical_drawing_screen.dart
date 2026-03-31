import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;
import 'package:universal_html/html.dart' as html_web;
import 'dart:io' show File;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';

import '../models/bush_spec_model.dart';
import '../models/drawing_access_model.dart';

class TechnicalDrawingScreen extends StatefulWidget {
  final OperationType operationType;
  final BushSpecification spec;
  final DrawingAccessEntry entry;

  const TechnicalDrawingScreen({
    super.key,
    required this.operationType,
    required this.spec,
    required this.entry,
  });

  @override
  State<TechnicalDrawingScreen> createState() => _TechnicalDrawingScreenState();
}

class _TechnicalDrawingScreenState extends State<TechnicalDrawingScreen>
    with TickerProviderStateMixin {
  // Dark “digital / industrial HUD” palette — high contrast, readable type
  static const Color _bg = Color(0xFF0A0E14);
  static const Color _panel = Color(0xFF121A24);
  static const Color _panelElevated = Color(0xFF161F2C);
  static const Color _cyan = Color(0xFF22D6EE);
  static const Color _cyanMuted = Color(0xFF5EB8CC);
  static const Color _amber = Color(0xFFFFB020);
  static const Color _mint = Color(0xFF34D399);
  static const Color _textPrimary = Color(0xFFE8F1F8);
  static const Color _textSecondary = Color(0xFF8BA3B8);
  static const Color _borderSubtle = Color(0xFF2A3A4D);

  late AnimationController _drawingCtrl;
  late AnimationController _specCtrl;
  final TransformationController _transformController = TransformationController();
  String? _hoveredLabel;
  String? _selectedHotspot;
  String? _hoveredHotspot;
  late String selectedPartNumber;

  String? get _effectiveHotspot => _hoveredHotspot ?? _selectedHotspot;

  BushSpecification get spec =>
      BushSpecRepository.findByPartNumber(selectedPartNumber)!;
  String get _currentDrawingAssetPath =>
      widget.operationType == OperationType.turning
      ? 'assets/technical_drawings/sf_bush_turning.png'
      : 'assets/technical_drawings/sf_bush_milling.png';

  @override
  void initState() {
    super.initState();
    selectedPartNumber = widget.spec.partNumber;
    _drawingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..forward();
    _specCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _specCtrl.forward();
    });
  }

  @override
  void dispose() {
    _drawingCtrl.dispose();
    _specCtrl.dispose();
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _panelElevated,
        elevation: 0,
        shadowColor: _cyan.withValues(alpha: 0.15),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _cyan),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(Icons.engineering, color: _cyan.withValues(alpha: 0.95), size: 16),
            const SizedBox(width: 8),
            const Text(
              'SF SERIES — MICRON BUSH',
              style: TextStyle(
                fontFamily: 'monospace',
                color: _textPrimary,
                fontSize: 13,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 12),
            _OperationBadge(op: widget.operationType),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: _amber.withValues(alpha: 0.45)),
              borderRadius: BorderRadius.circular(4),
              color: _amber.withValues(alpha: 0.12),
              boxShadow: [
                BoxShadow(
                  color: _amber.withValues(alpha: 0.12),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.verified, color: _amber.withValues(alpha: 0.95), size: 12),
                const SizedBox(width: 4),
                Text(
                  'PO: ${widget.entry.poNumber}  |  PATH: ${widget.entry.pathNo}',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: _amber.withValues(alpha: 0.95),
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Tooltip(
              message: 'Download drawing image',
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: _downloadCurrentDrawing,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                    decoration: BoxDecoration(
                      border: Border.all(color: _cyan.withValues(alpha: 0.35)),
                      borderRadius: BorderRadius.circular(4),
                      color: _panel,
                      boxShadow: [
                        BoxShadow(
                          color: _cyan.withValues(alpha: 0.14),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.download_rounded,
                          size: 14,
                          color: _cyan.withValues(alpha: 0.95),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'DOWNLOAD',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            color: _cyan.withValues(alpha: 0.95),
                            fontSize: 10,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: _cyan.withValues(alpha: 0.35)),
              borderRadius: BorderRadius.circular(4),
              color: _panel,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedPartNumber,
                dropdownColor: _panelElevated,
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: _cyan.withValues(alpha: 0.95),
                  fontSize: 12,
                ),
                items: BushSpecRepository.getAll()
                    .map(
                      (s) => DropdownMenuItem<String>(
                        value: s.partNumber,
                        child: Text(s.partNumber),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => selectedPartNumber = v);
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final drawingPanel = SlideTransition(
            position: Tween<Offset>(begin: const Offset(-0.04, 0), end: Offset.zero)
                .animate(
              CurvedAnimation(parent: _drawingCtrl, curve: Curves.easeOutCubic),
            ),
            child: FadeTransition(
              opacity: _drawingCtrl,
              child: _buildDrawingPanel(),
            ),
          );
          final specPanel = SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.04, 0), end: Offset.zero)
                .animate(
              CurvedAnimation(parent: _specCtrl, curve: Curves.easeOutCubic),
            ),
            child: FadeTransition(
              opacity: _specCtrl,
              child: _buildSpecPanel(),
            ),
          );

          if (constraints.maxWidth >= 900) {
            return Row(
              children: [
                Expanded(flex: 6, child: drawingPanel),
                Expanded(flex: 4, child: specPanel),
              ],
            );
          }
          return Column(
            children: [
              Expanded(flex: 5, child: drawingPanel),
              Expanded(flex: 4, child: specPanel),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDrawingPanel() {
    return Container(
      decoration: BoxDecoration(
        color: _panel,
        border: Border(
          right: BorderSide(color: _borderSubtle.withValues(alpha: 0.8)),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: DotGridPainter()),
          const Positioned(top: 12, left: 12, child: _CornerWidget(pos: CornerPosition.topLeft)),
          const Positioned(top: 12, right: 12, child: _CornerWidget(pos: CornerPosition.topRight)),
          const Positioned(bottom: 12, left: 12, child: _CornerWidget(pos: CornerPosition.bottomLeft)),
          const Positioned(bottom: 12, right: 12, child: _CornerWidget(pos: CornerPosition.bottomRight)),
          Padding(
            padding: const EdgeInsets.all(40),
            child: InteractiveViewer(
              minScale: 0.4,
              maxScale: 10.0,
              constrained: false,
              transformationController: _transformController,
              trackpadScrollCausesScale: true,
              boundaryMargin: const EdgeInsets.all(120),
              child: Stack(
                children: [
                  Image.asset(
                    _currentDrawingAssetPath,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                  ..._buildDrawingHotspotTargets(),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: 0.02,
                        child: CustomPaint(painter: ScanlinePainter()),
                      ),
                    ),
                  ),
                  ..._buildSelectedHighlights(),
                  ..._buildSelectedDimLabels(),
                  if (_effectiveHotspot != null) _buildSelectedMarker(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 6,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '⊕  PINCH / SCROLL TO ZOOM    ✥  DRAG TO PAN',
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: _textSecondary.withValues(alpha: 0.85),
                  fontSize: 9,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Text(
              widget.operationType == OperationType.turning
                  ? 'OPERATION\nTURNING'
                  : 'OPERATION\nMILLING',
              style: TextStyle(
                fontFamily: 'monospace',
                color: _cyan.withValues(alpha: 0.12),
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadCurrentDrawing() async {
    try {
      final bytes = await _buildDownloadImageWithSpecs();
      final operation = widget.operationType == OperationType.turning ? 'turning' : 'milling';
      final filename = 'sf_bush_${operation}_${DateTime.now().millisecondsSinceEpoch}.png';

      if (kIsWeb) {
        final blob = html_web.Blob([bytes]);
        final url = html_web.Url.createObjectUrlFromBlob(blob);
        html_web.AnchorElement(href: url)
          ..setAttribute('download', filename)
          ..click();
        html_web.Url.revokeObjectUrl(url);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Drawing downloaded: $filename')),
        );
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsBytes(bytes);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Drawing saved to: ${file.path}')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to download drawing image')),
      );
    }
  }

  Future<Uint8List> _buildDownloadImageWithSpecs() async {
    final drawingBytes = (await rootBundle.load(_currentDrawingAssetPath)).buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(drawingBytes);
    final frame = await codec.getNextFrame();
    final drawingImage = frame.image;

    const double panelWidth = 640;
    const double padding = 28;
    const double titleHeight = 82;
    const double rowHeight = 26;
    const double sectionGap = 20;

    final List<({String label, String value})> dimensionRows = [
      (label: 'PART NUMBER', value: spec.partNumber),
      (label: 'OD', value: '${spec.od}" (${spec.odTolerance})'),
      (label: 'ID', value: '${spec.idMin}" to ${spec.idMax}" (${spec.idTolerance})'),
      (label: 'LENGTH RANGE', value: spec.lengthRange),
      (label: 'B (RADIUS)', value: spec.b),
      (label: 'C (CHAMFER)', value: spec.c),
      (label: 'F', value: spec.f),
      (label: 'G', value: '${spec.g}"'),
      (label: 'H', value: '${spec.h}"'),
      (label: 'J', value: '${spec.j}"'),
      (label: 'L', value: '${spec.l}°'),
      (label: 'R', value: '${spec.r}"'),
      (label: 'LOCK SCREW', value: spec.lockScrew),
    ];

    final List<({String label, String value})> processRows = [
      (label: 'OPERATION', value: widget.operationType == OperationType.turning ? 'TURNING' : 'MILLING'),
      (label: 'PO NUMBER', value: widget.entry.poNumber),
      (label: 'PATH NO', value: widget.entry.pathNo),
      (label: 'PART SERIES', value: widget.entry.partSeries),
      (label: 'DESCRIPTION', value: widget.entry.description),
      (label: 'MATERIAL', value: 'EN 31'),
      (label: 'HARDNESS', value: 'RC 62-64'),
      (label: 'FINISH', value: 'PRECISION GROUND'),
    ];

    final int rowsCount = dimensionRows.length + processRows.length + 6;
    final double panelHeightEstimate =
        titleHeight + (rowsCount * rowHeight) + (sectionGap * 2) + (padding * 2);
    final double canvasHeight =
        drawingImage.height > panelHeightEstimate ? drawingImage.height.toDouble() : panelHeightEstimate;
    final double canvasWidth = drawingImage.width + panelWidth;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final bgPaint = Paint()..color = _bg;
    canvas.drawRect(Rect.fromLTWH(0, 0, canvasWidth, canvasHeight), bgPaint);

    final drawingRect = Rect.fromLTWH(
      0,
      0,
      drawingImage.width.toDouble(),
      drawingImage.height.toDouble(),
    );
    canvas.drawImageRect(drawingImage, drawingRect, drawingRect, Paint());

    final panelRect = Rect.fromLTWH(
      drawingImage.width.toDouble(),
      0,
      panelWidth,
      canvasHeight,
    );
    canvas.drawRect(panelRect, Paint()..color = _panelElevated);

    double y = padding;
    _drawCanvasText(
      canvas,
      'SF SERIES - MICRON BUSH',
      Offset(drawingImage.width + padding, y),
      fontSize: 20,
      color: _textPrimary,
      weight: FontWeight.w700,
      maxWidth: panelWidth - (padding * 2),
    );
    y += 30;
    _drawCanvasText(
      canvas,
      'Dimensions and process properties',
      Offset(drawingImage.width + padding, y),
      fontSize: 13,
      color: _textSecondary,
      maxWidth: panelWidth - (padding * 2),
    );
    y += titleHeight;

    y = _drawSectionOnCanvas(
      canvas: canvas,
      xStart: drawingImage.width + padding,
      yStart: y,
      width: panelWidth - (padding * 2),
      title: 'DIMENSIONS',
      rows: dimensionRows,
    );
    y += sectionGap;
    _drawSectionOnCanvas(
      canvas: canvas,
      xStart: drawingImage.width + padding,
      yStart: y,
      width: panelWidth - (padding * 2),
      title: 'PROCESS / MATERIAL',
      rows: processRows,
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(canvasWidth.toInt(), canvasHeight.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception('Failed to encode drawing image');
    }
    return byteData.buffer.asUint8List();
  }

  double _drawSectionOnCanvas({
    required Canvas canvas,
    required double xStart,
    required double yStart,
    required double width,
    required String title,
    required List<({String label, String value})> rows,
  }) {
    const rowGap = 24.0;
    _drawCanvasText(
      canvas,
      title,
      Offset(xStart, yStart),
      fontSize: 14,
      color: _amber,
      weight: FontWeight.w700,
      maxWidth: width,
    );
    double y = yStart + 26;
    for (final row in rows) {
      _drawCanvasText(
        canvas,
        row.label,
        Offset(xStart, y),
        fontSize: 11,
        color: _textSecondary,
        weight: FontWeight.w600,
        maxWidth: width * 0.45,
      );
      _drawCanvasText(
        canvas,
        row.value,
        Offset(xStart + (width * 0.48), y),
        fontSize: 12,
        color: _textPrimary,
        weight: FontWeight.w600,
        maxWidth: width * 0.50,
      );
      y += rowGap;
    }
    return y;
  }

  void _drawCanvasText(
    Canvas canvas,
    String text,
    Offset offset, {
    required double fontSize,
    required Color color,
    FontWeight weight = FontWeight.w400,
    required double maxWidth,
  }) {
    final paragraphStyle = ui.ParagraphStyle(
      fontSize: fontSize,
      fontWeight: weight,
      maxLines: 2,
      ellipsis: '...',
    );
    final builder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(ui.TextStyle(color: color))
      ..addText(text);
    final paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: maxWidth));
    canvas.drawParagraph(paragraph, offset);
  }

  List<Widget> _buildSelectedDimLabels() {
    if (_effectiveHotspot == null) return const [];
    final labels = _labelsForSelectedHotspot();
    return labels
        .map(
          (l) => _buildDimLabel(
            l.name,
            l.value,
            l.top,
            l.left,
          ),
        )
        .toList();
  }

  List<({String name, String value, double top, double left})> _labelsForSelectedHotspot() {
    final isTurning = widget.operationType == OperationType.turning;
    switch (_effectiveHotspot) {
      case 'od':
        return [
          (
            name: 'ØOD',
            value: '${spec.od}"',
            top: isTurning ? 0.71 : 0.71,
            left: isTurning ? 0.67 : 0.68,
          ),
        ];
      case 'id':
        return [
          (
            name: 'ØID',
            value: '${spec.idMin}–${spec.idMax}',
            top: isTurning ? 0.79 : 0.79,
            left: isTurning ? 0.33 : 0.35,
          ),
        ];
      case 'f':
        return [
          (
            name: 'ØF',
            value: spec.f,
            top: isTurning ? 0.51 : 0.51,
            left: isTurning ? 0.53 : 0.50,
          ),
        ];
      case 'g':
        return [(name: 'G', value: '${spec.g}"', top: isTurning ? 0.15 : 0.15, left: isTurning ? 0.69 : 0.68)];
      case 'h':
        return [(name: 'H', value: '${spec.h}"', top: isTurning ? 0.25 : 0.24, left: isTurning ? 0.69 : 0.68)];
      case 'j':
        return [(name: 'J', value: '${spec.j}"', top: isTurning ? 0.43 : 0.44, left: isTurning ? 0.57 : 0.57)];
      case 'r':
        return [(name: 'R', value: '${spec.r}"', top: isTurning ? 0.61 : 0.59, left: isTurning ? 0.08 : 0.09)];
      case 'b':
        return [(name: 'B', value: spec.b, top: 0.47, left: 0.52)];
      case 'chamfer':
        return [
          (
            name: 'C',
            value: spec.c,
            top: isTurning ? 0.54 : 0.54,
            left: isTurning ? 0.74 : 0.72,
          ),
        ];
      case 'finish':
        return [(
          name: 'FINISH',
          value: 'PRECISION GROUND',
          top: 0.93,
          left: 0.67,
        )];
      case 'l':
        return [(name: 'L°', value: '${spec.l}°', top: isTurning ? 0.19 : 0.21, left: isTurning ? 0.28 : 0.29)];
      case 'honing':
        return [(
          name: 'Honing',
          value: '${spec.idMin} / ${spec.idMax}',
          top: 0.62,
          left: 0.40,
        )];
      case 'material':
        return [(
          name: 'MAT',
          value: 'EN 31',
          top: 0.90,
          left: 0.67,
        )];
      case 'tolerance':
        return [(
          name: 'TOL',
          value: 'Std Table',
          top: 0.90,
          left: 0.40,
        )];
      default:
        return const [];
    }
  }

  Widget _buildSelectedMarker() {
    final marker = _markerForHotspot(_effectiveHotspot);
    if (marker == null) return const SizedBox.shrink();
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 1,
      child: Align(
        alignment: FractionalOffset(marker.dx, marker.dy),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.85, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _cyan.withValues(alpha: 0.12),
              border: Border.all(color: _cyan, width: 2),
              boxShadow: [
                BoxShadow(
                  color: _cyan.withValues(alpha: 0.55),
                  blurRadius: 18,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _cyan.withValues(alpha: 0.95),
                  boxShadow: [
                    BoxShadow(color: _cyan.withValues(alpha: 0.8), blurRadius: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Offset? _markerForHotspot(String? key) {
    final isTurning = widget.operationType == OperationType.turning;
    switch (key) {
      case 'od':
        return Offset(isTurning ? 0.76 : 0.77, 0.64);
      case 'id':
        return Offset(isTurning ? 0.36 : 0.38, 0.72);
      case 'f':
        return Offset(isTurning ? 0.56 : 0.53, 0.50);
      case 'g':
      case 'h':
      case 'j':
      case 'r':
      case 'b':
      case 'l':
        return const Offset(0.58, 0.30);
      case 'chamfer':
        return Offset(isTurning ? 0.70 : 0.68, 0.58);
      case 'honing':
        return const Offset(0.39, 0.69);
      case 'material':
        return const Offset(0.69, 0.905);
      case 'finish':
        return const Offset(0.69, 0.945);
      case 'tolerance':
        return const Offset(0.42, 0.93);
      case 'part':
        return null;
      default:
        return null;
    }
  }

  List<Widget> _buildSelectedHighlights() {
    if (_effectiveHotspot == null) return const [];
    switch (_effectiveHotspot) {
      case 'od':
        return [_highlightRect(0.63, 0.63, 0.24, 0.12)];
      case 'id':
        return [_highlightRect(0.24, 0.70, 0.20, 0.12)];
      case 'f':
        return [_highlightRect(0.45, 0.48, 0.14, 0.10)];
      case 'g':
      case 'h':
      case 'j':
      case 'l':
      case 'r':
      case 'b':
        return [_highlightRect(0.50, 0.18, 0.28, 0.22)];
      case 'material':
        return [_highlightRect(0.63, 0.878, 0.34, 0.055)];
      case 'finish':
        return [_highlightRect(0.63, 0.932, 0.34, 0.048)];
      case 'tolerance':
        return [_highlightRect(0.38, 0.86, 0.28, 0.12)];
      case 'honing':
        return [_highlightRect(0.28, 0.64, 0.30, 0.16)];
      case 'chamfer':
        return [_highlightRect(0.54, 0.58, 0.22, 0.14)];
      case 'part':
        return const [];
      default:
        return const [];
    }
  }

  Widget _highlightRect(double fx, double fy, double fw, double fh) {
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 1,
      child: Align(
        alignment: FractionalOffset(fx, fy),
        child: FractionallySizedBox(
          widthFactor: fw,
          heightFactor: fh,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            decoration: BoxDecoration(
              color: _cyan.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _cyan.withValues(alpha: 0.95), width: 1.6),
              boxShadow: [
                BoxShadow(
                  color: _cyan.withValues(alpha: 0.45),
                  blurRadius: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDrawingHotspotTargets() {
    final hotspots = <({String id, double fx, double fy, double fw, double fh})>[
      (id: 'od', fx: 0.63, fy: 0.63, fw: 0.24, fh: 0.12),
      (id: 'id', fx: 0.24, fy: 0.70, fw: 0.20, fh: 0.12),
      (id: 'f', fx: 0.45, fy: 0.48, fw: 0.14, fh: 0.10),
      (id: 'g', fx: 0.50, fy: 0.18, fw: 0.28, fh: 0.22),
      (id: 'h', fx: 0.50, fy: 0.18, fw: 0.28, fh: 0.22),
      (id: 'j', fx: 0.50, fy: 0.18, fw: 0.28, fh: 0.22),
      (id: 'l', fx: 0.50, fy: 0.18, fw: 0.28, fh: 0.22),
      (id: 'r', fx: 0.50, fy: 0.18, fw: 0.28, fh: 0.22),
      (id: 'b', fx: 0.50, fy: 0.18, fw: 0.28, fh: 0.22),
      (id: 'material', fx: 0.63, fy: 0.878, fw: 0.34, fh: 0.055),
      (id: 'finish', fx: 0.63, fy: 0.932, fw: 0.34, fh: 0.048),
      (id: 'tolerance', fx: 0.38, fy: 0.86, fw: 0.28, fh: 0.12),
      (id: 'honing', fx: 0.28, fy: 0.64, fw: 0.30, fh: 0.16),
      (id: 'chamfer', fx: 0.54, fy: 0.58, fw: 0.22, fh: 0.14),
    ];

    return hotspots
        .map(
          (h) => _buildDrawingHotspotTarget(
            h.id,
            h.fx,
            h.fy,
            h.fw,
            h.fh,
          ),
        )
        .toList();
  }

  Widget _buildDrawingHotspotTarget(
    String hotspotId,
    double fx,
    double fy,
    double fw,
    double fh,
  ) {
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 1,
      child: Align(
        alignment: FractionalOffset(fx, fy),
        child: FractionallySizedBox(
          widthFactor: fw,
          heightFactor: fh,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hoveredHotspot = hotspotId),
            onExit: (_) => setState(() => _hoveredHotspot = null),
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (_) => setState(() => _selectedHotspot = hotspotId),
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDimLabel(String name, String value, double fracTop, double fracLeft) {
    final hover = _hoveredLabel == name;
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 1,
      child: Align(
        alignment: FractionalOffset(fracLeft, fracTop),
        child: MouseRegion(
          onEnter: (_) => setState(() => _hoveredLabel = name),
          onExit: (_) => setState(() => _hoveredLabel = null),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            decoration: BoxDecoration(
              color: hover
                  ? _cyan.withValues(alpha: 0.14)
                  : _panelElevated.withValues(alpha: 0.92),
              border: Border.all(
                color: _cyan.withValues(alpha: hover ? 0.85 : 0.4),
              ),
              borderRadius: BorderRadius.circular(3),
              boxShadow: hover
                  ? [
                      BoxShadow(
                        color: _cyan.withValues(alpha: 0.25),
                        blurRadius: 10,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _cyan.withValues(alpha: 0.95),
                    boxShadow: [
                      BoxShadow(color: _cyan.withValues(alpha: 0.6), blurRadius: 6),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: _cyanMuted.withValues(alpha: 0.95),
                    fontSize: 9,
                  ),
                ),
                const SizedBox(width: 3),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    value,
                    key: ValueKey(value),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      color: _textPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _interactiveSpecRow(String hotspotId, String label, String value) {
    final active = _hoveredHotspot ?? _selectedHotspot;
    final highlighted = active == hotspotId;
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredHotspot = hotspotId),
      onExit: (_) => setState(() => _hoveredHotspot = null),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _selectedHotspot = hotspotId),
          splashColor: _cyan.withValues(alpha: 0.12),
          highlightColor: _cyan.withValues(alpha: 0.05),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            color: highlighted ? _cyan.withValues(alpha: 0.08) : Colors.transparent,
            child: _SpecRow(label: label, value: value, highlighted: highlighted),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecPanel() {
    return Container(
      color: _bg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Column(
            key: ValueKey(selectedPartNumber),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SectionCard(
                title: 'ACCESS VERIFIED',
                icon: Icons.verified_outlined,
                accentColor: _mint,
                rows: [
                  _SpecRow(label: 'PO NUMBER', value: widget.entry.poNumber),
                  _SpecRow(label: 'PATH NO.', value: widget.entry.pathNo),
                  _SpecRow(label: 'PART SERIES', value: widget.entry.partSeries),
                  _SpecRow(label: 'DESCRIPTION', value: widget.entry.description),
                ],
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'DIMENSIONS',
                icon: Icons.straighten_outlined,
                accentColor: _cyan,
                rows: [
                  _interactiveSpecRow('part', 'PART NUMBER', spec.partNumber),
                  _interactiveSpecRow('od', 'Ø OD', '${spec.od}"'),
                  _interactiveSpecRow('od', 'OD TOLERANCE', spec.odTolerance),
                  _interactiveSpecRow('id', 'Ø ID MIN', '${spec.idMin}"'),
                  _interactiveSpecRow('id', 'Ø ID MAX', '${spec.idMax}"'),
                  _interactiveSpecRow('id', 'ID TOLERANCE', spec.idTolerance),
                  _interactiveSpecRow('l', 'LENGTH RANGE', spec.lengthRange),
                  _interactiveSpecRow('b', 'B (RADIUS)', spec.b),
                  _interactiveSpecRow('chamfer', 'C (CHAMFER)', spec.c),
                  _interactiveSpecRow('f', 'F', spec.f),
                  _interactiveSpecRow('g', 'G', '${spec.g}"'),
                  _interactiveSpecRow('h', 'H', '${spec.h}"'),
                  _interactiveSpecRow('j', 'J', '${spec.j}"'),
                  _interactiveSpecRow('l', 'L°', '${spec.l}°'),
                  _interactiveSpecRow('r', 'R', '${spec.r}"'),
                  _interactiveSpecRow('part', 'LOCK SCREW', spec.lockScrew),
                ],
              ),
              const SizedBox(height: 12),
              if (widget.operationType == OperationType.milling)
                _SectionCard(
                  title: 'HONING & GRINDING SPEC',
                  icon: Icons.precision_manufacturing_outlined,
                  accentColor: _amber,
                  rows: [
                    _interactiveSpecRow('honing', 'ROUGHING — GO GAGE', 'Ø ${spec.idMin}'),
                    _interactiveSpecRow('honing', 'ROUGHING — NOGO GAGE', 'Ø ${spec.idMax}'),
                    _interactiveSpecRow('honing', 'FINISHING — GO GAGE', 'Ø ${spec.idMin}'),
                    _interactiveSpecRow('honing', 'FINISHING — NOGO GAGE', 'Ø ${spec.idMax}'),
                    _interactiveSpecRow('honing', 'OD GRINDING', 'OD-Ø ${spec.od}'),
                    _interactiveSpecRow('honing', 'RUN OUT MAX', '0.005 mm'),
                  ],
                ),
              if (widget.operationType == OperationType.milling)
                const SizedBox(height: 12),
              _SectionCard(
                title: 'MATERIAL & FINISH',
                icon: Icons.layers_outlined,
                accentColor: _amber,
                rows: [
                  _interactiveSpecRow('material', 'MATERIAL', 'EN 31'),
                  _interactiveSpecRow('material', 'HARDNESS', 'RC 62-64'),
                  _interactiveSpecRow('finish', 'FINISH', 'PRECISION GROUND'),
                  _interactiveSpecRow('material', 'SERIES', 'SF SERIES'),
                  if (widget.operationType == OperationType.turning)
                    _interactiveSpecRow('material', 'KNURL', 'MED KNURL'),
                  _interactiveSpecRow('material', 'MFG', 'MICRON BUSH MANUFACTURERS'),
                ],
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'STANDARD TOLERANCES',
                icon: Icons.tune_outlined,
                accentColor: _cyan,
                rows: [
                  _interactiveSpecRow('tolerance', 'METRIC 1-PLACE', '± 0.762'),
                  _interactiveSpecRow('tolerance', 'METRIC 2-PLACE', '± 0.254'),
                  _interactiveSpecRow('tolerance', 'METRIC 3-PLACE', '± 0.127'),
                  _interactiveSpecRow('tolerance', 'METRIC 4-PLACE', '± 0.0127'),
                  _interactiveSpecRow('tolerance', 'INCH FRACTIONAL', '± 1/16'),
                  _interactiveSpecRow('tolerance', 'INCH 1-PLACE', '± .030'),
                  _interactiveSpecRow('tolerance', 'INCH 2-PLACE', '± .010'),
                  _interactiveSpecRow('tolerance', 'INCH 3-PLACE', '± .005'),
                  _interactiveSpecRow('tolerance', 'INCH 4-PLACE', '± .0005'),
                  _interactiveSpecRow('tolerance', 'ANGLE', '± 0.30°'),
                  _interactiveSpecRow('tolerance', 'SURFACES', '3.2 Ra'),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _OperationBadge extends StatelessWidget {
  final OperationType op;
  const _OperationBadge({required this.op});

  @override
  Widget build(BuildContext context) {
    final color = op == OperationType.turning
        ? const Color(0xFF00E5FF)
        : const Color(0xFFFFD600);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 8)],
      ),
      child: Text(
        op == OperationType.turning ? 'OPERATION: TURNING' : 'OPERATION: MILLING',
        style: TextStyle(
          fontFamily: 'monospace',
          color: color,
          fontSize: 10,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  static const Color _cardBg = Color(0xFF121A24);
  static const Color _cardBorder = Color(0xFF2A3A4D);

  final String title;
  final IconData icon;
  final Color accentColor;
  final List<Widget> rows;
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _cardBorder.withValues(alpha: 0.9)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              border: Border(left: BorderSide(color: accentColor, width: 3)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Row(
              children: [
                Icon(icon, color: accentColor, size: 13),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: accentColor,
                    fontSize: 11,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ...rows,
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlighted;
  const _SpecRow({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  static const Color _labelColor = Color(0xFF8BA3B8);
  static const Color _valueColor = Color(0xFFE8F1F8);
  static const Color _divider = Color(0xFF2A3A4D);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: highlighted ? const Color(0xFF22D6EE) : _labelColor,
                    fontSize: 10,
                    letterSpacing: 1.1,
                    fontWeight: highlighted ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    value,
                    key: ValueKey(value),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: _valueColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(color: _divider.withValues(alpha: 0.5), height: 1),
      ],
    );
  }
}

enum CornerPosition { topLeft, topRight, bottomLeft, bottomRight }

class DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF22D6EE).withValues(alpha: 0.06);
    for (double x = 0; x <= size.width; x += 24) {
      for (double y = 0; y <= size.height; y += 24) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF22D6EE).withValues(alpha: 0.04)
      ..strokeWidth = 1;
    for (double y = 0; y <= size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CornerWidget extends StatelessWidget {
  final CornerPosition pos;
  const _CornerWidget({required this.pos});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: CustomPaint(painter: CornerPainter(pos)),
    );
  }
}

class CornerPainter extends CustomPainter {
  final CornerPosition pos;
  CornerPainter(this.pos);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF22D6EE).withValues(alpha: 0.65)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.square;

    const double len = 32;
    Offset o;
    double hx;
    double hy;
    switch (pos) {
      case CornerPosition.topLeft:
        o = const Offset(0, 0);
        hx = len;
        hy = len;
        break;
      case CornerPosition.topRight:
        o = Offset(size.width, 0);
        hx = -len;
        hy = len;
        break;
      case CornerPosition.bottomLeft:
        o = Offset(0, size.height);
        hx = len;
        hy = -len;
        break;
      case CornerPosition.bottomRight:
        o = Offset(size.width, size.height);
        hx = -len;
        hy = -len;
        break;
    }
    canvas.drawLine(o, o + Offset(hx, 0), paint);
    canvas.drawLine(o, o + Offset(0, hy), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

