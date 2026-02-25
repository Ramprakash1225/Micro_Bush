enum ProductionStage {
  purchaseRawMaterial,
  turning,
  milling,
  roughHoning,
  hardening,
  blackening,
  finishHoning,
  odGrinding,
  finalInspection,
  packingAndDispatching;

  String get displayName {
    switch (this) {
      case ProductionStage.purchaseRawMaterial:
        return 'Purchase Raw Material';
      case ProductionStage.turning:
        return 'Turning';
      case ProductionStage.milling:
        return 'Milling';
      case ProductionStage.roughHoning:
        return 'Rough Honing';
      case ProductionStage.hardening:
        return 'Hardening';
      case ProductionStage.blackening:
        return 'Blackening';
      case ProductionStage.finishHoning:
        return 'Finish Honing';
      case ProductionStage.odGrinding:
        return 'OD Grinding';
      case ProductionStage.finalInspection:
        return 'Final Inspection';
      case ProductionStage.packingAndDispatching:
        return 'Packing & Dispatching';
    }
  }

  ProductionStage? get nextStage {
    final stages = ProductionStage.values;
    final currentIndex = stages.indexOf(this);
    if (currentIndex < stages.length - 1) {
      return stages[currentIndex + 1];
    }
    return null;
  }

  static ProductionStage? fromString(String value) {
    try {
      return ProductionStage.values.firstWhere(
        (stage) => stage.name == value,
      );
    } catch (e) {
      return null;
    }
  }
}

