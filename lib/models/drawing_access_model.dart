class DrawingAccessEntry {
  final String poNumber;
  final String pathNo;
  final String partSeries;
  final String description;

  const DrawingAccessEntry({
    required this.poNumber,
    required this.pathNo,
    required this.partSeries,
    required this.description,
  });
}

class DrawingAccessRepository {
  static const List<DrawingAccessEntry> _list = [
    DrawingAccessEntry(
      poNumber: '12345',
      pathNo: '12345',
      partSeries: 'SF48-X',
      description: 'Special Slip Fit Bushing',
    ),
    DrawingAccessEntry(
      poNumber: '2345678',
      pathNo: '2345678',
      partSeries: 'SF120-X',
      description: 'Special Slip Fit Bushing',
    ),
    DrawingAccessEntry(
      poNumber: '12346',
      pathNo: '12346',
      partSeries: 'SF64-X',
      description: 'Special Slip Fit Bushing',
    ),
    DrawingAccessEntry(
      poNumber: '12347',
      pathNo: '12347',
      partSeries: 'SF32-X',
      description: 'Special Slip Fit Bushing',
    ),
    DrawingAccessEntry(
      poNumber: '12348',
      pathNo: '12348',
      partSeries: 'SF80-X',
      description: 'Special Slip Fit Bushing',
    ),
    DrawingAccessEntry(
      poNumber: '12349',
      pathNo: '12349',
      partSeries: 'SF96-X',
      description: 'Special Slip Fit Bushing',
    ),
    DrawingAccessEntry(
      poNumber: '23456',
      pathNo: '23456',
      partSeries: 'SF112-X',
      description: 'Special Slip Fit Bushing',
    ),
    DrawingAccessEntry(
      poNumber: '34567',
      pathNo: '34567',
      partSeries: 'SF160-X',
      description: 'Special Slip Fit Bushing',
    ),
  ];

  static DrawingAccessEntry? findMatch(String poOrPathNumber) {
    final query = poOrPathNumber.trim();
    try {
      return _list.firstWhere(
        (e) => e.poNumber.trim() == query || e.pathNo.trim() == query,
      );
    } catch (_) {
      return null;
    }
  }

  static List<DrawingAccessEntry> getAll() => List.unmodifiable(_list);
}

