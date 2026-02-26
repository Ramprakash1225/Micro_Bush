import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ta'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Lite Manufacturing MES'**
  String get appTitle;

  /// No description provided for @purchaseOrders.
  ///
  /// In en, this message translates to:
  /// **'Purchase Orders'**
  String get purchaseOrders;

  /// No description provided for @addPurchaseOrder.
  ///
  /// In en, this message translates to:
  /// **'Add Purchase Order'**
  String get addPurchaseOrder;

  /// No description provided for @poNumber.
  ///
  /// In en, this message translates to:
  /// **'PO Number'**
  String get poNumber;

  /// No description provided for @poDate.
  ///
  /// In en, this message translates to:
  /// **'PO Date'**
  String get poDate;

  /// No description provided for @partNumber.
  ///
  /// In en, this message translates to:
  /// **'Part Number'**
  String get partNumber;

  /// No description provided for @totalQuantity.
  ///
  /// In en, this message translates to:
  /// **'PO Quantity'**
  String get totalQuantity;

  /// No description provided for @productionQuantity.
  ///
  /// In en, this message translates to:
  /// **'Production Quantity'**
  String get productionQuantity;

  /// No description provided for @deliveryDate.
  ///
  /// In en, this message translates to:
  /// **'Delivery Date'**
  String get deliveryDate;

  /// No description provided for @currentStatus.
  ///
  /// In en, this message translates to:
  /// **'Current Status'**
  String get currentStatus;

  /// No description provided for @updateStatus.
  ///
  /// In en, this message translates to:
  /// **'Update Status'**
  String get updateStatus;

  /// No description provided for @productionStages.
  ///
  /// In en, this message translates to:
  /// **'Production Stages'**
  String get productionStages;

  /// No description provided for @downloadReport.
  ///
  /// In en, this message translates to:
  /// **'Download Report'**
  String get downloadReport;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @totalPOs.
  ///
  /// In en, this message translates to:
  /// **'Total POs'**
  String get totalPOs;

  /// No description provided for @addPO.
  ///
  /// In en, this message translates to:
  /// **'Add PO'**
  String get addPO;

  /// No description provided for @noPurchaseOrders.
  ///
  /// In en, this message translates to:
  /// **'No Purchase Orders'**
  String get noPurchaseOrders;

  /// No description provided for @addFirstPO.
  ///
  /// In en, this message translates to:
  /// **'Add your first purchase order to get started'**
  String get addFirstPO;

  /// No description provided for @poDetails.
  ///
  /// In en, this message translates to:
  /// **'Purchase Order Details'**
  String get poDetails;

  /// No description provided for @poInformation.
  ///
  /// In en, this message translates to:
  /// **'Purchase Order Information'**
  String get poInformation;

  /// No description provided for @canUpdateAnyStage.
  ///
  /// In en, this message translates to:
  /// **'You can update to any production stage'**
  String get canUpdateAnyStage;

  /// No description provided for @canOnlyMoveNext.
  ///
  /// In en, this message translates to:
  /// **'You can only move to the next stage'**
  String get canOnlyMoveNext;

  /// No description provided for @orderCompleted.
  ///
  /// In en, this message translates to:
  /// **'Order completed! All stages finished.'**
  String get orderCompleted;

  /// No description provided for @moveTo.
  ///
  /// In en, this message translates to:
  /// **'Move to {stage}'**
  String moveTo(String stage);

  /// No description provided for @chooseReportFormat.
  ///
  /// In en, this message translates to:
  /// **'Choose report format:'**
  String get chooseReportFormat;

  /// No description provided for @editBeforeDownload.
  ///
  /// In en, this message translates to:
  /// **'Edit before download (Admin only)'**
  String get editBeforeDownload;

  /// No description provided for @downloadNow.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get downloadNow;

  /// No description provided for @generatingReport.
  ///
  /// In en, this message translates to:
  /// **'Generating report...'**
  String get generatingReport;

  /// No description provided for @reportSaved.
  ///
  /// In en, this message translates to:
  /// **'Report saved to: {path}'**
  String reportSaved(String path);

  /// No description provided for @noPOsForReport.
  ///
  /// In en, this message translates to:
  /// **'No purchase orders to generate report'**
  String get noPOsForReport;

  /// No description provided for @errorGeneratingReport.
  ///
  /// In en, this message translates to:
  /// **'Unable to generate report. Please try again later.'**
  String get errorGeneratingReport;

  /// No description provided for @poAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchase Order added successfully!'**
  String get poAddedSuccess;

  /// No description provided for @statusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Status updated to {status}'**
  String statusUpdated(String status);

  /// No description provided for @pleaseEnter.
  ///
  /// In en, this message translates to:
  /// **'Please enter {field}'**
  String pleaseEnter(String field);

  /// No description provided for @enterValidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid quantity'**
  String get enterValidQuantity;

  /// No description provided for @productionQtyExceeds.
  ///
  /// In en, this message translates to:
  /// **'Production quantity must be greater than PO quantity'**
  String get productionQtyExceeds;

  /// No description provided for @masterUser.
  ///
  /// In en, this message translates to:
  /// **'Master User'**
  String get masterUser;

  /// No description provided for @normalUser.
  ///
  /// In en, this message translates to:
  /// **'Normal User'**
  String get normalUser;

  /// No description provided for @switchedTo.
  ///
  /// In en, this message translates to:
  /// **'Switched to {role} User'**
  String switchedTo(String role);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @tamil.
  ///
  /// In en, this message translates to:
  /// **'Tamil'**
  String get tamil;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @notFoundError.
  ///
  /// In en, this message translates to:
  /// **'Purchase Order not found'**
  String get notFoundError;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect. Please check your internet connection and try again.'**
  String get networkError;

  /// No description provided for @permissionError.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this action.'**
  String get permissionError;

  /// No description provided for @validationError.
  ///
  /// In en, this message translates to:
  /// **'Please check your input and try again.'**
  String get validationError;

  /// No description provided for @storageError.
  ///
  /// In en, this message translates to:
  /// **'Unable to save data. Please check available storage space.'**
  String get storageError;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again later.'**
  String get genericError;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to continue'**
  String get enterPhoneNumber;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number. Please enter a valid registered phone number.'**
  String get invalidPhoneNumber;

  /// No description provided for @invalidPhoneFormat.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be exactly 10 digits'**
  String get invalidPhoneFormat;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccess;

  /// No description provided for @loggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get loggingIn;

  /// No description provided for @loginInstructions.
  ///
  /// In en, this message translates to:
  /// **'Login Instructions:'**
  String get loginInstructions;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @qrCode.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrCode;

  /// No description provided for @scanQRCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQRCode;

  /// No description provided for @scanQRCodeInstructions.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at the QR code to view the Purchase Order'**
  String get scanQRCodeInstructions;

  /// No description provided for @pointCameraAtQRCode.
  ///
  /// In en, this message translates to:
  /// **'Point camera at QR code'**
  String get pointCameraAtQRCode;

  /// No description provided for @scanQRCodeToViewPO.
  ///
  /// In en, this message translates to:
  /// **'Scan this QR code to quickly view this Purchase Order'**
  String get scanQRCodeToViewPO;

  /// No description provided for @viewQRCode.
  ///
  /// In en, this message translates to:
  /// **'View QR Code'**
  String get viewQRCode;

  /// No description provided for @poFound.
  ///
  /// In en, this message translates to:
  /// **'Purchase Order found!'**
  String get poFound;

  /// No description provided for @poNotFound.
  ///
  /// In en, this message translates to:
  /// **'Purchase Order not found. Please check the QR code.'**
  String get poNotFound;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @webQRScannerNotSupported.
  ///
  /// In en, this message translates to:
  /// **'QR Scanner not available on web'**
  String get webQRScannerNotSupported;

  /// No description provided for @enterPOIdManually.
  ///
  /// In en, this message translates to:
  /// **'Please enter the Purchase Order ID manually'**
  String get enterPOIdManually;

  /// No description provided for @enterPOId.
  ///
  /// In en, this message translates to:
  /// **'Enter PO ID'**
  String get enterPOId;

  /// No description provided for @searchPO.
  ///
  /// In en, this message translates to:
  /// **'Search PO'**
  String get searchPO;

  /// No description provided for @downloadQRCode.
  ///
  /// In en, this message translates to:
  /// **'Download QR Code'**
  String get downloadQRCode;

  /// No description provided for @printQRCode.
  ///
  /// In en, this message translates to:
  /// **'Print QR Code'**
  String get printQRCode;

  /// No description provided for @qrCodeDownloaded.
  ///
  /// In en, this message translates to:
  /// **'QR Code downloaded successfully!'**
  String get qrCodeDownloaded;

  /// No description provided for @qrCodeSaved.
  ///
  /// In en, this message translates to:
  /// **'QR Code saved to: {path}'**
  String qrCodeSaved(String path);

  /// No description provided for @downloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to download QR code. Please try again.'**
  String get downloadFailed;

  /// No description provided for @adminStatusUpdateNote.
  ///
  /// In en, this message translates to:
  /// **'Note: Admin user has updated the status of this Purchase Order.'**
  String get adminStatusUpdateNote;

  /// No description provided for @adminChangedStatusTo.
  ///
  /// In en, this message translates to:
  /// **'Note: Admin user has changed the status to {status}'**
  String adminChangedStatusTo(String status);

  /// No description provided for @statusUpdatedByAdmin.
  ///
  /// In en, this message translates to:
  /// **'Status was updated by Admin user'**
  String get statusUpdatedByAdmin;

  /// No description provided for @acceptQuantity.
  ///
  /// In en, this message translates to:
  /// **'Accept Quantity'**
  String get acceptQuantity;

  /// No description provided for @rejectedQuantity.
  ///
  /// In en, this message translates to:
  /// **'Rejected Quantity'**
  String get rejectedQuantity;

  /// No description provided for @submitQuantities.
  ///
  /// In en, this message translates to:
  /// **'Submit Quantities'**
  String get submitQuantities;

  /// No description provided for @quantitiesSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Quantities submitted successfully!'**
  String get quantitiesSubmitted;

  /// No description provided for @sumExceedsProduction.
  ///
  /// In en, this message translates to:
  /// **'Sum of accepted and rejected quantities cannot exceed production quantity'**
  String get sumExceedsProduction;

  /// No description provided for @enterQuantities.
  ///
  /// In en, this message translates to:
  /// **'Please enter accept and rejected quantities'**
  String get enterQuantities;

  /// No description provided for @totalBuffer.
  ///
  /// In en, this message translates to:
  /// **'Total Buffer'**
  String get totalBuffer;

  /// No description provided for @enterCorrectValues.
  ///
  /// In en, this message translates to:
  /// **'Please enter correct values. Sum of accept and rejected quantities should not exceed production quantity'**
  String get enterCorrectValues;

  /// No description provided for @quantitiesRequired.
  ///
  /// In en, this message translates to:
  /// **'Both accept and rejected quantities are required'**
  String get quantitiesRequired;

  /// No description provided for @quantitySummary.
  ///
  /// In en, this message translates to:
  /// **'Quantity Summary'**
  String get quantitySummary;

  /// No description provided for @inspectedBy.
  ///
  /// In en, this message translates to:
  /// **'Inspected By'**
  String get inspectedBy;

  /// No description provided for @operatorSupplierName.
  ///
  /// In en, this message translates to:
  /// **'Operator/Supplier Name'**
  String get operatorSupplierName;

  /// No description provided for @rejectedAtStage.
  ///
  /// In en, this message translates to:
  /// **'Rejected At Stage'**
  String get rejectedAtStage;

  /// No description provided for @pleaseEnterInspectedBy.
  ///
  /// In en, this message translates to:
  /// **'Please enter inspected by name'**
  String get pleaseEnterInspectedBy;

  /// No description provided for @pleaseEnterOperatorSupplier.
  ///
  /// In en, this message translates to:
  /// **'Please enter operator/supplier name'**
  String get pleaseEnterOperatorSupplier;

  /// No description provided for @rejectionDetails.
  ///
  /// In en, this message translates to:
  /// **'Rejection Details'**
  String get rejectionDetails;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @pickFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get pickFromGallery;

  /// No description provided for @rejectionImage.
  ///
  /// In en, this message translates to:
  /// **'Rejection Image'**
  String get rejectionImage;

  /// No description provided for @remainingQuantity.
  ///
  /// In en, this message translates to:
  /// **'Remaining Quantity'**
  String get remainingQuantity;

  /// No description provided for @movedTo.
  ///
  /// In en, this message translates to:
  /// **'Moved To'**
  String get movedTo;

  /// No description provided for @rejectedAt.
  ///
  /// In en, this message translates to:
  /// **'Rejected At'**
  String get rejectedAt;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
