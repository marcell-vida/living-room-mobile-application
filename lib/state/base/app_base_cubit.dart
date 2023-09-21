import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:living_room/model/authentication/auth_user.dart';
import 'package:living_room/model/database/datbase_user.dart';
import 'package:living_room/service/authentication/authentication_service.dart';
import 'package:living_room/service/database/database_service.dart';
import 'package:living_room/state/base/app_base_state.dart';

/// This [Cubit] manages the basic functions and states of the app.
///
/// The changes, that have effect on every screen happen here, or get
/// tracked down here.
class AppBaseCubit extends Cubit<AppBaseState> {
  final AuthenticationService _authenticationService;
  final DatabaseService _databaseService;
  StreamSubscription? _connectivitySubscription;
  StreamSubscription? _internetSubscription;
  StreamSubscription? _currentUserSubscription;
  StreamSubscription? _currentDbUserStreamSubscription;

  AppBaseCubit(
      {required AuthenticationService authenticationService,
      required DatabaseService databaseService})
      : _authenticationService = authenticationService,
        _databaseService = databaseService,
        super(const AppBaseState()) {
    _init();
  }

  Future<void> _init() async {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      _setNetworkConnectionStatus(
          result, await InternetConnectionChecker().hasConnection);
    });

    InternetConnectionChecker.createInstance(
        checkInterval: const Duration(seconds: 1));

    _internetSubscription =
        InternetConnectionChecker().onStatusChange.listen((status) async {
      debugPrint('BaseCubit: InternetConnectionChecker().onStatusChange');
      _setNetworkConnectionStatus(await Connectivity().checkConnectivity(),
          status == InternetConnectionStatus.connected);
    });

    _currentUserSubscription =
        _authenticationService.authStateChange.listen(_setCurrentUserStatus);

    _setDbUserStreamSubscription(_authenticationService.currentUser);

    if (state.networkConnectionStatus == null) {
      _setNetworkConnectionStatus(await Connectivity().checkConnectivity(),
          await InternetConnectionChecker().hasConnection);
    }
  }

  Future<DatabaseUser?> get getCurrentDbUser async {
    String? uid = _authenticationService.currentUser?.uid;
    if (uid == null) return null;
    return await _databaseService.getUserById(uid: uid);
  }

  Future<void> fetchNetworkStatuses() async {
    emit(state.copyWith(
        connectionFetchStatus: ConnectionFetchStatus.processing));
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    bool hasInternet = await InternetConnectionChecker().hasConnection;

    await _setNetworkConnectionStatus(connectivityResult, hasInternet);
    emit(state.copyWith(connectionFetchStatus: ConnectionFetchStatus.initial));
  }

  Future<void> _setDbUserStreamSubscription(AuthUser? currentUser) async {
    if (currentUser == null) {
      await _currentDbUserStreamSubscription?.cancel();
      _currentDbUserStreamSubscription = null;
    } else if (_currentDbUserStreamSubscription == null &&
        currentUser.uid != null) {
      _currentDbUserStreamSubscription = _databaseService
          .streamUserById(_authenticationService.currentUser!.uid!)
          .listen((event) {
        _setCurrentUserStatus(_authenticationService.currentUser);
      });
    }
  }

  Future<void> _setCurrentUserStatus(AuthUser? currentUser) async {
    _setDbUserStreamSubscription(currentUser);
    if (currentUser == null) {
      emit(state.copyWith(currentUserStatus: CurrentUserStatus.signedOut));
    } else if (currentUser.isEmailVerified == false) {
      emit(state.copyWith(
          currentUserStatus: CurrentUserStatus.signedInEmailNotVerified));
    } else {
      var databaseUser = await getCurrentDbUser;
      if (databaseUser?.isBanned == true) {
        emit(state.copyWith(currentUserStatus: CurrentUserStatus.userBanned));
      } else {
        emit(state.copyWith(currentUserStatus: CurrentUserStatus.signedIn));
      }
    }
  }

  Future<void> _setNetworkConnectionStatus(
      ConnectivityResult connectivityResult, bool hasInternet) async {
    if (connectivityResult == ConnectivityResult.none) {
      emit(state.copyWith(
          networkConnectionStatus: NetworkConnectionStatus.notConnected));
    } else {
      if (hasInternet) {
        emit(state.copyWith(
            networkConnectionStatus: NetworkConnectionStatus.connected));
      } else {
        emit(state.copyWith(
            networkConnectionStatus:
                NetworkConnectionStatus.connectedNoInternet));
      }
    }
    if (state.currentUserStatus == null) {
      _setCurrentUserStatus(_authenticationService.currentUser);
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _internetSubscription?.cancel();
    _currentUserSubscription?.cancel();
    _currentDbUserStreamSubscription?.cancel();
    return super.close();
  }
}
