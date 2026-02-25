import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/purchase_order_service.dart';
import '../services/user_service.dart';
import '../services/report_service.dart';
import '../utils/error_messages.dart';
import '../constants/branding.dart';
import 'add_po_screen.dart';
import 'po_detail_screen.dart';
import 'qr_scanner_screen.dart';
import '../widgets/po_card.dart';
import '../widgets/language_toggle.dart';

class POListScreen extends StatelessWidget {
  const POListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final poService = Provider.of<PurchaseOrderService>(context);
    final userService = Provider.of<UserService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Logo placeholder - replace with actual logo when available
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.precision_manufacturing, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.purchaseOrders,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          const LanguageToggle(),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: l10n.scanQRCode,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QRScannerScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.logout,
            onPressed: () {
              final userService = Provider.of<UserService>(
                context,
                listen: false,
              );
              userService.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: l10n.downloadReport,
            onPressed: () => _showReportDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(Branding.spacingM),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              boxShadow: Branding.cardShadow,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.welcome}, ${userService.currentUser?.name ?? 'User'}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l10n.role}: ${userService.currentUser?.role.displayName ?? 'N/A'}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.totalPOs,
                        style: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${poService.purchaseOrders.length}',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: poService.purchaseOrders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: Branding.spacingM),
                        Text(
                          l10n.noPurchaseOrders,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: Branding.spacingS),
                        Text(
                          l10n.addFirstPO,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(Branding.spacingM),
                    itemCount: poService.purchaseOrders.length,
                    itemBuilder: (context, index) {
                      final po = poService.purchaseOrders[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: POCard(
                          purchaseOrder: po,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PODetailScreen(poId: po.id),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: userService.isMasterUser
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddPOScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.addPO),
            )
          : null,
    );
  }

  void _showReportDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.downloadReport),
        content: Text(l10n.chooseReportFormat),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _generateReport(context, 'csv');
            },
            icon: const Icon(Icons.table_chart),
            label: const Text('CSV'),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _generateReport(context, 'pdf');
            },
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('PDF'),
          ),
        ],
      ),
    );
  }

  void _generateReport(BuildContext context, String format) async {
    final l10n = AppLocalizations.of(context)!;
    final poService = Provider.of<PurchaseOrderService>(context, listen: false);
    final reportService = ReportService();

    if (poService.purchaseOrders.isEmpty) {
      ErrorMessages.showErrorSnackBar(context, l10n.noPOsForReport);
      return;
    }

    try {
      ErrorMessages.showInfoSnackBar(context, l10n.generatingReport);

      final filePath = format == 'csv'
          ? await reportService.generateCSVReport(poService.purchaseOrders)
          : await reportService.generatePDFReport(poService.purchaseOrders);

      if (context.mounted) {
        ErrorMessages.showSuccessSnackBar(context, l10n.reportSaved(filePath));
      }
    } catch (e) {
      if (context.mounted) {
        ErrorMessages.showErrorSnackBar(context, l10n.errorGeneratingReport);
      }
    }
  }
}
