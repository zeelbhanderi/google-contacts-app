import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/app/routes/app_routes.dart';
import 'package:google_contacts_app/core/constants/app_constants.dart';
import 'package:google_contacts_app/core/errors/result.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/domain/usecases/clear_all_local_contacts.dart';
import 'package:google_contacts_app/domain/usecases/sync_remote_contacts_to_local.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  AuthController({
    required GoogleSignIn googleSignIn,
    required FirebaseAuth firebaseAuth,
    required SyncRemoteContactsToLocal syncRemoteContactsToLocal,
    required ClearAllLocalContacts clearAllLocalContacts,
  }) : _googleSignIn = googleSignIn,
       _firebaseAuth = firebaseAuth,
       _syncRemoteContactsToLocal = syncRemoteContactsToLocal,
       _clearAllLocalContacts = clearAllLocalContacts;

  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;
  final SyncRemoteContactsToLocal _syncRemoteContactsToLocal;
  final ClearAllLocalContacts _clearAllLocalContacts;

  final Rxn<User> firebaseUser = Rxn<User>();
  final RxBool isLoading = false.obs;
  final RxBool isSyncing = false.obs;
  final RxString syncMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkInitialAuthState();
  }

  void checkInitialAuthState() {
    firebaseUser.value = _firebaseAuth.currentUser;
  }

  Future<Result<Unit>> syncContactsAfterAuth() async {
    isSyncing.value = true;
    syncMessage.value = AppStrings.T.restoringContacts;
    try {
      return await _syncRemoteContactsToLocal();
    } finally {
      isSyncing.value = false;
      syncMessage.value = '';
    }
  }

  Future<Result<Unit>> signInWithGoogle() async {
    isLoading.value = true;
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return const Success(Unit.value);
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      firebaseUser.value = userCredential.user;

      final syncResult = await syncContactsAfterAuth();
      isLoading.value = false;

      if (syncResult case Failure(message: final message)) {
        return Failure(message);
      }

      return const Success(Unit.value);
    } on FirebaseAuthException catch (error) {
      isLoading.value = false;
      isSyncing.value = false;
      syncMessage.value = '';
      return Failure(_mapAuthError(error));
    } on PlatformException catch (error) {
      isLoading.value = false;
      isSyncing.value = false;
      syncMessage.value = '';
      if (_isUserCancellation(error)) {
        return const Success(Unit.value);
      }
      return Failure(_mapAuthError(error));
    } on SocketException {
      isLoading.value = false;
      isSyncing.value = false;
      syncMessage.value = '';
      return Failure(AppStrings.T.noInternetConnection);
    } catch (error) {
      isLoading.value = false;
      isSyncing.value = false;
      syncMessage.value = '';
      return Failure(_mapAuthError(error));
    }
  }

  Future<void> signOut() async {
    isLoading.value = true;
    await _clearAllLocalContacts();
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    firebaseUser.value = null;
    isLoading.value = false;
    Get.offAllNamed(AppRoutes.signIn);
  }

  bool _isUserCancellation(PlatformException error) {
    return error.code == AuthErrorCode.signInCanceled ||
        error.code == AuthErrorCode.googleSignInCanceled ||
        (error.message?.contains(AuthErrorCode.canceledKeyword) ?? false);
  }

  String _mapAuthError(Object error) {
    if (error is FirebaseAuthException) {
      return switch (error.code) {
        AuthErrorCode.networkRequestFailed => AppStrings.T.noInternetConnection,
        AuthErrorCode.accountExistsWithDifferentCredential =>
          AppStrings.T.accountExistsDifferentCredential,
        _ => error.message ?? AppStrings.T.signInFailedRetry,
      };
    }
    if (error is PlatformException) {
      if (error.code == AuthErrorCode.networkError) {
        return AppStrings.T.noInternetConnection;
      }
      return error.message ?? AppStrings.T.signInFailedRetry;
    }
    return error.toString();
  }
}
