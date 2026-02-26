import '../services/purchase_order_service.dart';
import '../services/logging_service.dart';

class SampleDataService {
  static void initializeSampleData(PurchaseOrderService poService) {
    try {
      LoggingService.info('Initializing sample data');

      final samplePOs = [
        // PurchaseOrder(
        //   id: _uuid.v4(),
        //   poNumber: 'PO-2024-001',
        //   poDate: now.subtract(const Duration(days: 15)),
        //   partNumber: 'PART-ABC-123',
        //   totalQuantity: 1000,
        //   productionQuantity: 1200,
        //   deliveryDate: now.add(const Duration(days: 15)),
        //   currentStatus: ProductionStage.turning,
        // ),
        // PurchaseOrder(
        //   id: _uuid.v4(),
        //   poNumber: 'PO-2024-002',
        //   poDate: now.subtract(const Duration(days: 10)),
        //   partNumber: 'PART-XYZ-456',
        //   totalQuantity: 500,
        //   productionQuantity: 650,
        //   deliveryDate: now.add(const Duration(days: 20)),
        //   currentStatus: ProductionStage.milling,
        // ),
        // PurchaseOrder(
        //   id: _uuid.v4(),
        //   poNumber: 'PO-2024-003',
        //   poDate: now.subtract(const Duration(days: 5)),
        //   partNumber: 'PART-DEF-789',
        //   totalQuantity: 2000,
        //   productionQuantity: 2500,
        //   deliveryDate: now.add(const Duration(days: 25)),
        //   currentStatus: ProductionStage.roughHoning,
        // ),
        // PurchaseOrder(
        //   id: _uuid.v4(),
        //   poNumber: 'PO-2024-004',
        //   poDate: now.subtract(const Duration(days: 20)),
        //   partNumber: 'PART-GHI-012',
        //   totalQuantity: 800,
        //   productionQuantity: 950,
        //   deliveryDate: now.add(const Duration(days: 10)),
        //   currentStatus: ProductionStage.hardening,
        // ),
        // PurchaseOrder(
        //   id: _uuid.v4(),
        //   poNumber: 'PO-2024-005',
        //   poDate: now.subtract(const Duration(days: 3)),
        //   partNumber: 'PART-JKL-345',
        //   totalQuantity: 1500,
        //   productionQuantity: 1800,
        //   deliveryDate: now.add(const Duration(days: 30)),
        //   currentStatus: ProductionStage.purchaseRawMaterial,
        // ),
        // PurchaseOrder(
        //   id: _uuid.v4(),
        //   poNumber: 'PO-2024-006',
        //   poDate: now.subtract(const Duration(days: 12)),
        //   partNumber: 'PART-MNO-678',
        //   totalQuantity: 600,
        //   productionQuantity: 750,
        //   deliveryDate: now.add(const Duration(days: 18)),
        //   currentStatus: ProductionStage.blackening,
        // ),
        // PurchaseOrder(
        //   id: _uuid.v4(),
        //   poNumber: 'PO-2024-007',
        //   poDate: now.subtract(const Duration(days: 8)),
        //   partNumber: 'PART-PQR-901',
        //   totalQuantity: 1200,
        //   productionQuantity: 1400,
        //   deliveryDate: now.add(const Duration(days: 22)),
        //   currentStatus: ProductionStage.finishHoning,
        // ),
        // PurchaseOrder(
        //   id: _uuid.v4(),
        //   poNumber: 'PO-2024-008',
        //   poDate: now.subtract(const Duration(days: 25)),
        //   partNumber: 'PART-STU-234',
        //   totalQuantity: 300,
        //   productionQuantity: 400,
        //   deliveryDate: now.add(const Duration(days: 5)),
        //   currentStatus: ProductionStage.odGrinding,
        // ),
        // PurchaseOrder(
        //   id: _uuid.v4(),
        //   poNumber: 'PO-2024-009',
        //   poDate: now.subtract(const Duration(days: 18)),
        //   partNumber: 'PART-VWX-567',
        //   totalQuantity: 900,
        //   productionQuantity: 1100,
        //   deliveryDate: now.add(const Duration(days: 12)),
        //   currentStatus: ProductionStage.finalInspection,
        // ),
        // PurchaseOrder(
        //   id: _uuid.v4(),
        //   poNumber: 'PO-2024-010',
        //   poDate: now.subtract(const Duration(days: 30)),
        //   partNumber: 'PART-YZA-890',
        //   totalQuantity: 400,
        //   productionQuantity: 500,
        //   deliveryDate: now.subtract(const Duration(days: 2)),
        //   currentStatus: ProductionStage.packingAndDispatching,
        // ),
      ];

      for (final po in samplePOs) {
        poService.addPurchaseOrder(po);
      }

      LoggingService.info('Sample data initialized successfully', {
        'count': samplePOs.length,
      });
    } catch (e, stackTrace) {
      LoggingService.error('Error initializing sample data', e, stackTrace);
    }
  }
}
