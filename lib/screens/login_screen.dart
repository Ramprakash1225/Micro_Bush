import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/user_service.dart';
import '../models/user.dart';
import '../models/user_role.dart';
import '../utils/error_messages.dart';
import '../constants/branding.dart';
import '../services/logging_service.dart';
import '../services/purchase_order_service.dart';
import '../services/sample_data_service.dart';
import '../widgets/language_toggle.dart';
import '../widgets/logo_watermark.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePhone = true;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final phoneNumber = _phoneController.text.trim();
        final userService = Provider.of<UserService>(context, listen: false);
        final l10n = AppLocalizations.of(context)!;

        // Simulate network delay for better UX
        await Future.delayed(const Duration(milliseconds: 500));

        User? user;
        if (phoneNumber == '9999999999') {
          user = User(
            id: '1',
            name: l10n.masterUser,
            role: UserRole.masterUser,
          );
          LoggingService.logUserAction(
            'Login',
            details: {'phone': phoneNumber, 'role': 'Master User'},
          );
        } else if (phoneNumber == '8888888888') {
          user = User(
            id: '2',
            name: l10n.normalUser,
            role: UserRole.normalUser,
          );
          LoggingService.logUserAction(
            'Login',
            details: {'phone': phoneNumber, 'role': 'Normal User'},
          );
        } else {
          // Invalid phone number
          if (!mounted) return;
          ErrorMessages.showErrorSnackBar(context, l10n.invalidPhoneNumber);
          setState(() {
            _isLoading = false;
          });
          return;
        }

        userService.setUser(user);
        if (!mounted) return;
        final navigator = Navigator.of(context);
        ErrorMessages.showSuccessSnackBar(context, l10n.loginSuccess);
        // Navigate to PO list after short delay
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;
        // Initialize sample data after login
        final poService = Provider.of<PurchaseOrderService>(
          context,
          listen: false,
        );
        if (poService.purchaseOrders.isEmpty) {
          SampleDataService.initializeSampleData(poService);
        }
        navigator.pushReplacementNamed('/home');
      } catch (e, stackTrace) {
        LoggingService.error('Login error', e, stackTrace);
        ErrorMessages.showErrorSnackBar(context, e);
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Branding.primaryColor, Branding.secondaryColor],
              ),
            ),
          ),
          const LogoWatermark(),
          SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Branding.spacingXL),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo placeholder
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(Branding.radiusXL),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.precision_manufacturing,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: Branding.spacingXL),
                  Text(
                    Branding.appName,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: Branding.spacingS),
                  Text(
                    Branding.appTagline,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Login Card
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Branding.radiusL),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(Branding.spacingXL),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  l10n.login,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const LanguageToggle(),
                              ],
                            ),
                            const SizedBox(height: Branding.spacingL),
                            Text(
                              l10n.enterPhoneNumber,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: Branding.spacingM),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              obscureText: _obscurePhone,
                              decoration: InputDecoration(
                                labelText: l10n.phoneNumber,
                                //hintText: '9999999999',
                                prefixIcon: const Icon(Icons.phone),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePhone
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePhone = !_obscurePhone;
                                    });
                                  },
                                ),
                                border: const OutlineInputBorder(),
                                counterText: '',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return l10n.pleaseEnter(l10n.phoneNumber);
                                }
                                if (value.trim().length != 10) {
                                  return l10n.invalidPhoneFormat;
                                }
                                if (!RegExp(
                                  r'^[0-9]+$',
                                ).hasMatch(value.trim())) {
                                  return l10n.invalidPhoneFormat;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: Branding.spacingL),
                            FilledButton.icon(
                              onPressed: _isLoading ? null : _handleLogin,
                              icon: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : const Icon(Icons.login),
                              label: Text(
                                _isLoading ? l10n.loggingIn : l10n.login,
                              ),
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: Branding.spacingM),
                            Container(
                              padding: const EdgeInsets.all(Branding.spacingM),
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(
                                  Branding.radiusS,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.loginInstructions,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: Branding.spacingS),
                                  _buildInstructionRow(
                                    context,
                                    '9999999999',
                                    l10n.masterUser,
                                  ),
                                  _buildInstructionRow(
                                    context,
                                    '8888888888',
                                    l10n.normalUser,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
    );
  }

  Widget _buildInstructionRow(BuildContext context, String phone, String role) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: Branding.spacingS),
      child: Row(
        children: [
          Icon(Icons.phone_android, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: Branding.spacingS),
          Text('$phone → $role', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
