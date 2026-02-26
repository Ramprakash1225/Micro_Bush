// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Lite Manufacturing MES';

  @override
  String get purchaseOrders => 'Purchase Orders';

  @override
  String get addPurchaseOrder => 'Add Purchase Order';

  @override
  String get poNumber => 'PO Number';

  @override
  String get poDate => 'PO Date';

  @override
  String get partNumber => 'Part Number';

  @override
  String get totalQuantity => 'PO Quantity';

  @override
  String get productionQuantity => 'Production Quantity';

  @override
  String get deliveryDate => 'Delivery Date';

  @override
  String get currentStatus => 'Current Status';

  @override
  String get updateStatus => 'Update Status';

  @override
  String get productionStages => 'Production Stages';

  @override
  String get downloadReport => 'Download Report';

  @override
  String get welcome => 'Welcome';

  @override
  String get role => 'Role';

  @override
  String get totalPOs => 'Total POs';

  @override
  String get addPO => 'Add PO';

  @override
  String get noPurchaseOrders => 'No Purchase Orders';

  @override
  String get addFirstPO => 'Add your first purchase order to get started';

  @override
  String get poDetails => 'Purchase Order Details';

  @override
  String get poInformation => 'Purchase Order Information';

  @override
  String get canUpdateAnyStage => 'You can update to any production stage';

  @override
  String get canOnlyMoveNext => 'You can only move to the next stage';

  @override
  String get orderCompleted => 'Order completed! All stages finished.';

  @override
  String moveTo(String stage) {
    return 'Move to $stage';
  }

  @override
  String get chooseReportFormat => 'Choose report format:';

  @override
  String get generatingReport => 'Generating report...';

  @override
  String reportSaved(String path) {
    return 'Report saved to: $path';
  }

  @override
  String get noPOsForReport => 'No purchase orders to generate report';

  @override
  String get errorGeneratingReport =>
      'Unable to generate report. Please try again later.';

  @override
  String get poAddedSuccess => 'Purchase Order added successfully!';

  @override
  String statusUpdated(String status) {
    return 'Status updated to $status';
  }

  @override
  String pleaseEnter(String field) {
    return 'Please enter $field';
  }

  @override
  String get enterValidQuantity => 'Please enter a valid quantity';

  @override
  String get productionQtyExceeds =>
      'Production quantity must be greater than PO quantity';

  @override
  String get masterUser => 'Master User';

  @override
  String get normalUser => 'Normal User';

  @override
  String switchedTo(String role) {
    return 'Switched to $role User';
  }

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get tamil => 'Tamil';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get info => 'Information';

  @override
  String get warning => 'Warning';

  @override
  String get notFoundError => 'Purchase Order not found';

  @override
  String get networkError =>
      'Unable to connect. Please check your internet connection and try again.';

  @override
  String get permissionError =>
      'You do not have permission to perform this action.';

  @override
  String get validationError => 'Please check your input and try again.';

  @override
  String get storageError =>
      'Unable to save data. Please check available storage space.';

  @override
  String get genericError => 'Something went wrong. Please try again later.';

  @override
  String get login => 'Login';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get enterPhoneNumber => 'Enter your phone number to continue';

  @override
  String get invalidPhoneNumber =>
      'Invalid phone number. Please enter a valid registered phone number.';

  @override
  String get invalidPhoneFormat => 'Phone number must be exactly 10 digits';

  @override
  String get loginSuccess => 'Login successful!';

  @override
  String get loggingIn => 'Logging in...';

  @override
  String get loginInstructions => 'Login Instructions:';

  @override
  String get logout => 'Logout';

  @override
  String get qrCode => 'QR Code';

  @override
  String get scanQRCode => 'Scan QR Code';

  @override
  String get scanQRCodeInstructions =>
      'Point your camera at the QR code to view the Purchase Order';

  @override
  String get pointCameraAtQRCode => 'Point camera at QR code';

  @override
  String get scanQRCodeToViewPO =>
      'Scan this QR code to quickly view this Purchase Order';

  @override
  String get viewQRCode => 'View QR Code';

  @override
  String get poFound => 'Purchase Order found!';

  @override
  String get poNotFound =>
      'Purchase Order not found. Please check the QR code.';

  @override
  String get close => 'Close';

  @override
  String get webQRScannerNotSupported => 'QR Scanner not available on web';

  @override
  String get enterPOIdManually => 'Please enter the Purchase Order ID manually';

  @override
  String get enterPOId => 'Enter PO ID';

  @override
  String get searchPO => 'Search PO';

  @override
  String get downloadQRCode => 'Download QR Code';

  @override
  String get printQRCode => 'Print QR Code';

  @override
  String get qrCodeDownloaded => 'QR Code downloaded successfully!';

  @override
  String qrCodeSaved(String path) {
    return 'QR Code saved to: $path';
  }

  @override
  String get downloadFailed => 'Failed to download QR code. Please try again.';

  @override
  String get adminStatusUpdateNote =>
      'Note: Admin user has updated the status of this Purchase Order.';

  @override
  String adminChangedStatusTo(String status) {
    return 'Note: Admin user has changed the status to $status';
  }

  @override
  String get statusUpdatedByAdmin => 'Status was updated by Admin user';

  @override
  String get acceptQuantity => 'Accept Quantity';

  @override
  String get rejectedQuantity => 'Rejected Quantity';

  @override
  String get submitQuantities => 'Submit Quantities';

  @override
  String get quantitiesSubmitted => 'Quantities submitted successfully!';

  @override
  String get sumExceedsProduction =>
      'Sum of accepted and rejected quantities cannot exceed production quantity';

  @override
  String get enterQuantities => 'Please enter accept and rejected quantities';

  @override
  String get totalBuffer => 'Total Buffer';

  @override
  String get enterCorrectValues =>
      'Please enter correct values. Sum of accept and rejected quantities should not exceed production quantity';

  @override
  String get quantitiesRequired =>
      'Both accept and rejected quantities are required';

  @override
  String get quantitySummary => 'Quantity Summary';

  @override
  String get inspectedBy => 'Inspected By';

  @override
  String get operatorSupplierName => 'Operator/Supplier Name';

  @override
  String get rejectedAtStage => 'Rejected At Stage';

  @override
  String get pleaseEnterInspectedBy => 'Please enter inspected by name';

  @override
  String get pleaseEnterOperatorSupplier =>
      'Please enter operator/supplier name';

  @override
  String get rejectionDetails => 'Rejection Details';

  @override
  String get uploadImage => 'Upload Image';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get pickFromGallery => 'Gallery';

  @override
  String get rejectionImage => 'Rejection Image';

  @override
  String get remainingQuantity => 'Remaining Quantity';

  @override
  String get movedTo => 'Moved To';

  @override
  String get rejectedAt => 'Rejected At';
}
