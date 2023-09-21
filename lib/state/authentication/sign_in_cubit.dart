import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:living_room/extension/results/invalid_input_extension.dart';
import 'package:living_room/model/authentication/auth_user.dart';
import 'package:living_room/service/authentication/authentication_service.dart';
import 'package:living_room/state/authentication/sign_in_state.dart';
import 'package:living_room/util/utils.dart';

class SignInCubit extends Cubit<SignInState> {
  final AuthenticationService _authenticationService;

  SignInCubit(this._authenticationService) : super(const SignInState());

  bool? get isEmailValid => state.isEmailValid;

  bool? get isPasswordValid => state.isPasswordValid;

  AuthUser? get currentUser {
    debugPrint('Current user is: ${_authenticationService.currentUser?.email}');
    return _authenticationService.currentUser;
  }

  void toggleObscurePassword() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void modifyEmail(String newValue) {
    emit(state.copyWith(email: newValue, signInStatus: ProcessStatus.idle));
    _validateEmail();
  }

  void modifyPassword(String newValue) {
    emit(state.copyWith(password: newValue, signInStatus: ProcessStatus.idle));
    _validatePassword();
  }

  void signInWithEmailAndPassword() async {
    if (state.isEmailValid &&
        state.isPasswordValid &&
        state.signInStatus != ProcessStatus.processing) {
      emit(state.copyWith(signInStatus: ProcessStatus.processing));

      _authenticationService.signIn(
          email: state.email,
          password: state.password,
          onError: (errorMessage) {
            emit(state.copyWith(
                authException: errorMessage,
                signInStatus: ProcessStatus.unsuccessful));
          },
          onSuccess: () {
            emit(state.copyWith(signInStatus: ProcessStatus.successful));
          });
    }
  }

  void _validateEmail() {
    bool isValid = Utils.isEmailFormatValid(state.email);
    InvalidInput? invalidInput;

    if (state.email.isEmpty) {
      invalidInput = InvalidInput.emptyInput;
    } else if (!isValid) {
      invalidInput = InvalidInput.invalidEmail;
    }

    emit(state.copyWith(
        isEmailValid: isValid,
        invalidEmailMessage: invalidInput,
        signInStatus: ProcessStatus.idle));
  }

  void _validatePassword() {
    bool isValid = Utils.isPasswordFormatValid(state.password);
    InvalidInput? invalidInput;

    if (state.password.isEmpty) {
      invalidInput = InvalidInput.emptyInput;
    } else if (!isValid) {
      invalidInput = InvalidInput.invalidPassword;
    }

    emit(state.copyWith(
        isPasswordValid: isValid,
        invalidPasswordMessage: invalidInput,
        signInStatus: ProcessStatus.idle));
  }
}
