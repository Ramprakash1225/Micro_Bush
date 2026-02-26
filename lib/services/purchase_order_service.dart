import 'package:flutter/foundation.dart';
import '../models/purchase_order.dart';
import '../models/production_stage.dart';
import '../models/user_role.dart';
import '../models/rejection_record.dart';
import 'logging_service.dart';

class PurchaseOrderService extends ChangeNotifier {
  final List<PurchaseOrder> _purchaseOrders = [];

  List<PurchaseOrder> get purchaseOrders => List.unmodifiable(_purchaseOrders);

  void addPurchaseOrder(PurchaseOrder po) {
    try {
      _purchaseOrders.add(po);
      LoggingService.info('Purchase Order added: ${po.poNumber}');
      notifyListeners();
    } catch (e, stackTrace) {
      LoggingService.error('Error adding Purchase Order', e, stackTrace);
      rethrow;
    }
  }

  void updatePurchaseOrderStatus(
    String id,
    ProductionStage newStatus, {
    UserRole? updatedBy,
    int? rejectedQuantity,
    String? inspectedBy,
    String? operatorSupplierName,
    ProductionStage? rejectedAtStage,
    String? rejectionImageBase64,
  }) {
    try {
      final index = _purchaseOrders.indexWhere((po) => po.id == id);
      if (index != -1) {
        final oldStatus = _purchaseOrders[index].currentStatus;
        final currentPO = _purchaseOrders[index];
        
        // Create a new rejection record if rejected quantity is provided
        List<RejectionRecord> updatedRejectionRecords = List.from(currentPO.rejectionRecords);
        if (rejectedQuantity != null && rejectedQuantity > 0 && rejectedAtStage != null) {
          final rejectionRecord = RejectionRecord(
            rejectedQuantity: rejectedQuantity,
            inspectedBy: inspectedBy,
            operatorSupplierName: operatorSupplierName,
            rejectedAtStage: rejectedAtStage,
            rejectedAt: DateTime.now(),
            movedToStage: newStatus,
            rejectionImageBase64: rejectionImageBase64,
          );
          updatedRejectionRecords.add(rejectionRecord);
        }
        
        _purchaseOrders[index] = currentPO.copyWith(
          currentStatus: newStatus,
          lastUpdatedBy: updatedBy,
          lastUpdatedAt: DateTime.now(),
          // Keep legacy fields for backward compatibility
          rejectedQuantity: rejectedQuantity,
          inspectedBy: inspectedBy,
          operatorSupplierName: operatorSupplierName,
          rejectedAtStage: rejectedAtStage,
          // Update rejection records list
          rejectionRecords: updatedRejectionRecords,
        );
        LoggingService.info(
          'Purchase Order status updated: ${_purchaseOrders[index].poNumber} from ${oldStatus.displayName} to ${newStatus.displayName}',
        );
        notifyListeners();
      } else {
        LoggingService.warning('Purchase Order not found for status update: $id');
      }
    } catch (e, stackTrace) {
      LoggingService.error('Error updating Purchase Order status', e, stackTrace);
      rethrow;
    }
  }

  PurchaseOrder? getPurchaseOrderById(String id) {
    try {
      // First try to find by ID (UUID)
      try {
        return _purchaseOrders.firstWhere((po) => po.id == id);
      } catch (e) {
        // If not found by ID, try to find by PO number
        return _purchaseOrders.firstWhere((po) => po.poNumber == id);
      }
    } catch (e) {
      LoggingService.warning('Purchase Order not found: $id');
      return null;
    }
  }

  void deletePurchaseOrder(String id) {
    try {
      final po = getPurchaseOrderById(id);
      _purchaseOrders.removeWhere((po) => po.id == id);
      LoggingService.info('Purchase Order deleted: ${po?.poNumber ?? id}');
      notifyListeners();
    } catch (e, stackTrace) {
      LoggingService.error('Error deleting Purchase Order', e, stackTrace);
      rethrow;
    }
  }
}

