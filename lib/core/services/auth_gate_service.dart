import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_contacts_app/app/routes/app_routes.dart';

class AuthGateService {
  AuthGateService._();

  static String get initialRoute {
    if (FirebaseAuth.instance.currentUser == null) {
      return AppRoutes.signIn;
    }
    return AppRoutes.authGate;
  }

  static bool get isSignedIn => FirebaseAuth.instance.currentUser != null;
}
