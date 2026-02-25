import 'production_stage.dart';
import 'user_role.dart';
import 'rejection_record.dart';

class PurchaseOrder {
  final String id;
  final String poNumber;
  final DateTime poDate;
  final String partNumber;
  final int totalQuantity;
  final int productionQuantity;
  final DateTime deliveryDate;
  final ProductionStage currentStatus;
  final UserRole? lastUpdatedBy;
  final DateTime? lastUpdatedAt;
  // Legacy fields for backward compatibility
  final int? rejectedQuantity;
  final String? inspectedBy;
  final String? operatorSupplierName;
  final ProductionStage? rejectedAtStage;
  
  // New field: List of all rejection records from all stages
  final List<RejectionRecord> rejectionRecords;

  PurchaseOrder({
    required this.id,
    required this.poNumber,
    required this.poDate,
    required this.partNumber,
    required this.totalQuantity,
    required this.productionQuantity,
    required this.deliveryDate,
    required this.currentStatus,
    this.lastUpdatedBy,
    this.lastUpdatedAt,
    this.rejectedQuantity,
    this.inspectedBy,
    this.operatorSupplierName,
    this.rejectedAtStage,
    List<RejectionRecord>? rejectionRecords,
  }) : rejectionRecords = rejectionRecords ?? [];

  // Getter for total rejected quantity across all stages
  int get totalRejectedQuantity {
    return rejectionRecords.fold(0, (sum, record) => sum + record.rejectedQuantity);
  }

  PurchaseOrder copyWith({
    String? id,
    String? poNumber,
    DateTime? poDate,
    String? partNumber,
    int? totalQuantity,
    int? productionQuantity,
    DateTime? deliveryDate,
    ProductionStage? currentStatus,
    UserRole? lastUpdatedBy,
    DateTime? lastUpdatedAt,
    int? rejectedQuantity,
    String? inspectedBy,
    String? operatorSupplierName,
    ProductionStage? rejectedAtStage,
    List<RejectionRecord>? rejectionRecords,
  }) {
    return PurchaseOrder(
      id: id ?? this.id,
      poNumber: poNumber ?? this.poNumber,
      poDate: poDate ?? this.poDate,
      partNumber: partNumber ?? this.partNumber,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      productionQuantity: productionQuantity ?? this.productionQuantity,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      currentStatus: currentStatus ?? this.currentStatus,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      rejectedQuantity: rejectedQuantity ?? this.rejectedQuantity,
      inspectedBy: inspectedBy ?? this.inspectedBy,
      operatorSupplierName: operatorSupplierName ?? this.operatorSupplierName,
      rejectedAtStage: rejectedAtStage ?? this.rejectedAtStage,
      rejectionRecords: rejectionRecords ?? this.rejectionRecords,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poNumber': poNumber,
      'poDate': poDate.toIso8601String(),
      'partNumber': partNumber,
      'totalQuantity': totalQuantity,
      'productionQuantity': productionQuantity,
      'deliveryDate': deliveryDate.toIso8601String(),
      'currentStatus': currentStatus.name,
      'lastUpdatedBy': lastUpdatedBy?.name,
      'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
      'rejectedQuantity': rejectedQuantity,
      'inspectedBy': inspectedBy,
      'operatorSupplierName': operatorSupplierName,
      'rejectedAtStage': rejectedAtStage?.name,
      'rejectionRecords': rejectionRecords.map((r) => r.toJson()).toList(),
    };
  }

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) {
    // Parse rejection records if they exist
    List<RejectionRecord> rejectionRecords = [];
    if (json['rejectionRecords'] != null) {
      final recordsJson = json['rejectionRecords'] as List<dynamic>;
      rejectionRecords = recordsJson
          .map((r) => RejectionRecord.fromJson(r as Map<String, dynamic>))
          .toList();
    }
    
    return PurchaseOrder(
      id: json['id'] as String,
      poNumber: json['poNumber'] as String,
      poDate: DateTime.parse(json['poDate'] as String),
      partNumber: json['partNumber'] as String,
      totalQuantity: json['totalQuantity'] as int,
      productionQuantity: json['productionQuantity'] as int,
      deliveryDate: DateTime.parse(json['deliveryDate'] as String),
      currentStatus: ProductionStage.fromString(json['currentStatus'] as String) ??
          ProductionStage.purchaseRawMaterial,
      lastUpdatedBy: json['lastUpdatedBy'] != null
          ? (json['lastUpdatedBy'] == 'masterUser' 
              ? UserRole.masterUser 
              : UserRole.normalUser)
          : null,
      lastUpdatedAt: json['lastUpdatedAt'] != null
          ? DateTime.parse(json['lastUpdatedAt'] as String)
          : null,
      rejectedQuantity: json['rejectedQuantity'] as int?,
      inspectedBy: json['inspectedBy'] as String?,
      operatorSupplierName: json['operatorSupplierName'] as String?,
      rejectedAtStage: json['rejectedAtStage'] != null
          ? ProductionStage.fromString(json['rejectedAtStage'] as String)
          : null,
      rejectionRecords: rejectionRecords,
    );
  }
}

