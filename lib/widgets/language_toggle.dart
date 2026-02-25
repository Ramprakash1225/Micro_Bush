import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/language_service.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final l10n = AppLocalizations.of(context)!;

    return SegmentedButton<Locale>(
      segments: [
        ButtonSegment<Locale>(
          value: const Locale('en'),
          label: Text(l10n.english),
          icon: const Icon(Icons.language, size: 18),
        ),
        ButtonSegment<Locale>(
          value: const Locale('ta'),
          label: Text(l10n.tamil),
          icon: const Icon(Icons.translate, size: 18),
        ),
      ],
      selected: {languageService.currentLocale},
      onSelectionChanged: (Set<Locale> newSelection) {
        if (newSelection.isNotEmpty) {
          languageService.setLanguage(newSelection.first);
        }
      },
    );
  }
}
