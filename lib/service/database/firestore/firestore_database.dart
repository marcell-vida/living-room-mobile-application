import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:living_room/extension/firebase/firestore_extension.dart';
import 'package:living_room/extension/results/database_exception_extension.dart';
import 'package:living_room/model/base/firestore_item.dart';
import 'package:living_room/model/database/datbase_user.dart';
import 'package:living_room/service/database/database_base.dart';

class DatabaseImp extends DatabaseBase {
  //#region Singleton factory
  static final DatabaseImp _instance = DatabaseImp._();

  DatabaseImp._();

  factory DatabaseImp() {
    return _instance;
  }

  //#endregion

  final rawDatabaseExceptions = {
    "permission-denied": DatabaseException.permissionDenied,
  };

  FirebaseFirestore get _firestoreInstance {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    firebaseFirestore.settings = const Settings(persistenceEnabled: false);
    return firebaseFirestore;
  }

  CollectionReference collection(String path) {
    return _firestoreInstance.collection(path);
  }

  DocumentReference document(String path) {
    return _firestoreInstance.doc(path);
  }

  Query collectionGroup(String path) {
    return _firestoreInstance.collectionGroup(path);
  }

  @override
  Future<FirestoreItem> saveItem(
      {required FirestoreItem firestoreItem, String? documentId}) async {
    assert(documentId == null || documentId.isNotEmpty);
    if (firestoreItem.documentReference == null) {
      var coll = collection(firestoreItem.collectionPath);
      if (documentId != null) {
        firestoreItem.documentReference = coll.doc(documentId);
        await firestoreItem.documentReference?.set(firestoreItem.toJson);
      } else {
        firestoreItem.documentReference = await coll.add(firestoreItem.toJson);
      }
    } else {
      await firestoreItem.documentReference
          ?.set(firestoreItem.toJson, SetOptions(merge: true));
    }
    return firestoreItem;
  }

  //#region Users
  @override
  Stream<List<DatabaseUser>?> streamUsers() {
    return collection(userCollectionPath).snapshots().asyncMap((event) {
      return event
          .data()
          ?.entries
          .map((entry) => DatabaseUser.fromSnapshot(entry))
          .toList();
    });
  }

  @override
  Future<void> setUserProperty(String uid, Map<String, dynamic> json, {Function? onSuccess, Function? onError}) async {
    return await document("$userCollectionPath/$uid")
        .set(json, SetOptions(merge: true)).then((_) => onSuccess?.call(), onError: (e) {
          debugPrint('setUserProperty: error: $e');
      onError?.call();
    });
  }

  @override
  Future<List<DatabaseUser>?> getUsers() async {
    var snapshot = await collection(userCollectionPath).get();
    return snapshot
        .data()
        ?.entries
        .map((entry) => DatabaseUser.fromSnapshot(entry))
        .toList();
  }

  @override
  Future<DatabaseUser?> getUserById(String uid) async {
    var data = await document("$userCollectionPath/$uid").get();
    var doc = data.document();
    return doc != null ? DatabaseUser.fromSnapshot(doc) : null;
  }

  @override
  Stream<DatabaseUser?> streamUserById(String uid) {
    return document("$userCollectionPath/$uid").snapshots().asyncMap((event) {
      var documentMapEntry = event.document();
      return documentMapEntry != null
          ? DatabaseUser.fromSnapshot(documentMapEntry)
          : null;
    });
  }

  //#endregion
}
