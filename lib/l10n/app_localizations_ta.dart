// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'லைட் மேனுஃபேக்சரிங் MES';

  @override
  String get purchaseOrders => 'கொள்முதல் ஆர்டர்கள்';

  @override
  String get addPurchaseOrder => 'கொள்முதல் ஆர்டர் சேர்க்க';

  @override
  String get poNumber => 'PO எண்';

  @override
  String get poDate => 'PO தேதி';

  @override
  String get partNumber => 'பாக எண்';

  @override
  String get totalQuantity => 'PO அளவு';

  @override
  String get productionQuantity => 'உற்பத்தி அளவு';

  @override
  String get deliveryDate => 'விநியோக தேதி';

  @override
  String get currentStatus => 'தற்போதைய நிலை';

  @override
  String get updateStatus => 'நிலையை புதுப்பிக்க';

  @override
  String get productionStages => 'உற்பத்தி நிலைகள்';

  @override
  String get downloadReport => 'அறிக்கை பதிவிறக்க';

  @override
  String get welcome => 'வரவேற்கிறோம்';

  @override
  String get role => 'பங்கு';

  @override
  String get totalPOs => 'மொத்த PO-கள்';

  @override
  String get addPO => 'PO சேர்க்க';

  @override
  String get noPurchaseOrders => 'கொள்முதல் ஆர்டர்கள் இல்லை';

  @override
  String get addFirstPO => 'தொடங்க உங்கள் முதல் கொள்முதல் ஆர்டரைச் சேர்க்கவும்';

  @override
  String get poDetails => 'கொள்முதல் ஆர்டர் விவரங்கள்';

  @override
  String get poInformation => 'கொள்முதல் ஆர்டர் தகவல்';

  @override
  String get canUpdateAnyStage =>
      'நீங்கள் எந்த உற்பத்தி நிலைக்கும் புதுப்பிக்கலாம்';

  @override
  String get canOnlyMoveNext => 'நீங்கள் அடுத்த நிலைக்கு மட்டுமே நகர்த்தலாம்';

  @override
  String get orderCompleted => 'ஆர்டர் முடிந்தது! அனைத்து நிலைகளும் முடிந்தன.';

  @override
  String moveTo(String stage) {
    return '$stage க்கு நகர்த்த';
  }

  @override
  String get chooseReportFormat => 'அறிக்கை வடிவத்தைத் தேர்ந்தெடுக்கவும்:';

  @override
  String get editBeforeDownload =>
      'பதிவிறக்குவதற்கு முன் திருத்து (நிர்வாகம் மட்டும்)';

  @override
  String get downloadNow => 'பதிவிறக்கு';

  @override
  String get generatingReport => 'அறிக்கை உருவாக்கப்படுகிறது...';

  @override
  String reportSaved(String path) {
    return 'அறிக்கை சேமிக்கப்பட்டது: $path';
  }

  @override
  String get noPOsForReport => 'அறிக்கை உருவாக்க கொள்முதல் ஆர்டர்கள் இல்லை';

  @override
  String get errorGeneratingReport =>
      'அறிக்கையை உருவாக்க முடியவில்லை. பிறகு மீண்டும் முயற்சிக்கவும்.';

  @override
  String get poAddedSuccess => 'கொள்முதல் ஆர்டர் வெற்றிகரமாக சேர்க்கப்பட்டது!';

  @override
  String statusUpdated(String status) {
    return 'நிலை புதுப்பிக்கப்பட்டது: $status';
  }

  @override
  String pleaseEnter(String field) {
    return 'தயவுசெய்து $field உள்ளிடவும்';
  }

  @override
  String get enterValidQuantity => 'தயவுசெய்து சரியான அளவை உள்ளிடவும்';

  @override
  String get productionQtyExceeds =>
      'உற்பத்தி அளவு PO அளவை விட அதிகமாக இருக்க வேண்டும்';

  @override
  String get masterUser => 'மாஸ்டர் பயனர்';

  @override
  String get normalUser => 'சாதாரண பயனர்';

  @override
  String switchedTo(String role) {
    return '$role பயனருக்கு மாற்றப்பட்டது';
  }

  @override
  String get language => 'மொழி';

  @override
  String get english => 'ஆங்கிலம்';

  @override
  String get tamil => 'தமிழ்';

  @override
  String get error => 'பிழை';

  @override
  String get success => 'வெற்றி';

  @override
  String get info => 'தகவல்';

  @override
  String get warning => 'எச்சரிக்கை';

  @override
  String get notFoundError => 'கொள்முதல் ஆர்டர் காணப்படவில்லை';

  @override
  String get networkError =>
      'இணைக்க முடியவில்லை. உங்கள் இணைய இணைப்பைச் சரிபார்க்கவும் மீண்டும் முயற்சிக்கவும்.';

  @override
  String get permissionError => 'இந்த செயலைச் செய்ய உங்களுக்கு அனுமதி இல்லை.';

  @override
  String get validationError =>
      'தயவுசெய்து உங்கள் உள்ளீட்டைச் சரிபார்க்கவும் மீண்டும் முயற்சிக்கவும்.';

  @override
  String get storageError =>
      'தரவைச் சேமிக்க முடியவில்லை. கிடைக்கும் சேமிப்பு இடத்தைச் சரிபார்க்கவும்.';

  @override
  String get genericError => 'ஏதோ தவறு நடந்தது. பிறகு மீண்டும் முயற்சிக்கவும்.';

  @override
  String get login => 'உள்நுழைய';

  @override
  String get phoneNumber => 'தொலைபேசி எண்';

  @override
  String get enterPhoneNumber => 'தொடர உங்கள் தொலைபேசி எண்ணை உள்ளிடவும்';

  @override
  String get invalidPhoneNumber =>
      'தவறான தொலைபேசி எண். தயவுசெய்து சரியான பதிவுசெய்யப்பட்ட தொலைபேசி எண்ணை உள்ளிடவும்.';

  @override
  String get invalidPhoneFormat =>
      'தொலைபேசி எண் சரியாக 10 இலக்கங்களாக இருக்க வேண்டும்';

  @override
  String get loginSuccess => 'வெற்றிகரமாக உள்நுழைந்தது!';

  @override
  String get loggingIn => 'உள்நுழைகிறது...';

  @override
  String get loginInstructions => 'உள்நுழைவு வழிமுறைகள்:';

  @override
  String get logout => 'வெளியேற';

  @override
  String get qrCode => 'QR குறியீடு';

  @override
  String get scanQRCode => 'QR குறியீட்டை ஸ்கேன் செய்ய';

  @override
  String get scanQRCodeInstructions =>
      'கொள்முதல் ஆர்டரைக் காண QR குறியீட்டில் உங்கள் கேமராவை சுட்டிக்காட்டவும்';

  @override
  String get pointCameraAtQRCode => 'QR குறியீட்டில் கேமராவை சுட்டிக்காட்டவும்';

  @override
  String get scanQRCodeToViewPO =>
      'இந்த கொள்முதல் ஆர்டரை விரைவாகக் காண இந்த QR குறியீட்டை ஸ்கேன் செய்யவும்';

  @override
  String get viewQRCode => 'QR குறியீட்டைக் காண';

  @override
  String get poFound => 'கொள்முதல் ஆர்டர் கண்டறியப்பட்டது!';

  @override
  String get poNotFound =>
      'கொள்முதல் ஆர்டர் காணப்படவில்லை. தயவுசெய்து QR குறியீட்டைச் சரிபார்க்கவும்.';

  @override
  String get close => 'மூடு';

  @override
  String get webQRScannerNotSupported =>
      'QR ஸ்கேனர் வலைத்தளத்தில் கிடைக்கவில்லை';

  @override
  String get enterPOIdManually =>
      'தயவுசெய்து கொள்முதல் ஆர்டர் ID ஐ கைமுறையாக உள்ளிடவும்';

  @override
  String get enterPOId => 'PO ID உள்ளிடவும்';

  @override
  String get searchPO => 'PO தேட';

  @override
  String get downloadQRCode => 'QR குறியீட்டை பதிவிறக்க';

  @override
  String get printQRCode => 'QR குறியீட்டை அச்சிடு';

  @override
  String get qrCodeDownloaded => 'QR குறியீடு வெற்றிகரமாக பதிவிறக்கப்பட்டது!';

  @override
  String qrCodeSaved(String path) {
    return 'QR குறியீடு சேமிக்கப்பட்டது: $path';
  }

  @override
  String get downloadFailed =>
      'QR குறியீட்டை பதிவிறக்க முடியவில்லை. தயவுசெய்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get adminStatusUpdateNote =>
      'குறிப்பு: நிர்வாக பயனர் இந்த கொள்முதல் ஆர்டரின் நிலையை புதுப்பித்துள்ளார்.';

  @override
  String adminChangedStatusTo(String status) {
    return 'குறிப்பு: நிர்வாக பயனர் நிலையை $status க்கு மாற்றியுள்ளார்';
  }

  @override
  String get statusUpdatedByAdmin => 'நிலை நிர்வாக பயனரால் புதுப்பிக்கப்பட்டது';

  @override
  String get acceptQuantity => 'ஏற்றுக்கொள்ளப்பட்ட அளவு';

  @override
  String get rejectedQuantity => 'நிராகரிக்கப்பட்ட அளவு';

  @override
  String get submitQuantities => 'அளவுகளை சமர்ப்பிக்க';

  @override
  String get quantitiesSubmitted => 'அளவுகள் வெற்றிகரமாக சமர்ப்பிக்கப்பட்டன!';

  @override
  String get sumExceedsProduction =>
      'ஏற்றுக்கொள்ளப்பட்ட மற்றும் நிராகரிக்கப்பட்ட அளவுகளின் கூட்டுத்தொகை உற்பத்தி அளவை விட அதிகமாக இருக்கக்கூடாது';

  @override
  String get enterQuantities =>
      'தயவுசெய்து ஏற்றுக்கொள்ளப்பட்ட மற்றும் நிராகரிக்கப்பட்ட அளவுகளை உள்ளிடவும்';

  @override
  String get totalBuffer => 'மொத்த பஃப்பர்';

  @override
  String get enterCorrectValues =>
      'தயவுசெய்து சரியான மதிப்புகளை உள்ளிடவும். ஏற்றுக்கொள்ளப்பட்ட மற்றும் நிராகரிக்கப்பட்ட அளவுகளின் கூட்டுத்தொகை உற்பத்தி அளவை விட அதிகமாக இருக்கக்கூடாது';

  @override
  String get quantitiesRequired =>
      'ஏற்றுக்கொள்ளப்பட்ட மற்றும் நிராகரிக்கப்பட்ட அளவுகள் இரண்டும் தேவை';

  @override
  String get quantitySummary => 'அளவு சுருக்கம்';

  @override
  String get inspectedBy => 'பரிசோதித்தவர்';

  @override
  String get operatorSupplierName => 'ஆபரேட்டர்/சப்ளையர் பெயர்';

  @override
  String get rejectedAtStage => 'நிராகரிக்கப்பட்ட நிலை';

  @override
  String get pleaseEnterInspectedBy =>
      'தயவுசெய்து பரிசோதித்தவரின் பெயரை உள்ளிடவும்';

  @override
  String get pleaseEnterOperatorSupplier =>
      'தயவுசெய்து ஆபரேட்டர்/சப்ளையர் பெயரை உள்ளிடவும்';

  @override
  String get rejectionDetails => 'நிராகரிப்பு விவரங்கள்';

  @override
  String get uploadImage => 'படம் பதிவேற்று';

  @override
  String get takePhoto => 'படம் எடு';

  @override
  String get pickFromGallery => 'கேலரி';

  @override
  String get rejectionImage => 'நிராகரிப்பு படம்';

  @override
  String get remainingQuantity => 'மீதமுள்ள அளவு';

  @override
  String get movedTo => 'நகர்த்தப்பட்டது';

  @override
  String get rejectedAt => 'நிராகரிக்கப்பட்ட நேரம்';
}
