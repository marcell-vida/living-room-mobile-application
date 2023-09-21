import 'package:equatable/equatable.dart';

enum NetworkConnectionStatus {
  notConnected,
  connected,
  connectedNoInternet
}

enum CurrentUserStatus {
  userBanned,
  signedOut,
  signedIn,
  signedInEmailNotVerified
}

enum ConnectionFetchStatus { initial, processing }

class AppBaseState extends Equatable {
  final CurrentUserStatus? currentUserStatus;
  final NetworkConnectionStatus? networkConnectionStatus;
  final ConnectionFetchStatus connectionFetchStatus;
  final String? fcmToken;

  const AppBaseState(
      {this.currentUserStatus,
        this.networkConnectionStatus,
        this.connectionFetchStatus = ConnectionFetchStatus.initial,
        this.fcmToken});

  AppBaseState copyWith(
      {CurrentUserStatus? currentUserStatus,
        NetworkConnectionStatus? networkConnectionStatus,
        ConnectionFetchStatus? connectionFetchStatus,
        String? fcmToken}) {
    return AppBaseState(
        currentUserStatus: currentUserStatus ?? this.currentUserStatus,
        networkConnectionStatus:
        networkConnectionStatus ?? this.networkConnectionStatus,
        connectionFetchStatus:
        connectionFetchStatus ?? this.connectionFetchStatus,
        fcmToken: fcmToken ?? this.fcmToken);
  }

  @override
  List<Object?> get props => [
    currentUserStatus,
    networkConnectionStatus,
    connectionFetchStatus,
    fcmToken,
  ];
}
