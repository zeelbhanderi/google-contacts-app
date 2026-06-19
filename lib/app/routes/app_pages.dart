import 'package:get/get.dart';
import 'package:google_contacts_app/app/routes/app_routes.dart';
import 'package:google_contacts_app/features/auth/bindings/auth_binding.dart';
import 'package:google_contacts_app/features/auth/views/auth_gate_view.dart';
import 'package:google_contacts_app/features/auth/views/sign_in_view.dart';
import 'package:google_contacts_app/features/contact_detail/bindings/contact_detail_binding.dart';
import 'package:google_contacts_app/features/contact_detail/views/contact_detail_view.dart';
import 'package:google_contacts_app/features/contact_form/bindings/contact_form_binding.dart';
import 'package:google_contacts_app/features/contact_form/views/contact_form_view.dart';
import 'package:google_contacts_app/features/home/bindings/home_binding.dart';
import 'package:google_contacts_app/features/home/views/home_view.dart';
import 'package:google_contacts_app/features/settings/bindings/settings_binding.dart';
import 'package:google_contacts_app/features/settings/views/settings_view.dart';

abstract class AppPages {
  AppPages._();

  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.signIn,
      page: SignInView.new,
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.authGate,
      page: AuthGateView.new,
      binding: AuthGateBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: HomeView.new,
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.contactDetail,
      page: ContactDetailView.new,
      binding: ContactDetailBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.contactForm,
      page: ContactFormView.new,
      binding: ContactFormBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: SettingsView.new,
      binding: SettingsBinding(),
    ),
  ];

  static List<GetPage<dynamic>> get routes => pages;
}
