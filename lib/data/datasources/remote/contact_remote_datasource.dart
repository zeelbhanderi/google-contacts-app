import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_contacts_app/core/constants/app_constants.dart';
import 'package:google_contacts_app/core/errors/exceptions.dart';
import 'package:google_contacts_app/data/models/contact_model.dart';

abstract class IContactRemoteDatasource {
  Future<void> upsertContact(ContactModel contact);

  Future<void> deleteContact(String id);

  Future<List<ContactModel>> fetchAllContacts();

  Future<bool> hasRemoteContacts();
}

class ContactRemoteDatasourceImpl implements IContactRemoteDatasource {
  ContactRemoteDatasourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _contactsCollection {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw const RemoteException('No signed-in user');
    }
    return _firestore.collection('users').doc(uid).collection('contacts');
  }

  @override
  Future<void> upsertContact(ContactModel contact) async {
    try {
      await _runRemote(
        _contactsCollection
            .doc(contact.id)
            .set(contact.toJson(), SetOptions(merge: true)),
      );
    } catch (error) {
      throw RemoteException('Failed to save contact remotely', cause: error);
    }
  }

  @override
  Future<void> deleteContact(String id) async {
    try {
      await _runRemote(_contactsCollection.doc(id).delete());
    } catch (error) {
      throw RemoteException('Failed to delete contact remotely', cause: error);
    }
  }

  @override
  Future<List<ContactModel>> fetchAllContacts() async {
    try {
      final snapshot = await _runRemote(_contactsCollection.get());
      return snapshot.docs.map(_contactFromDocument).toList();
    } catch (error) {
      throw RemoteException('Failed to fetch remote contacts', cause: error);
    }
  }

  @override
  Future<bool> hasRemoteContacts() async {
    try {
      final snapshot = await _runRemote(_contactsCollection.limit(1).get());
      return snapshot.docs.isNotEmpty;
    } catch (error) {
      throw RemoteException('Failed to check remote contacts', cause: error);
    }
  }

  Future<T> _runRemote<T>(Future<T> request) {
    return request.timeout(
      AppConstants.remoteSyncTimeout,
      onTimeout: () => throw RemoteException('Remote request timed out'),
    );
  }

  ContactModel _contactFromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = Map<String, dynamic>.from(doc.data());
    data['id'] = doc.id;
    data['is_synced'] = true;
    return ContactModel.fromJson(data);
  }
}
