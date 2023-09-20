import 'package:living_room/model/base/firestore_item.dart';
import 'package:living_room/model/database/datbase_user.dart';

abstract class DatabaseBase {
  Future<FirestoreItem> saveItem({required FirestoreItem firestoreItem, String? documentId});

  Future<DatabaseUser?> getUserById(String uid);

  Stream<DatabaseUser?> streamUserById(String uid);

  Future<List<DatabaseUser>?> getUsers();

  Stream<List<DatabaseUser>?> streamUsers();

  Future<void> setUserProperty(String uid, Map<String, dynamic> json, {Function? onSuccess, Function? onError});
}
