import '../models/drawing_reference.dart';
import '../models/production_stage.dart';

class DrawingReferenceService {
  static final List<DrawingReference> references = [
    const DrawingReference(
      materialCode: 'SS1234',
      pathNo: '12345',
      stageToAssetPath: {
        ProductionStage.turning: 'assets/images/SF_Bush_ISO_INCH_Turning.png',
        ProductionStage.milling: 'assets/images/SF_config_bush_Milling.png',
        ProductionStage.roughHoning: 'assets/images/SF_config_bush_Milling.png',
      },
    ),
  ];

  static final Map<String, DrawingReference> _byKey = {
    for (final r in references) r.key(): r,
  };

  static DrawingReference? find({
    required String materialCode,
    required String pathNo,
  }) {
    final key = '${materialCode.trim().toUpperCase()}|${pathNo.trim()}';
    return _byKey[key];
  }

  static DrawingReference? findByEither({
    required String materialCodeOrEmpty,
    required String pathNoOrEmpty,
  }) {
    final material = materialCodeOrEmpty.trim().toUpperCase();
    final path = pathNoOrEmpty.trim();

    if (material.isEmpty && path.isEmpty) return null;

    for (final r in references) {
      if (material.isNotEmpty && r.materialCode.trim().toUpperCase() == material) {
        return r;
      }
      if (path.isNotEmpty && r.pathNo.trim() == path) {
        return r;
      }
    }
    return null;
  }
}

