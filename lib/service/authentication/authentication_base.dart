import 'package:living_room/extension/results/auth_exception_extension.dart';
import 'package:living_room/extension/results/sign_up_exception_extension.dart';
import 'package:living_room/extension/results/success_message_extension.dart';
import 'package:living_room/extension/results/verify_email_exception_extension.dart';
import 'package:living_room/model/authentication/local_user.dart';

abstract class AuthenticationBase{
  Stream<AuthUser?> get authStateChange;

  AuthUser? get currentUser;

  void signIn({required String email, required String password, Function(AuthException)? onError, Function()? onSuccess});

  void signUp({required String email, required String password, Function(SignUpException)? onError,  Function(SuccessMessage)? onSuccess});

  void signOut();

  void verifyEmail({Function(VerifyEmailException)? onError,  Function(SuccessMessage)? onSuccess});
}