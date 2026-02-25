import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../services/purchase_order_service.dart';
import '../l10n/app_localizations.dart';
import '../utils/error_messages.dart';
import '../constants/branding.dart';
import 'po_detail_screen.dart';
import '../services/logging_service.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture barcodeCapture) {
    final List<Barcode> barcodes = barcodeCapture.barcodes;
    if (barcodes.isEmpty || !mounted) return;

    final barcode = barcodes.first;
    if (barcode.rawValue == null) return;

    final poId = barcode.rawValue!;
    final poService = Provider.of<PurchaseOrderService>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    LoggingService.logUserAction('QR Code Scanned', details: {
      'poId': poId,
    });

    // Check if PO exists
    final po = poService.getPurchaseOrderById(poId);
    if (po != null) {
      // Stop scanning
      _controller.stop();
      
      // Navigate to PO detail
      Navigator.of(context).pop(); // Close scanner
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PODetailScreen(poId: po.id),
        ),
      );
      
      ErrorMessages.showSuccessSnackBar(
        context,
        l10n.poFound,
      );
    } else {
      // PO not found
      ErrorMessages.showErrorSnackBar(
        context,
        l10n.poNotFound,
      );
    }
  }

  void _handleManualInput(BuildContext context, String poId) {
    final poService = Provider.of<PurchaseOrderService>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    LoggingService.logUserAction('PO ID Entered Manually', details: {
      'poId': poId,
    });

    final po = poService.getPurchaseOrderById(poId);
    if (po != null) {
      Navigator.of(context).pop(); // Close scanner
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PODetailScreen(poId: po.id),
        ),
      );
      ErrorMessages.showSuccessSnackBar(context, l10n.poFound);
    } else {
      ErrorMessages.showErrorSnackBar(context, l10n.poNotFound);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (kIsWeb) {
      // Web doesn't support camera scanning, show manual input
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.scanQRCode),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(Branding.spacingXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_scanner,
                size: 100,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: Branding.spacingL),
              Text(
                l10n.webQRScannerNotSupported,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Branding.spacingM),
              Text(
                l10n.enterPOIdManually,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Branding.spacingXL),
              Builder(
                builder: (context) {
                  final controller = TextEditingController();
                  return Column(
                    children: [
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: l10n.enterPOId,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.qr_code),
                        ),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            _handleManualInput(context, value.trim());
                          }
                        },
                      ),
                      const SizedBox(height: Branding.spacingL),
                      FilledButton.icon(
                        onPressed: () {
                          if (controller.text.trim().isNotEmpty) {
                            _handleManualInput(context, controller.text.trim());
                          }
                        },
                        icon: const Icon(Icons.search),
                        label: Text(l10n.searchPO),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scanQRCode),
        elevation: 0,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _handleBarcode,
          ),
          // Overlay with instructions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(Branding.spacingL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.scanQRCodeInstructions,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Branding.spacingM),
                  Container(
                    padding: const EdgeInsets.all(Branding.spacingM),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(Branding.radiusM),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: Branding.spacingS),
                        Text(
                          l10n.pointCameraAtQRCode,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
}

