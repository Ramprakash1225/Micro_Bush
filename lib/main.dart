import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'services/purchase_order_service.dart';
import 'services/user_service.dart';
import 'services/language_service.dart';
import 'services/sample_data_service.dart';
import 'constants/branding.dart';
import 'screens/po_list_screen.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());    
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageService()),
        ChangeNotifierProvider(create: (_) => PurchaseOrderService()),
        ChangeNotifierProvider(create: (_) => UserService()),
      ],
      child: Consumer<LanguageService>(
        builder: (context, languageService, _) {
          // Initialize sample data on first load
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final poService = Provider.of<PurchaseOrderService>(context, listen: false);
            if (poService.purchaseOrders.isEmpty) {
              SampleDataService.initializeSampleData(poService);
            }
          });

          return MaterialApp(
            title: Branding.appName,
            debugShowCheckedModeBanner: false,
            locale: languageService.currentLocale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('ta', ''),
            ],
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Branding.primaryColor,
                brightness: Brightness.light,
                primary: Branding.primaryColor,
                secondary: Branding.secondaryColor,
                error: Branding.errorColor,
                surface: Branding.surfaceColor,
              ),
              cardTheme: CardThemeData(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Branding.radiusM),
                ),
                shadowColor: Colors.black.withValues(alpha: 0.1),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Branding.radiusS),
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              filledButtonTheme: FilledButtonThemeData(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Branding.radiusS),
                  ),
                  elevation: 0,
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Branding.radiusS),
                  ),
                  elevation: 2,
                ),
              ),
              appBarTheme: AppBarTheme(
                centerTitle: false,
                elevation: 0,
                backgroundColor: Branding.primaryColor,
                foregroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.white),
                titleTextStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              scaffoldBackgroundColor: Branding.backgroundColor,
              fontFamily: 'Roboto',
            ),
            initialRoute: '/login',
            routes: {
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const POListScreen(),
            },
            onGenerateRoute: (settings) {
              // Check if user is logged in for protected routes
              if (settings.name == '/home') {
                final userService = Provider.of<UserService>(context, listen: false);
                if (userService.currentUser == null) {
                  return MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  );
                }
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
