import 'production_stage.dart';

class DrawingReference {
  final String materialCode;
  final String pathNo;
  final Map<ProductionStage, String> stageToAssetPath;

  const DrawingReference({
    required this.materialCode,
    required this.pathNo,
    required this.stageToAssetPath,
  });

  String key() => '${materialCode.trim().toUpperCase()}|${pathNo.trim()}';
}

