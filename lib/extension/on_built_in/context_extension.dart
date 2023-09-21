import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:living_room/screens/base/app_base_screen.dart';
import 'package:living_room/service/authentication/authentication_service.dart';
import 'package:living_room/service/database/database_service.dart';
import 'package:living_room/state/app/navigator_bar_cubit.dart';
import 'package:living_room/state/app/navigator_bar_state.dart';
import 'package:living_room/state/authentication/sign_in_cubit.dart';
import 'package:living_room/state/authentication/sign_in_state.dart';
import 'package:living_room/state/authentication/sign_up_cubit.dart';
import 'package:living_room/state/authentication/sign_up_state.dart';
import 'package:living_room/state/authentication/verify_email_cubit.dart';
import 'package:living_room/state/authentication/verify_email_state.dart';
import 'package:living_room/state/base/app_base_cubit.dart';
import 'package:living_room/state/base/app_base_state.dart';
import 'package:living_room/util/constants.dart';
import 'package:living_room/widgets/default/default_text.dart';

extension ContextExtension on BuildContext {
  void hidePreviousShowNewSnackBar(String message,
      {SnackBarAction? snackBarAction, Duration? duration}) {
    hideCurrentSnackBar().showSnackBar(message,
        snackBarAction: snackBarAction,
        duration: duration ?? const Duration(seconds: 3));
  }

  void showSnackBar(String message,
      {SnackBarAction? snackBarAction,
        Duration duration = const Duration(seconds: 3)}) {
    var snackBar = SnackBar(
      content: DefaultText(
        message,
        textAlign: TextAlign.center,
        color: AppColors.white,
      ),
      action: snackBarAction,
      elevation: 0,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: Constants.borderRadius),
      backgroundColor: AppColors.purple.withOpacity(0.95),
    );
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  BuildContext hideCurrentSnackBar() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    return this;
  }

  AppLocalizations? get loc => AppLocalizations.of(this);

  AppServices get services => AppServices(this);

  AppCubits get cubits => AppCubits(this);

  AppStates get states => AppStates(this);
}

class AppCubits{
  final BuildContext context;

  AppCubits(this.context);

  AppBaseCubit get base => context.read<AppBaseCubit>();

  SignInCubit get signIn => context.read<SignInCubit>();

  SignUpCubit get signUp => context.read<SignUpCubit>();

  VerifyEmailCubit get verifyEmail => context.read<VerifyEmailCubit>();

  NavigatorBarCubit get navigatorBar => context.read<NavigatorBarCubit>();
}

class AppStates{
  final BuildContext context;

  AppStates(this.context);

  AppBaseState get base => context.read<AppBaseCubit>().state;

  SignInState get signIn => context.read<SignInCubit>().state;

  SignUpState get signUp => context.read<SignUpCubit>().state;

  VerifyEmailState get verifyEmail => context.read<VerifyEmailCubit>().state;

  NavigatorBarState get navigatorBar => context.read<NavigatorBarCubit>().state;
}

class AppServices{
  final BuildContext context;

  AppServices(this.context);

  AuthenticationService get authentication => RepositoryProvider.of<AuthenticationService>(context);

  DatabaseService get database => RepositoryProvider.of<DatabaseService>(context);
}
