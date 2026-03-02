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
            final poService = Provider.of<PurchaseOrderService>(
              context,
              listen: false,
            );
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
            supportedLocales: const [Locale('en', ''), Locale('ta', '')],
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Branding.primaryColor,
                brightness: Brightness.light,
                primary: Branding.primaryColor,
                onPrimary: const Color(0xFF1A3A5C), // Dark text on pale primary
                secondary: Branding.secondaryColor,
                onSecondary: Colors.white,
                error: Branding.errorColor,
                surface: Branding.surfaceColor,
                onSurface: Branding.textPrimary,
                primaryContainer: Branding.primaryColor,
                onPrimaryContainer: const Color(0xFF1A3A5C),
                surfaceContainerHighest: const Color(
                  0xFFF0F2F5,
                ), // Light grey for highlighted areas
              ),
              cardTheme: CardThemeData(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Branding.radiusL),
                ),
                color: Branding.surfaceColor,
                shadowColor: Branding.primaryColor.withValues(alpha: 0.15),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Branding.radiusM),
                  borderSide: const BorderSide(color: Branding.secondaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Branding.radiusM),
                  borderSide: BorderSide(
                    color: Branding.secondaryColor.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Branding.radiusM),
                  borderSide: const BorderSide(
                    color: Branding.primaryColor,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Branding.surfaceColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                labelStyle: const TextStyle(color: Branding.textSecondary),
              ),
              filledButtonTheme: FilledButtonThemeData(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Branding.radiusL),
                  ),
                  elevation: 2,
                  shadowColor: Branding.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Branding.radiusL),
                  ),
                  elevation: 3,
                  shadowColor: Branding.primaryColor.withValues(alpha: 0.2),
                ),
              ),
              appBarTheme: AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Branding.primaryColorDark,
                foregroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.white),
                titleTextStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
                scrolledUnderElevation: 4,
                shadowColor: Colors.black26,
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
                final userService = Provider.of<UserService>(
                  context,
                  listen: false,
                );
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
