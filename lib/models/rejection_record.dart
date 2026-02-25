import 'production_stage.dart';

class RejectionRecord {
  final int rejectedQuantity;
  final String? inspectedBy;
  final String? operatorSupplierName;
  final ProductionStage rejectedAtStage;
  final DateTime rejectedAt;
  final ProductionStage? movedToStage; // The stage it moved to after rejection

  RejectionRecord({
    required this.rejectedQuantity,
    this.inspectedBy,
    this.operatorSupplierName,
    required this.rejectedAtStage,
    required this.rejectedAt,
    this.movedToStage,
  });

  RejectionRecord copyWith({
    int? rejectedQuantity,
    String? inspectedBy,
    String? operatorSupplierName,
    ProductionStage? rejectedAtStage,
    DateTime? rejectedAt,
    ProductionStage? movedToStage,
  }) {
    return RejectionRecord(
      rejectedQuantity: rejectedQuantity ?? this.rejectedQuantity,
      inspectedBy: inspectedBy ?? this.inspectedBy,
      operatorSupplierName: operatorSupplierName ?? this.operatorSupplierName,
      rejectedAtStage: rejectedAtStage ?? this.rejectedAtStage,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      movedToStage: movedToStage ?? this.movedToStage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rejectedQuantity': rejectedQuantity,
      'inspectedBy': inspectedBy,
      'operatorSupplierName': operatorSupplierName,
      'rejectedAtStage': rejectedAtStage.name,
      'rejectedAt': rejectedAt.toIso8601String(),
      'movedToStage': movedToStage?.name,
    };
  }

  factory RejectionRecord.fromJson(Map<String, dynamic> json) {
    return RejectionRecord(
      rejectedQuantity: json['rejectedQuantity'] as int,
      inspectedBy: json['inspectedBy'] as String?,
      operatorSupplierName: json['operatorSupplierName'] as String?,
      rejectedAtStage: ProductionStage.fromString(
            json['rejectedAtStage'] as String,
          ) ??
          ProductionStage.purchaseRawMaterial,
      rejectedAt: DateTime.parse(json['rejectedAt'] as String),
      movedToStage: json['movedToStage'] != null
          ? ProductionStage.fromString(json['movedToStage'] as String)
          : null,
    );
  }
}

