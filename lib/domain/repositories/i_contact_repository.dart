import 'package:google_contacts_app/core/errors/result.dart';
import 'package:google_contacts_app/domain/entities/contact_entity.dart';

abstract class IContactRepository {
  Future<Result<List<ContactEntity>>> getAllContacts();

  Future<Result<ContactEntity?>> getContactById(String id);

  Future<Result<List<ContactEntity>>> searchContacts(String query);

  Future<Result<List<ContactEntity>>> getFavorites();

  Future<Result<List<ContactEntity>>> getUnsynced();

  Future<Result<Unit>> insertContact(ContactEntity contact);

  Future<Result<Unit>> updateContact(ContactEntity contact);

  Future<Result<Unit>> deleteContact(String id);

  Future<Result<Unit>> markSynced(String id);

  Future<Result<Unit>> toggleFavorite(String id, bool value);

  Future<Result<Unit>> syncRemoteContactsToLocal();

  Future<Result<Unit>> clearAllLocalContacts();
}
