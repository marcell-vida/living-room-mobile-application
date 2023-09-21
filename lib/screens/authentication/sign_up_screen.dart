import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:living_room/extension/on_built_in/context_extension.dart';
import 'package:living_room/screens/base/content_in_card_base_screen.dart';
import 'package:living_room/extension/results/success_message_extension.dart';
import 'package:living_room/extension/results/sign_up_exception_extension.dart';
import 'package:living_room/extension/results/invalid_input_extension.dart';
import 'package:living_room/state/authentication/sign_in_cubit.dart';
import 'package:living_room/state/authentication/sign_in_state.dart';
import 'package:living_room/state/authentication/sign_up_cubit.dart';
import 'package:living_room/state/authentication/sign_up_state.dart';
import 'package:living_room/util/constants.dart';
import 'package:living_room/util/utils.dart';
import 'package:living_room/widgets/default/default_button.dart';
import 'package:living_room/widgets/default/default_input_field.dart';
import 'package:living_room/widgets/default/default_text.dart';
import 'package:living_room/widgets/spacers.dart';

class SignUpScreen extends ContentInCardBaseScreen {
  final _formKey = GlobalKey<FormState>();

  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return BlocProvider<SignUpCubit>(
        create: (_) => SignUpCubit(authenticationService: context.services.authentication, databaseService: context.services.database),
        child: Builder(builder: (context) {
          return BlocListener<SignUpCubit, SignUpState>(
            listenWhen: (previous, current) =>
                previous.signUpStatus != current.signUpStatus,
            listener: (context, state) {
              if (state.signUpStatus == ProcessStatus.successful) {
                context.hidePreviousShowNewSnackBar(
                    state.successMessage?.getMessage(context) ??
                        context.loc?.signUpSuccess ??
                        '');
              } else if (state.signUpStatus == ProcessStatus.unsuccessful &&
                  state.signUpException != null) {
                context.hidePreviousShowNewSnackBar(
                    state.signUpException?.getErrorMessage(context) ??
                        context.loc?.globalExceptionUnknownError ??
                        '');
              } else if (state.signUpStatus == ProcessStatus.processing) {
                context.hidePreviousShowNewSnackBar(
                    context.loc?.globalProcessingRequest ?? '');
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DefaultText(
                    context.loc?.appName ?? '',
                    color: AppColors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                  const VerticalSpacer.of40(),
                  _emailField(context),
                  const VerticalSpacer.of13(),
                  _passwordField(context),
                  const VerticalSpacer.of13(),
                  _passwordAgainField(context),
                  const VerticalSpacer.of40(),
                  _signUpButton(context),
                  const VerticalSpacer.of13(),
                  _signInButton(context),
                ],
              ),
            ),
          );
        }));
  }

  Widget _emailField(BuildContext context) {
    return DefaultInputField(
      callback: (changeTo) => context.cubits.signUp.modifyEmail(changeTo),
      hintText: context.loc?.globalEmail,
      validator: () => context.cubits.signUp.isEmailValid,
      validatorMessage: () =>
          context.states.signUp.invalidEmailMessage?.getErrorMessage(context),
      textInputAction: TextInputAction.next,
    );
  }

  Widget _passwordField(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
        buildWhen: (previous, current) =>
            previous.obscurePassword != current.obscurePassword,
        builder: (context, state) {
          return DefaultInputField(
            initialValue: state.password,
            hintText: context.loc?.globalPassword,
            obscureText: state.obscurePassword,
            obscureIconTap: context.cubits.signUp.toggleObscurePassword,
            callback: (changeTo) =>
                context.cubits.signUp.modifyPassword(changeTo),
            validator: () => context.cubits.signUp.isPasswordValid,
            validatorMessage: () => context.states.signUp.invalidPasswordMessage
                ?.getErrorMessage(context),
            textInputAction: TextInputAction.next,
          );
        });
  }

  Widget _passwordAgainField(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
        buildWhen: (previous, current) =>
        previous.obscurePasswordAgain != current.obscurePasswordAgain,
        builder: (context, state) {
          return DefaultInputField(
            initialValue: state.passwordAgain,
            hintText: context.loc?.globalPasswordAgain,
            obscureText: state.obscurePasswordAgain,
            obscureIconTap: context.cubits.signUp.toggleObscurePasswordAgain,
            callback: (changeTo) =>
                context.cubits.signUp.modifyPasswordAgain(changeTo),
            validator: () => context.cubits.signUp.isPasswordAgainValid,
            validatorMessage: () => context.states.signUp.invalidPasswordAgainMessage
                ?.getErrorMessage(context),
            textInputAction: TextInputAction.done,
          );
        });
  }

  Widget _signUpButton(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
        buildWhen: (previous, current) =>
            previous.signUpStatus != current.signUpStatus,
        builder: (context, state) {
          return DefaultButton(
              text: context.loc?.globalSignUp,
              isLoading: state.signUpStatus == ProcessStatus.processing,
              isEnabled: state.signUpStatus != ProcessStatus.processing,
              color: AppColors.purple,
              showErrorColor: state.signUpStatus == ProcessStatus.unsuccessful,
              callback: () async => {
                    if (_formKey.currentState!.validate())
                      {context.cubits.signUp.signUpWithEmailAndPassword()}
                  });
        });
  }

  Widget _signInButton(BuildContext context) {
    return DefaultButton(
        elevation: 0,
        text: context.loc?.globalSignIn,
        color: AppColors.white.withOpacity(0.15),
        borderColor: AppColors.whiteOp30,
        textColor: AppColors.purple,
        callback: () => Navigator.of(context).pop());
  }
}
