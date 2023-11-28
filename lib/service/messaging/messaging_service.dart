import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:living_room/service/messaging/base/firebase_messaging.dart';
import 'package:living_room/service/messaging/messaging_base.dart';

class MessagingService {
  //#region Singleton factory
  static final MessagingService _instance = MessagingService._();
  static late MessagingBase _messagingBase;

  MessagingService._();

  factory MessagingService() {
    _messagingBase = MessagingImp();
    return _instance;
  }

  //#endregion

  Future<void> initNotifications({void Function(String?)? onClicked}) => _messagingBase.initNotifications(onClicked: onClicked);

  Future<RemoteMessage?> getInitialMessage() => _messagingBase.getInitialMessage();

  Stream<RemoteMessage> foregroundMessage() => _messagingBase.foregroundMessage();

  Future<String?> getToken() => _messagingBase.getToken();

  Stream<String> get onTokenRefresh => _messagingBase.onTokenRefresh;

  Future<void> subscribeToTopic(String topicId, Function() onDone, Function() onError) =>
      _messagingBase.subscribeToTopic(topicId, onDone, onError);

  Future<void> unsubscribeFromTopic(String topicId, Function() onDone, Function() onError) =>
      _messagingBase.unsubscribeFromTopic(topicId, onDone, onError);
}
