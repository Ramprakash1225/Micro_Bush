import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert' show utf8;
import '../models/purchase_order.dart';
import 'logging_service.dart';

// Conditional imports for web vs non-web
import 'dart:io' show File;
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html_web;

class ReportService {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future<String> generateCSVReport(List<PurchaseOrder> orders) async {
    try {
      LoggingService.info('Generating CSV report for ${orders.length} orders');
      final List<List<dynamic>> rows = [
        [
          'PO Number',
          'PO Date',
          'Part Number',
          'PO Quantity',
          'Production Quantity',
          'Delivery Date',
          'Current Status',
        ],
      ];

      for (var order in orders) {
        rows.add([
          order.poNumber,
          _dateFormat.format(order.poDate),
          order.partNumber,
          order.totalQuantity,
          order.productionQuantity,
          _dateFormat.format(order.deliveryDate),
          order.currentStatus.displayName,
        ]);
      }

      final csv = const ListToCsvConverter().convert(rows);
      final filename = 'po_report_${DateTime.now().millisecondsSinceEpoch}.csv';
      
      if (kIsWeb) {
        // For web, trigger browser download
        final bytes = utf8.encode(csv);
        final blob = html_web.Blob([bytes]);
        final url = html_web.Url.createObjectUrlFromBlob(blob);
        html_web.AnchorElement(href: url)
          ..setAttribute('download', filename)
          ..click();
        html_web.Url.revokeObjectUrl(url);
        LoggingService.info('CSV report downloaded successfully');
        return 'Downloaded: $filename';
      } else {
        // For mobile/desktop, save to file system
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$filename');
        await file.writeAsString(csv);
        LoggingService.info('CSV report generated successfully: ${file.path}');
        return file.path;
      }
    } catch (e, stackTrace) {
      LoggingService.error('Error generating CSV report', e, stackTrace);
      rethrow;
    }
  }

  Future<String> generatePDFReport(List<PurchaseOrder> orders) async {
    try {
      LoggingService.info('Generating PDF report for ${orders.length} orders');
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'PO Status Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Generated on: ${_dateFormat.format(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    children: [
                      _buildTableCell('PO Number', isHeader: true),
                      _buildTableCell('PO Date', isHeader: true),
                      _buildTableCell('Part Number', isHeader: true),
                      _buildTableCell('PO Qty', isHeader: true),
                      _buildTableCell('Prod Qty', isHeader: true),
                      _buildTableCell('Delivery Date', isHeader: true),
                      _buildTableCell('Current Status', isHeader: true),
                    ],
                  ),
                  ...orders.map((order) => pw.TableRow(
                        children: [
                          _buildTableCell(order.poNumber),
                          _buildTableCell(_dateFormat.format(order.poDate)),
                          _buildTableCell(order.partNumber),
                          _buildTableCell(order.totalQuantity.toString()),
                          _buildTableCell(order.productionQuantity.toString()),
                          _buildTableCell(_dateFormat.format(order.deliveryDate)),
                          _buildTableCell(order.currentStatus.displayName),
                        ],
                      )),
                ],
              ),
            ];
          },
        ),
      );

      final pdfBytes = await pdf.save();
      final filename = 'po_report_${DateTime.now().millisecondsSinceEpoch}.pdf';

      if (kIsWeb) {
        // For web, use printing package to show/share PDF
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdfBytes,
        );
        LoggingService.info('PDF report opened successfully');
        return 'PDF opened in viewer';
      } else {
        // For mobile/desktop, save to file system
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$filename');
        await file.writeAsBytes(pdfBytes);
        LoggingService.info('PDF report generated successfully: ${file.path}');
        return file.path;
      }
    } catch (e, stackTrace) {
      LoggingService.error('Error generating PDF report', e, stackTrace);
      rethrow;
    }
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 12 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}

