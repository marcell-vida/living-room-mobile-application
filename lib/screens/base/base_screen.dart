import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:living_room/extension/on_built_in/navigator_state_extension.dart';
import 'package:living_room/state/base/app_base_cubit.dart';
import 'package:living_room/state/base/app_base_state.dart';

/// This screen provides tha basic functions of the application.
///
/// If the user state changes, or a network error occurs, this screen handles it
/// by navigating to the correct screen. Because this screen is the parent of
/// every other one it will always have the sufficient resources.
abstract class AppBaseScreen extends StatelessWidget {
  const AppBaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          // user signs in, -out, -up or other changes occur
          BlocListener<AppBaseCubit, AppBaseState>(
            listenWhen: (previous, current) =>
                previous.currentUserStatus != current.currentUserStatus,
            listener: (context, state) async {
              debugPrint(
                  'BaseScreen: state.authenticationState == ${state.currentUserStatus}');
              debugPrint(
                  'BaseScreen: state.internetConnectivityState == ${state.networkConnectionStatus}');

              if (state.currentUserStatus == null) {
                Navigator.of(context).pushReplacementNamed('/');
              } else if (state.currentUserStatus ==
                  CurrentUserStatus.signedInEmailNotVerified) {
                Navigator.of(context).pushReplacementNamed('/verify');
              } else if (state.currentUserStatus ==
                  CurrentUserStatus.signedIn) {
                // navigate to home
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (route) => false);
                }
              } else if (state.currentUserStatus ==
                  CurrentUserStatus.signedOut) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              } else if (state.currentUserStatus ==
                  CurrentUserStatus.userBanned) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/banned', (route) => false);
              } else {
                Navigator.of(context).pushNamed('/wrong');
              }
            },
          ),
          // network connection status changes
          BlocListener<AppBaseCubit, AppBaseState>(
            listenWhen: (previous, current) =>
                previous.networkConnectionStatus !=
                current.networkConnectionStatus,
            listener: (context, state) {
              debugPrint(
                  'BaseScreen: state.authenticationState == ${state.currentUserStatus}');
              debugPrint(
                  'BaseScreen: state.internetConnectivityState == ${state.networkConnectionStatus}');

              if (state.networkConnectionStatus ==
                  NetworkConnectionStatus.connectedNoInternet) {
                Navigator.of(context).pushNamedIfNotCurrent('/no_connection');
              } else if (state.networkConnectionStatus ==
                  NetworkConnectionStatus.notConnected) {
                Navigator.of(context).pushNamedIfNotCurrent('/no_connection');
              }
            },
          ),
        ],
        child: MultiBlocProvider(
            providers: [...?providers(context)],
            child: Builder(builder: (context) {
              return Scaffold(body: SafeArea(child: body(context)));
            })));
  }

  Widget body(BuildContext context);

  List<BlocProvider>? providers(BuildContext context);
}
