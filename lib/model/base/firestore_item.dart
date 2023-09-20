import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreItem{
  String? rawId;

  String? get id => documentReference?.id ?? rawId;

  DocumentReference? documentReference;

  FirestoreItem({this.rawId});

  FirestoreItem.doc(this.documentReference);

  String get collectionPath;

  Map<String, dynamic> get toJson;
}