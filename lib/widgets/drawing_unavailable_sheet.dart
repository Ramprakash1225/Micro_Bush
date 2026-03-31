import 'package:flutter/material.dart';

class DrawingUnavailableSheet extends StatelessWidget {
  final String stageName;
  final String poNumber;

  const DrawingUnavailableSheet({
    super.key,
    required this.stageName,
    required this.poNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF050D1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFF6B35).withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withValues(alpha: 0.2),
            blurRadius: 20,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFF6B35), width: 1.5),
              color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
            ),
            child: const Icon(
              Icons.image_not_supported_outlined,
              color: Color(0xFFFF6B35),
              size: 26,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'DRAWING UNAVAILABLE',
            style: TextStyle(
              fontFamily: 'monospace',
              color: Color(0xFFFF6B35),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No technical drawing is authorized for this combination.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: [
                _InfoRow(label: 'PO / PATH NO', value: poNumber),
                _InfoRow(label: 'OPERATION', value: stageName.toUpperCase()),
                const _InfoRow(
                  label: 'STATUS',
                  value: 'NOT IN AUTHORIZED LIST',
                  valueColor: Color(0xFFFF6B35),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
                ),
                foregroundColor: const Color(0xFF00E5FF),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'CLOSE',
                style: TextStyle(
                  fontFamily: 'monospace',
                  letterSpacing: 3,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'monospace',
              color: Color(0x9900E5FF),
              fontSize: 10,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

