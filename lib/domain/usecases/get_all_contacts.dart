import 'package:google_contacts_app/core/errors/result.dart';
import 'package:google_contacts_app/domain/entities/contact_entity.dart';
import 'package:google_contacts_app/domain/repositories/i_contact_repository.dart';

class GetAllContacts {
  const GetAllContacts(this._repository);

  final IContactRepository _repository;

  Future<Result<List<ContactEntity>>> call() {
    return _repository.getAllContacts();
  }
}
