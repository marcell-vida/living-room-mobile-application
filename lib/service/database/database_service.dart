import 'package:living_room/model/authentication/auth_user.dart';
import 'package:living_room/model/base/firestore_item.dart';
import 'package:living_room/model/database/datbase_user.dart';
import 'package:living_room/service/authentication/authentication_service.dart';
import 'package:living_room/service/database/database_base.dart';
import 'package:living_room/service/database/firestore/firestore_database.dart';
import 'package:living_room/util/utils.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._();
  static late DatabaseBase _database;

  DatabaseService._();

  factory DatabaseService() {
    _database = DatabaseImp();
    return _instance;
  }

  Future<FirestoreItem> saveItem(
      {required FirestoreItem firestoreItem, String? documentId}) {
    return _database.saveItem(
        firestoreItem: firestoreItem, documentId: documentId);
  }

  //#region Users
  Future<DatabaseUser?> getUserById({required String uid}) {
    return _database.getUserById(uid);
  }

  Stream<DatabaseUser?> streamUserById(String uid) {
    return _database.streamUserById(uid);
  }

  void createCurrentUser(AuthenticationService authenticationService) {
    var authUser = authenticationService.currentUser;
    if (authUser != null) {
      saveItem(
          firestoreItem: DatabaseUser.fromAuthUser(authUser),
          documentId: authUser.uid);
    }
  }

  Future<List<DatabaseUser>?> getUsers() {
    return _database.getUsers();
  }

  Stream<List<DatabaseUser>?> streamUsers() {
    return _database.streamUsers();
  }

  Future<void> initializeCurrentUser(
      {required AuthenticationService authenticationService,
      Function? onSuccess,
      Function? onError}) async {
    AuthUser? currentUser = authenticationService.currentUser;
    if (currentUser?.uid != null) {
      await _database.setUserProperty(
          currentUser!.uid!,
          {
            userDocumentDisplayNameField: currentUser.email != null
                ? Utils.userNameFromEmail(currentUser.email!)
                : '',
            userDocumentEmailField: currentUser.email,
            userDocumentPhotoUrlField: null,
            userDocumentIsBannedField: false,
            userDocumentIsArchiveField: false,
            userDocumentInvitationsField: null,
            userDocumentCreationDateField: DateTime.now(),
          },
          onSuccess: onSuccess,
          onError: onError);
    } else {
      onError?.call();
    }
  }

  Future<void> changeCurrentUserDisplayName(
      {required AuthenticationService authenticationService,
      required String displayName,
      Function? onSuccess,
      Function? onError}) async {
    var currentUserId = authenticationService.currentUser?.uid;
    if (currentUserId != null) {
      await _database.setUserProperty(
          currentUserId, {userDocumentDisplayNameField: displayName},
          onSuccess: onSuccess);
    }
  }

  Future<void> changeCurrentUserPhotoUrl(
      {required AuthenticationService authenticationService,
      String? photoUrl,
      Function? onSuccess,
      Function? onError}) async {
    var currentUserId = authenticationService.currentUser?.uid;
    if (currentUserId != null) {
      await _database.setUserProperty(
          currentUserId, {userDocumentPhotoUrlField: photoUrl},
          onSuccess: onSuccess, onError: onError);
    }
  }

  Future<void> changeCurrentUserFcmToken(
      {required AuthenticationService authenticationService,
      required String? token,
      Function? onSuccess,
      Function? onError}) async {
    var currentUserId = authenticationService.currentUser?.uid;
    if (currentUserId != null) {
      await _database.setUserProperty(
          currentUserId, {userDocumentFcmTokenField: token},
          onSuccess: onSuccess, onError: onError);
    }
  }

  Future<void> changeCurrentUserGeneralNotifications(
      {required AuthenticationService authenticationService,
      required bool generalNotifications,
      Function? onSuccess,
      Function? onError}) async {
    var currentUserId = authenticationService.currentUser?.uid;
    if (currentUserId != null) {
      await _database.setUserProperty(currentUserId,
          {userDocumentGeneralNotificationsField: generalNotifications},
          onSuccess: onSuccess, onError: onError);
    }
  }

//#endregion
}
