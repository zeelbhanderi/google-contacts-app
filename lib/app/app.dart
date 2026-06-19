import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/app/routes/app_pages.dart';
import 'package:google_contacts_app/app/themes/app_theme.dart';
import 'package:google_contacts_app/core/services/auth_gate_service.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';
import 'package:google_contacts_app/core/constants/app_constants.dart';
import 'package:google_contacts_app/features/auth/bindings/auth_binding.dart';
import 'package:google_contacts_app/l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      initialBinding: AuthBinding(),
      builder: (context, child) {
        Rs.init(context);
        return child!;
      },
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale(AppConstants.defaultLocale),
      initialRoute: AuthGateService.initialRoute,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
      debugShowCheckedModeBanner: false,
    );
  }
}
