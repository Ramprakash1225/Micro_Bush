import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../l10n/app_localizations.dart';
import '../models/purchase_order.dart';
import '../models/production_stage.dart';
import '../models/user_role.dart';
import '../models/rejection_record.dart';
import '../services/purchase_order_service.dart';
import '../services/user_service.dart';
import '../services/logging_service.dart';
import '../utils/error_messages.dart';
import '../widgets/qr_code_dialog.dart';
import '../widgets/logo_watermark.dart';

class PODetailScreen extends StatelessWidget {
  final String poId;

  const PODetailScreen({super.key, required this.poId});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PurchaseOrderService, UserService>(
      builder: (context, poService, userService, _) {
        final theme = Theme.of(context);
        final l10n = AppLocalizations.of(context)!;
        final po = poService.getPurchaseOrderById(poId);

        if (po == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.poDetails)),
            body: Stack(
              children: [
                const LogoWatermark(),
                Center(child: Text(l10n.notFoundError)),
              ],
            ),
          );
        }

        final dateFormat = DateFormat('yyyy-MM-dd');
        final isMasterUser = userService.isMasterUser;

        return Scaffold(
          appBar: AppBar(
            title: Text('PO: ${po.poNumber}'),
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.qr_code),
                tooltip: l10n.viewQRCode,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => QRCodeDialog(purchaseOrder: po),
                  );
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              const LogoWatermark(),
              SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // PO Information Card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.poInformation,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildDetailRow(
                          context,
                          l10n.poNumber,
                          po.poNumber,
                          Icons.receipt_long,
                        ),
                        const Divider(),
                        _buildDetailRow(
                          context,
                          l10n.poDate,
                          dateFormat.format(po.poDate),
                          Icons.calendar_today,
                        ),
                        const Divider(),
                        _buildDetailRow(
                          context,
                          l10n.partNumber,
                          po.partNumber,
                          Icons.inventory_2,
                        ),
                        const Divider(),
                        _buildDetailRow(
                          context,
                          l10n.totalQuantity,
                          po.totalQuantity.toString(),
                          Icons.numbers,
                        ),
                        const Divider(),
                        _buildDetailRow(
                          context,
                          l10n.productionQuantity,
                          po.productionQuantity.toString(),
                          Icons.production_quantity_limits,
                        ),
                        const Divider(),
                        _buildDetailRow(
                          context,
                          l10n.deliveryDate,
                          dateFormat.format(po.deliveryDate),
                          Icons.event,
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Icon(
                              Icons.track_changes,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.currentStatus,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(
                                        po.currentStatus,
                                      ).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _getStatusColor(
                                          po.currentStatus,
                                        ),
                                        width: 2,
                                      ),
                                    ),
                                    child: Text(
                                      po.currentStatus.displayName,
                                      style: TextStyle(
                                        color: _getStatusColor(
                                          po.currentStatus,
                                        ),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Status Update Section
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.update,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.updateStatus,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isMasterUser
                              ? l10n.canUpdateAnyStage
                              : l10n.enterQuantities,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (isMasterUser)
                          _buildMasterUserStatusButtons(context, po)
                        else
                          _buildNormalUserStatusButton(context, po),
                        // Show notification for normal users if admin updated the status
                        // Only show if last update was by admin AND current user is normal user
                        if (!isMasterUser &&
                            po.lastUpdatedBy == UserRole.masterUser &&
                            po.lastUpdatedAt != null)
                          _buildAdminUpdateNotification(context, po),
                        // Display Total Buffer and Rejected Quantity
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.outline.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.quantitySummary,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildQuantityInfoCard(
                                      context,
                                      l10n.totalBuffer,
                                      (po.productionQuantity - po.totalQuantity)
                                          .toString(),
                                      Icons.inventory,
                                      theme.colorScheme.primaryContainer,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildQuantityInfoCard(
                                      context,
                                      l10n.rejectedQuantity,
                                      po.totalRejectedQuantity.toString(),
                                      Icons.cancel,
                                      theme.colorScheme.errorContainer,
                                    ),
                                  ),
                                ],
                              ),
                              // Show rejection details if rejection records exist
                              if (po.rejectionRecords.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.errorContainer
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: theme.colorScheme.error.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.rejectionDetails,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.error,
                                            ),
                                      ),
                                      const SizedBox(height: 12),
                                      // Display all rejection records line by line
                                      ...po.rejectionRecords
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                            final index = entry.key;
                                            final record = entry.value;
                                            final totalRecords =
                                                po.rejectionRecords.length;
                                            return _buildRejectionRecordCard(
                                              context,
                                              record,
                                              index + 1,
                                              totalRecords,
                                              theme,
                                              l10n,
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Production Stages Timeline
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.productionStages,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...ProductionStage.values.map((stage) {
                          final isCompleted = _isStageCompleted(
                            po.currentStatus,
                            stage,
                          );
                          final isCurrent = po.currentStatus == stage;
                          return _buildStageTimelineItem(
                            context,
                            stage,
                            isCompleted,
                            isCurrent,
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
        );
      },
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityInfoCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color backgroundColor,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: backgroundColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.onSurface),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterUserStatusButtons(BuildContext context, PurchaseOrder po) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final poService = Provider.of<PurchaseOrderService>(context, listen: false);

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: ProductionStage.values.map((stage) {
        final isCurrent = po.currentStatus == stage;
        return FilterChip(
          selected: isCurrent,
          label: Text(stage.displayName),
          onSelected: isCurrent
              ? null
              : (selected) {
                  try {
                    final userService = Provider.of<UserService>(
                      context,
                      listen: false,
                    );
                    poService.updatePurchaseOrderStatus(
                      po.id,
                      stage,
                      updatedBy: userService.currentUser?.role,
                    );
                    LoggingService.logUserAction(
                      'Status Updated',
                      details: {
                        'poId': po.id,
                        'poNumber': po.poNumber,
                        'oldStatus': po.currentStatus.name,
                        'newStatus': stage.name,
                      },
                    );
                    ErrorMessages.showSuccessSnackBar(
                      context,
                      l10n.statusUpdated(stage.displayName),
                    );
                  } catch (e, stackTrace) {
                    LoggingService.error(
                      'Error updating status',
                      e,
                      stackTrace,
                    );
                    ErrorMessages.showErrorSnackBar(
                      context,
                      ErrorMessages.getErrorMessage(context, e),
                    );
                  }
                },
          selectedColor: theme.colorScheme.primaryContainer,
          checkmarkColor: theme.colorScheme.onPrimaryContainer,
        );
      }).toList(),
    );
  }

  Widget _buildNormalUserStatusButton(BuildContext context, PurchaseOrder po) {
    return _NormalUserQuantityInput(po: po);
  }

  Widget _buildAdminUpdateNotification(BuildContext context, PurchaseOrder po) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.adminChangedStatusTo(po.currentStatus.displayName),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (po.lastUpdatedAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    dateFormat.format(po.lastUpdatedAt!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageTimelineItem(
    BuildContext context,
    ProductionStage stage,
    bool isCompleted,
    bool isCurrent,
  ) {
    final theme = Theme.of(context);
    final color = isCompleted
        ? Colors.green
        : isCurrent
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(color: color, width: 2),
            ),
            child: isCompleted
                ? Icon(Icons.check, size: 16, color: Colors.white)
                : isCurrent
                ? Icon(
                    Icons.radio_button_checked,
                    size: 16,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              stage.displayName,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isCompleted || isCurrent
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isStageCompleted(ProductionStage current, ProductionStage stage) {
    final stages = ProductionStage.values;
    final currentIndex = stages.indexOf(current);
    final stageIndex = stages.indexOf(stage);
    return stageIndex < currentIndex;
  }

  Color _getStatusColor(ProductionStage stage) {
    switch (stage) {
      case ProductionStage.purchaseRawMaterial:
        return Colors.blue;
      case ProductionStage.turning:
      case ProductionStage.milling:
      case ProductionStage.roughHoning:
        return Colors.orange;
      case ProductionStage.hardening:
      case ProductionStage.blackening:
        return Colors.purple;
      case ProductionStage.finishHoning:
      case ProductionStage.odGrinding:
        return Colors.teal;
      case ProductionStage.finalInspection:
        return Colors.amber;
      case ProductionStage.packingAndDispatching:
        return Colors.green;
    }
  }

  Widget _buildRejectionDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.error),
        const SizedBox(width: 8),
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
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRejectionRecordCard(
    BuildContext context,
    RejectionRecord record,
    int recordNumber,
    int totalRecords,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    return Container(
      margin: EdgeInsets.only(bottom: recordNumber < totalRecords ? 12 : 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '#$recordNumber',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${l10n.rejectedAtStage}: ${record.rejectedAtStage.displayName}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildRejectionDetailRow(
            context,
            l10n.rejectedQuantity,
            '${record.rejectedQuantity}',
            Icons.cancel,
          ),
          if (record.rejectionImageBase64 != null &&
              record.rejectionImageBase64!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              l10n.rejectionImage,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                base64Decode(record.rejectionImageBase64!),
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
          ],
          if (record.movedToStage != null) ...[
            const SizedBox(height: 8),
            _buildRejectionDetailRow(
              context,
              l10n.movedTo,
              record.movedToStage!.displayName,
              Icons.arrow_forward,
            ),
          ],
          if (record.inspectedBy != null && record.inspectedBy!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildRejectionDetailRow(
              context,
              l10n.inspectedBy,
              record.inspectedBy!,
              Icons.person_search,
            ),
          ],
          if (record.operatorSupplierName != null &&
              record.operatorSupplierName!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildRejectionDetailRow(
              context,
              l10n.operatorSupplierName,
              record.operatorSupplierName!,
              Icons.badge,
            ),
          ],
          const SizedBox(height: 8),
          _buildRejectionDetailRow(
            context,
            l10n.rejectedAt,
            dateFormat.format(record.rejectedAt),
            Icons.access_time,
          ),
        ],
      ),
    );
  }
}

class _NormalUserQuantityInput extends StatefulWidget {
  final PurchaseOrder po;

  const _NormalUserQuantityInput({required this.po});

  @override
  State<_NormalUserQuantityInput> createState() =>
      _NormalUserQuantityInputState();
}

class _NormalUserQuantityInputState extends State<_NormalUserQuantityInput> {
  final _formKey = GlobalKey<FormState>();
  final _acceptQuantityController = TextEditingController();
  final _rejectedQuantityController = TextEditingController();
  final _inspectedByController = TextEditingController();
  final _operatorSupplierController = TextEditingController();
  Uint8List? _rejectionImageBytes;
  static final _imagePicker = ImagePicker();

  Future<void> _pickRejectionImage(ImageSource source) async {
    final picked = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1200,
      imageQuality: 85,
    );
    if (picked != null && mounted) {
      final bytes = await picked.readAsBytes();
      setState(() => _rejectionImageBytes = bytes);
    }
  }

  int? _getAcceptQuantity() {
    final value = _acceptQuantityController.text.trim();
    return value.isEmpty ? null : int.tryParse(value);
  }

  int? _getRejectedQuantity() {
    final value = _rejectedQuantityController.text.trim();
    return value.isEmpty ? null : int.tryParse(value);
  }

  int _calculateRemainingQuantity() {
    // Always use total rejected quantity from all stages
    final rejectedQty = widget.po.totalRejectedQuantity;
    return widget.po.productionQuantity - rejectedQty;
  }

  @override
  void dispose() {
    _acceptQuantityController.dispose();
    _rejectedQuantityController.dispose();
    _inspectedByController.dispose();
    _operatorSupplierController.dispose();
    super.dispose();
  }

  void _submitQuantities() {
    final l10n = AppLocalizations.of(context)!;

    // First validate the form - this will trigger all field validators
    if (!_formKey.currentState!.validate()) {
      // Form validation failed - show error message
      ErrorMessages.showErrorSnackBar(context, l10n.enterCorrectValues);
      return;
    }

    // Get quantities after validation passes
    final acceptQty = _getAcceptQuantity();
    final rejectedQty = _getRejectedQuantity();

    // Double-check if both are provided (should not happen if validation passed, but safety check)
    if (acceptQty == null || rejectedQty == null) {
      ErrorMessages.showErrorSnackBar(context, l10n.quantitiesRequired);
      // Re-validate to show field errors
      _formKey.currentState?.validate();
      return;
    }

    // Check if values are valid (non-negative) - should be caught by validators, but double-check
    if (acceptQty < 0 || rejectedQty < 0) {
      ErrorMessages.showErrorSnackBar(context, l10n.enterValidQuantity);
      // Re-validate to show field errors
      _formKey.currentState?.validate();
      return;
    }

    // Check if sum exceeds production quantity
    final total = acceptQty + rejectedQty;
    if (total > widget.po.productionQuantity) {
      ErrorMessages.showErrorSnackBar(context, l10n.sumExceedsProduction);
      // Re-validate both fields to show the error
      _formKey.currentState?.validate();
      return;
    }

    try {
      final poService = Provider.of<PurchaseOrderService>(
        context,
        listen: false,
      );
      final userService = Provider.of<UserService>(context, listen: false);
      final nextStage = widget.po.currentStatus.nextStage;

      if (nextStage == null) {
        ErrorMessages.showErrorSnackBar(context, l10n.orderCompleted);
        return;
      }

      // Get additional information
      final inspectedBy = _inspectedByController.text.trim();
      final operatorSupplier = _operatorSupplierController.text.trim();

      final imageBase64 = _rejectionImageBytes != null
          ? base64Encode(_rejectionImageBytes!)
          : null;

      // Update status to next stage and save rejected quantity with inspection details
      poService.updatePurchaseOrderStatus(
        widget.po.id,
        nextStage,
        updatedBy: userService.currentUser?.role,
        rejectedQuantity: rejectedQty,
        inspectedBy: inspectedBy.isNotEmpty ? inspectedBy : null,
        operatorSupplierName: operatorSupplier.isNotEmpty
            ? operatorSupplier
            : null,
        rejectedAtStage:
            widget.po.currentStatus, // Current stage when rejection happened
        rejectionImageBase64: imageBase64,
      );

      // Log the quantities
      LoggingService.logUserAction(
        'Quantities Submitted',
        details: {
          'poId': widget.po.id,
          'poNumber': widget.po.poNumber,
          'acceptQuantity': acceptQty,
          'rejectedQuantity': rejectedQty,
          'productionQuantity': widget.po.productionQuantity,
          'newStatus': nextStage.name,
        },
      );

      ErrorMessages.showSuccessSnackBar(
        context,
        '${l10n.quantitiesSubmitted} ${l10n.statusUpdated(nextStage.displayName)}',
      );

      // Clear the form
      _acceptQuantityController.clear();
      _rejectedQuantityController.clear();
      _inspectedByController.clear();
      _operatorSupplierController.clear();
      setState(() => _rejectionImageBytes = null);
    } catch (e, stackTrace) {
      LoggingService.error('Error submitting quantities', e, stackTrace);
      ErrorMessages.showErrorSnackBar(context, l10n.enterCorrectValues);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _acceptQuantityController,
            decoration: InputDecoration(
              labelText: '${l10n.acceptQuantity} *',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.check_circle),
              helperText:
                  '${l10n.remainingQuantity}: ${_calculateRemainingQuantity()}',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.pleaseEnter(l10n.acceptQuantity);
              }
              final quantity = int.tryParse(value);
              if (quantity == null) {
                return l10n.enterValidQuantity;
              }
              if (quantity < 0) {
                return l10n.enterValidQuantity;
              }
              // Check if accept quantity alone exceeds production (basic check)
              if (quantity > widget.po.productionQuantity) {
                return '${l10n.acceptQuantity} cannot exceed ${l10n.productionQuantity} (${widget.po.productionQuantity})';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _rejectedQuantityController,
            decoration: InputDecoration(
              labelText: '${l10n.rejectedQuantity} *',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.cancel),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.pleaseEnter(l10n.rejectedQuantity);
              }
              final quantity = int.tryParse(value);
              if (quantity == null) {
                return l10n.enterValidQuantity;
              }
              if (quantity < 0) {
                return l10n.enterValidQuantity;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text(
            l10n.uploadImage,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickRejectionImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: Text(l10n.pickFromGallery),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickRejectionImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: Text(l10n.takePhoto),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          if (_rejectionImageBytes != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                _rejectionImageBytes!,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 4),
            TextButton.icon(
              onPressed: () => setState(() => _rejectionImageBytes = null),
              icon: const Icon(Icons.close, size: 18),
              label: const Text('Remove image'),
            ),
          ],
          const SizedBox(height: 16),
          TextFormField(
            controller: _inspectedByController,
            decoration: InputDecoration(
              labelText: '${l10n.inspectedBy} *',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person_search),
              helperText: 'Name of person who inspected',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.pleaseEnterInspectedBy;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _operatorSupplierController,
            decoration: InputDecoration(
              labelText: '${l10n.operatorSupplierName} *',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.badge),
              helperText: 'Operator or Supplier name',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.pleaseEnterOperatorSupplier;
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _submitQuantities,
            icon: const Icon(Icons.save),
            label: Text(l10n.submitQuantities),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
