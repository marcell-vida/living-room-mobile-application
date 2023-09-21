import 'package:bloc/bloc.dart';
import 'package:living_room/extension/results/invalid_input_extension.dart';
import 'package:living_room/service/authentication/authentication_service.dart';
import 'package:living_room/service/database/database_service.dart';
import 'package:living_room/state/authentication/sign_up_state.dart';
import 'package:living_room/util/utils.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthenticationService _authenticationService;
  final DatabaseService _databaseService;

  SignUpCubit(
      {required AuthenticationService authenticationService,
      required DatabaseService databaseService})
      : _authenticationService = authenticationService,
        _databaseService = databaseService,
        super(const SignUpState());

  bool? get isEmailValid => state.isEmailValid;

  bool? get isPasswordValid => state.isPasswordValid;

  bool? get isPasswordAgainValid => state.isPasswordAgainValid;

  void toggleObscurePassword() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void toggleObscurePasswordAgain() {
    emit(state.copyWith(obscurePasswordAgain: !state.obscurePasswordAgain));
  }

  void modifyEmail(String newValue) {
    emit(state.copyWith(email: newValue, signUpStatus: ProcessStatus.idle));
    _validateEmail();
  }

  void modifyPassword(String newValue) {
    emit(state.copyWith(password: newValue, signUpStatus: ProcessStatus.idle));

    _validatePassword();
    _validatePasswordAgain();
  }

  void modifyPasswordAgain(String newValue) {
    emit(state.copyWith(
        passwordAgain: newValue, signUpStatus: ProcessStatus.idle));

    _validatePasswordAgain();
  }

  void _validateEmail() {
    bool isValid = Utils.isEmailFormatValid(state.email);
    InvalidInput? invalidMessage;

    if (state.email.isEmpty) {
      invalidMessage = InvalidInput.emptyInput;
    } else if (!isValid) {
      invalidMessage = InvalidInput.invalidEmail;
    }

    emit(state.copyWith(
        isEmailValid: isValid,
        invalidEmailMessage: invalidMessage,
        signUpStatus: ProcessStatus.idle));
  }

  void _validatePassword() {
    bool isValid = Utils.isPasswordFormatValid(state.password);
    InvalidInput? invalidMessage;

    if (state.password.isEmpty) {
      invalidMessage = InvalidInput.emptyInput;
    } else if (!isValid) {
      invalidMessage = InvalidInput.invalidPassword;
    }

    emit(state.copyWith(
        isPasswordValid: isValid,
        invalidPasswordMessage: invalidMessage,
        signUpStatus: ProcessStatus.idle));
  }

  void _validatePasswordAgain() {
    bool isValid = Utils.isPasswordFormatValid(state.passwordAgain);
    InvalidInput? invalidMessage = state.invalidPasswordAgainMessage;

    if (state.passwordAgain.isEmpty) {
      invalidMessage = InvalidInput.emptyInput;
    } else if (state.password != state.passwordAgain) {
      isValid = false;
      invalidMessage = InvalidInput.passwordsNotMatch;
    } else if (!isValid) {
      invalidMessage = InvalidInput.invalidPassword;
    }

    emit(state.copyWith(
        isPasswordAgainValid: isValid,
        invalidPasswordAgainMessage: invalidMessage,
        signUpStatus: ProcessStatus.idle));
  }

  void signUpWithEmailAndPassword() async {
    if (state.isEmailValid &&
        state.isPasswordValid &&
        state.isPasswordAgainValid &&
        state.signUpStatus != ProcessStatus.processing) {
      emit(state.copyWith(signUpStatus: ProcessStatus.processing));
      _authenticationService.signUp(
          email: state.email,
          password: state.password,
          onError: (errorMessage) {
            emit(state.copyWith(
                signUpException: errorMessage,
                signUpStatus: ProcessStatus.unsuccessful));
          },
          onSuccess: (successMessage) async {
            await _databaseService.initializeCurrentUser(
                authenticationService: _authenticationService);

            emit(state.copyWith(
                successMessage: successMessage,
                signUpStatus: ProcessStatus.successful));
          });
    }
  }
}
