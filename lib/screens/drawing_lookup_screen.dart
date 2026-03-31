import 'package:flutter/material.dart';

import '../constants/branding.dart';
import '../l10n/app_localizations.dart';
import '../models/production_stage.dart';
import '../services/drawing_reference_service.dart';
import '../widgets/logo_watermark.dart';

class DrawingLookupScreen extends StatefulWidget {
  const DrawingLookupScreen({super.key});

  @override
  State<DrawingLookupScreen> createState() => _DrawingLookupScreenState();
}

class _DrawingLookupScreenState extends State<DrawingLookupScreen> {
  final _materialCodeController = TextEditingController(text: 'SS1234');
  final _pathNoController = TextEditingController(text: '12345');

  ProductionStage _selectedStage = ProductionStage.turning;

  @override
  void dispose() {
    _materialCodeController.dispose();
    _pathNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final match = DrawingReferenceService.findByEither(
      materialCodeOrEmpty: _materialCodeController.text,
      pathNoOrEmpty: _pathNoController.text,
    );

    final assetPath = match?.stageToAssetPath[_selectedStage];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawing Lookup'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          const LogoWatermark(),
          ListView(
            padding: const EdgeInsets.all(Branding.spacingL),
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(Branding.spacingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Material Code + Path No',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: Branding.spacingM),
                      Wrap(
                        spacing: Branding.spacingM,
                        runSpacing: Branding.spacingM,
                        children: [
                          SizedBox(
                            width: 320,
                            child: TextField(
                              controller: _materialCodeController,
                              decoration: const InputDecoration(
                                labelText: 'Material Code',
                                prefixIcon: Icon(Icons.qr_code_2),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          SizedBox(
                            width: 320,
                            child: TextField(
                              controller: _pathNoController,
                              decoration: const InputDecoration(
                                labelText: 'Path No',
                                prefixIcon: Icon(Icons.confirmation_number),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Branding.spacingM),
                      Wrap(
                        spacing: Branding.spacingS,
                        runSpacing: Branding.spacingS,
                        children: [
                          _StageChip(
                            label: 'Turning',
                            selected: _selectedStage == ProductionStage.turning,
                            onTap: () => setState(() {
                              _selectedStage = ProductionStage.turning;
                            }),
                          ),
                          _StageChip(
                            label: 'Milling',
                            selected: _selectedStage == ProductionStage.milling,
                            onTap: () => setState(() {
                              _selectedStage = ProductionStage.milling;
                            }),
                          ),
                          _StageChip(
                            label: 'Rough Honing',
                            selected: _selectedStage == ProductionStage.roughHoning,
                            onTap: () => setState(() {
                              _selectedStage = ProductionStage.roughHoning;
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: Branding.spacingM),
                      Container(
                        padding: const EdgeInsets.all(Branding.spacingM),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(Branding.radiusL),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              match == null ? Icons.error_outline : Icons.check_circle_outline,
                              color: match == null
                                  ? Branding.errorColor
                                  : Branding.successColor,
                            ),
                            const SizedBox(width: Branding.spacingM),
                            Expanded(
                              child: Text(
                                match == null
                                    ? 'Match unavailable for this Material Code or Path No.'
                                    : 'Match found. Showing ${_selectedStage.displayName} drawing.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Branding.spacingL),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(Branding.spacingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Digitised Drawing',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: Branding.spacingM),
                      if (assetPath == null)
                        Container(
                          height: 360,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Branding.radiusL),
                            border: Border.all(
                              color: theme.colorScheme.outline.withValues(alpha: 0.2),
                            ),
                            color: Colors.white,
                          ),
                          child: Text(
                            'No drawing to show.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      else
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Branding.radiusL),
                          child: Container(
                            color: Colors.white,
                            height: 520,
                            child: InteractiveViewer(
                              minScale: 0.5,
                              maxScale: 6.0,
                              boundaryMargin: const EdgeInsets.all(24),
                              child: Center(
                                child: Image.asset(
                                  assetPath,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Text(
                                        l10n.notFoundError,
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          color: Branding.errorColor,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: Branding.spacingM),
                      Text(
                        'Tip: Scroll / pinch to zoom. Drag to pan.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Branding.spacingL),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(Branding.spacingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Available reference list',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: Branding.spacingM),
                      ...DrawingReferenceService.references.map(
                        (r) => Container(
                          margin: const EdgeInsets.only(bottom: Branding.spacingS),
                          padding: const EdgeInsets.all(Branding.spacingM),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Branding.radiusL),
                            border: Border.all(
                              color: theme.colorScheme.outline.withValues(alpha: 0.2),
                            ),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.list_alt),
                              const SizedBox(width: Branding.spacingM),
                              Expanded(
                                child: Text(
                                  'Material: ${r.materialCode}   |   Path No: ${r.pathNo}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _materialCodeController.text = r.materialCode;
                                    _pathNoController.text = r.pathNo;
                                  });
                                },
                                child: const Text('Use'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StageChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _StageChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected ? theme.colorScheme.primaryContainer : Colors.white,
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.25),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: selected
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

