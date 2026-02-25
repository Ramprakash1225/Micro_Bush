import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/purchase_order.dart';
import '../models/production_stage.dart';

class POCard extends StatelessWidget {
  final PurchaseOrder purchaseOrder;
  final VoidCallback onTap;

  const POCard({
    super.key,
    required this.purchaseOrder,
    required this.onTap,
  });

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy-MM-dd');
    final statusColor = _getStatusColor(purchaseOrder.currentStatus);

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          purchaseOrder.poNumber,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          purchaseOrder.partNumber,
                          style: theme.textTheme.bodyMedium?.copyWith(
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
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: statusColor,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      purchaseOrder.currentStatus.displayName,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      Icons.calendar_today,
                      'PO Date',
                      dateFormat.format(purchaseOrder.poDate),
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      Icons.event,
                      'Delivery',
                      dateFormat.format(purchaseOrder.deliveryDate),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      Icons.inventory_2,
                      'PO Qty',
                      purchaseOrder.totalQuantity.toString(),
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      Icons.production_quantity_limits,
                      'Prod Qty',
                      purchaseOrder.productionQuantity.toString(),
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

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
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
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

