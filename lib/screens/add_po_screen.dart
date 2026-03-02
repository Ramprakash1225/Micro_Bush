import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/purchase_order.dart';
import '../models/production_stage.dart';
import '../services/purchase_order_service.dart';
import '../services/logging_service.dart';
import '../utils/error_messages.dart';
import '../utils/security_utils.dart';
import '../constants/branding.dart';
import '../widgets/qr_code_dialog.dart';
import '../widgets/logo_watermark.dart';

class AddPOScreen extends StatefulWidget {
  const AddPOScreen({super.key});

  @override
  State<AddPOScreen> createState() => _AddPOScreenState();
}

class _AddPOScreenState extends State<AddPOScreen> {
  final _formKey = GlobalKey<FormState>();
  final _poNumberController = TextEditingController();
  final _partNumberController = TextEditingController();
  final _totalQuantityController = TextEditingController();
  final _productionQuantityController = TextEditingController();
  
  DateTime _poDate = DateTime.now();
  DateTime _deliveryDate = DateTime.now().add(const Duration(days: 30));

  Future<void> _selectDate(
    BuildContext context,
    bool isPODate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isPODate ? _poDate : _deliveryDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != (isPODate ? _poDate : _deliveryDate)) {
      setState(() {
        if (isPODate) {
          _poDate = picked;
        } else {
          _deliveryDate = picked;
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      try {
        final poService = Provider.of<PurchaseOrderService>(context, listen: false);
        final l10n = AppLocalizations.of(context)!;
        
        // Security validation
        final poNumber = SecurityUtils.sanitizeInput(_poNumberController.text.trim());
        // Part number should not be sanitized to allow all characters
        final partNumber = _partNumberController.text.trim();
        
        if (!SecurityUtils.isValidPONumber(poNumber)) {
          ErrorMessages.showErrorSnackBar(context, l10n.validationError);
          return;
        }
        
        if (!SecurityUtils.isValidPartNumber(partNumber)) {
          ErrorMessages.showErrorSnackBar(context, l10n.validationError);
          return;
        }
        
        final totalQty = int.parse(_totalQuantityController.text);
        final prodQty = int.parse(_productionQuantityController.text);
        
        if (!SecurityUtils.isValidQuantity(totalQty) || 
            !SecurityUtils.isValidProductionQuantity(prodQty, totalQty)) {
          ErrorMessages.showErrorSnackBar(context, l10n.validationError);
          return;
        }
        
        if (!SecurityUtils.isValidDateRange(_poDate, _deliveryDate)) {
          ErrorMessages.showErrorSnackBar(context, l10n.validationError);
          return;
        }
        
        final newPO = PurchaseOrder(
          id: SecurityUtils.generateSecureId(),
          poNumber: poNumber,
          poDate: _poDate,
          partNumber: partNumber,
          totalQuantity: totalQty,
          productionQuantity: prodQty,
          deliveryDate: _deliveryDate,
          currentStatus: ProductionStage.purchaseRawMaterial,
        );

        poService.addPurchaseOrder(newPO);
        LoggingService.logUserAction('Purchase Order Added', details: {
          'poNumber': poNumber,
          'partNumber': partNumber,
        });
        
        ErrorMessages.showSuccessSnackBar(context, l10n.poAddedSuccess);
        
        // Show QR code dialog
        if (mounted) {
          Navigator.of(context).pop(); // Close add form
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              showDialog(
                context: context,
                builder: (context) => QRCodeDialog(
                  purchaseOrder: newPO,
                ),
              );
            }
          });
        }
      } catch (e, stackTrace) {
        LoggingService.error('Error adding Purchase Order', e, stackTrace);
        ErrorMessages.showErrorSnackBar(
          context,
          ErrorMessages.getErrorMessage(context, e),
        );
      }
    }
  }

  @override
  void dispose() {
    _poNumberController.dispose();
    _partNumberController.dispose();
    _totalQuantityController.dispose();
    _productionQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addPurchaseOrder),
        elevation: 0,
      ),
      body: Stack(
        children: [
          const LogoWatermark(),
          SingleChildScrollView(
            padding: const EdgeInsets.all(Branding.spacingL),
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(Branding.spacingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.poDetails,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: Branding.spacingL),
                      TextFormField(
                        controller: _poNumberController,
                        decoration: InputDecoration(
                          labelText: '${l10n.poNumber} *',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.receipt_long),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.pleaseEnter(l10n.poNumber);
                          }
                          if (!SecurityUtils.isValidPONumber(value.trim())) {
                            return l10n.validationError;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Branding.spacingM),
                      InkWell(
                        onTap: () => _selectDate(context, true),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: '${l10n.poDate} *',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            dateFormat.format(_poDate),
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      const SizedBox(height: Branding.spacingM),
                      TextFormField(
                        controller: _partNumberController,
                        decoration: InputDecoration(
                          labelText: '${l10n.partNumber} *',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.inventory_2),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.pleaseEnter(l10n.partNumber);
                          }
                          // Allow all characters, only check length
                          if (value.trim().length > 100) {
                            return l10n.validationError;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Branding.spacingM),
                      TextFormField(
                        controller: _totalQuantityController,
                        decoration: InputDecoration(
                          labelText: '${l10n.totalQuantity} *',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.numbers),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.pleaseEnter(l10n.totalQuantity);
                          }
                          final quantity = int.tryParse(value);
                          if (quantity == null || !SecurityUtils.isValidQuantity(quantity)) {
                            return l10n.enterValidQuantity;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Branding.spacingM),
                      TextFormField(
                        controller: _productionQuantityController,
                        decoration: InputDecoration(
                          labelText: '${l10n.productionQuantity} *',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.production_quantity_limits),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.pleaseEnter(l10n.productionQuantity);
                          }
                          final quantity = int.tryParse(value);
                          if (quantity == null || quantity <= 0) {
                            return l10n.enterValidQuantity;
                          }
                          final totalQty = int.tryParse(_totalQuantityController.text);
                          if (totalQty != null && quantity <= totalQty) {
                            return l10n.productionQtyExceeds;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Branding.spacingM),
                      InkWell(
                        onTap: () => _selectDate(context, false),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: '${l10n.deliveryDate} *',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.event),
                          ),
                          child: Text(
                            dateFormat.format(_deliveryDate),
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      const SizedBox(height: Branding.spacingXL),
                      FilledButton.icon(
                        onPressed: _submitForm,
                        icon: const Icon(Icons.add),
                        label: Text(l10n.addPurchaseOrder),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ],
    ),
    );
  }
}
