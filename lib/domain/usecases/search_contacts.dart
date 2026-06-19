import 'package:google_contacts_app/core/errors/result.dart';
import 'package:google_contacts_app/domain/entities/contact_entity.dart';
import 'package:google_contacts_app/domain/repositories/i_contact_repository.dart';

class SearchContacts {
  const SearchContacts(this._repository);

  final IContactRepository _repository;

  Future<Result<List<ContactEntity>>> call(String query) {
    return _repository.searchContacts(query);
  }
}
