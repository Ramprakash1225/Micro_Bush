import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html_web;
import 'dart:io' show File;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../constants/branding.dart';
import '../l10n/app_localizations.dart';
import '../models/purchase_order.dart';
import '../utils/error_messages.dart';
import '../services/logging_service.dart';

class QRCodeDialog extends StatefulWidget {
  final PurchaseOrder purchaseOrder;

  const QRCodeDialog({super.key, required this.purchaseOrder});

  @override
  State<QRCodeDialog> createState() => _QRCodeDialogState();
}

class _QRCodeDialogState extends State<QRCodeDialog> {
  final GlobalKey _qrKey = GlobalKey();
  bool _isDownloading = false;

  Future<Uint8List?> _captureQRCode() async {
    try {
      final RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      image.dispose();
      return byteData?.buffer.asUint8List();
    } catch (e) {
      LoggingService.error('Error capturing QR code image', e);
      return null;
    }
  }

  Future<void> _downloadQRCode() async {
    if (!mounted) return;

    setState(() {
      _isDownloading = true;
    });

    try {
      final l10n = AppLocalizations.of(context)!;

      // Wait a bit for the widget to render
      await Future.delayed(const Duration(milliseconds: 100));

      // Capture the QR code as image
      final imageBytes = await _captureQRCode();
      if (imageBytes == null || !mounted) {
        if (mounted) {
          ErrorMessages.showErrorSnackBar(context, l10n.downloadFailed);
        }
        return;
      }

      final filename =
          'QR_${widget.purchaseOrder.poNumber}_${DateTime.now().millisecondsSinceEpoch}.png';

      if (kIsWeb) {
        // For web, trigger browser download
        final blob = html_web.Blob([imageBytes]);
        final url = html_web.Url.createObjectUrlFromBlob(blob);
        html_web.AnchorElement(href: url)
          ..setAttribute('download', filename)
          ..click();
        html_web.Url.revokeObjectUrl(url);

        LoggingService.logUserAction(
          'QR Code Downloaded',
          details: {'poNumber': widget.purchaseOrder.poNumber},
        );

        if (mounted) {
          ErrorMessages.showSuccessSnackBar(context, l10n.qrCodeDownloaded);
        }
      } else {
        // For mobile/desktop, save to file system
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$filename');
        await file.writeAsBytes(imageBytes);

        LoggingService.logUserAction(
          'QR Code Downloaded',
          details: {
            'poNumber': widget.purchaseOrder.poNumber,
            'path': file.path,
          },
        );

        if (mounted) {
          ErrorMessages.showSuccessSnackBar(
            context,
            l10n.qrCodeSaved(file.path),
          );
        }
      }
    } catch (e, stackTrace) {
      LoggingService.error('Error downloading QR code', e, stackTrace);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ErrorMessages.showErrorSnackBar(context, l10n.downloadFailed);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final po = widget.purchaseOrder;
    final screenSize = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Branding.radiusXL),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: screenSize.width * 0.85,
          maxHeight: screenSize.height * 0.85,
        ),
        child: Padding(
          padding: const EdgeInsets.all(Branding.spacingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.qrCode,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: l10n.close,
                  ),
                ],
              ),
              const SizedBox(height: Branding.spacingM),
              // Main Content - Side by side layout
              LayoutBuilder(
                builder: (context, constraints) {
                  final availableHeight =
                      (screenSize.height * 0.85) -
                      (Branding.spacingL * 2) - // Padding
                      60 - // Header height
                      Branding.spacingM - // Spacing after header
                      60 - // Button row height
                      Branding.spacingM; // Spacing before buttons

                  return SizedBox(
                    height: availableHeight.clamp(300.0, 600.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left side - QR Code
                        Expanded(
                          flex: 2,
                          child: RepaintBoundary(
                            key: _qrKey,
                            child: Container(
                              padding: const EdgeInsets.all(Branding.spacingM),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    theme.colorScheme.surfaceContainerHighest,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(
                                  Branding.radiusM,
                                ),
                                border: Border.all(
                                  color: theme.colorScheme.outline.withValues(
                                    alpha: 0.2,
                                  ),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // QR Code
                                    QrImageView(
                                      data: po.id,
                                      version: QrVersions.auto,
                                      size: 180.0,
                                      backgroundColor: Colors.transparent,
                                    ),

                                    const SizedBox(width: Branding.spacingM),

                                    // PO Information in the image
                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: Branding.spacingM,
                                          vertical: Branding.spacingS,
                                        ),
                                        decoration: BoxDecoration(
                                          color: theme
                                              .colorScheme
                                              .primaryContainer
                                              .withValues(alpha: 0.3),
                                          borderRadius: BorderRadius.circular(
                                            Branding.radiusS,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _buildImageInfoRow(
                                              context,
                                              l10n.poNumber,
                                              po.poNumber,
                                            ),
                                            const SizedBox(
                                              height: Branding.spacingXS,
                                            ),
                                            _buildImageInfoRow(
                                              context,
                                              l10n.partNumber,
                                              po.partNumber,
                                            ),
                                            const SizedBox(
                                              height: Branding.spacingXS,
                                            ),
                                            _buildImageInfoRow(
                                              context,
                                              l10n.productionQuantity,
                                              po.productionQuantity.toString(),
                                            ),
                                            const SizedBox(
                                              height: Branding.spacingXS,
                                            ),
                                            _buildImageInfoRow(
                                              context,
                                              l10n.deliveryDate,
                                              DateFormat(
                                                'yyyy-MM-dd',
                                              ).format(po.deliveryDate),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: Branding.spacingL),
                        // Right side - Information Details
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(Branding.spacingM),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(
                                Branding.radiusM,
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    l10n.poInformation,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: Branding.spacingM),
                                  _buildCompactInfoRow(
                                    context,
                                    l10n.poNumber,
                                    po.poNumber,
                                    Icons.receipt_long,
                                  ),
                                  const SizedBox(height: Branding.spacingS),
                                  _buildCompactInfoRow(
                                    context,
                                    l10n.partNumber,
                                    po.partNumber,
                                    Icons.inventory_2,
                                  ),
                                  const SizedBox(height: Branding.spacingS),
                                  _buildCompactInfoRow(
                                    context,
                                    l10n.productionQuantity,
                                    po.productionQuantity.toString(),
                                    Icons.production_quantity_limits,
                                  ),
                                  const SizedBox(height: Branding.spacingS),
                                  _buildCompactInfoRow(
                                    context,
                                    l10n.deliveryDate,
                                    DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(po.deliveryDate),
                                    Icons.event,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: Branding.spacingM),
              // Footer with actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isDownloading ? null : _downloadQRCode,
                      icon: _isDownloading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.download),
                      label: Text(l10n.downloadQRCode),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: Branding.spacingM,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: Branding.spacingM),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      label: Text(l10n.close),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: Branding.spacingM,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageInfoRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 16,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: Branding.spacingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
