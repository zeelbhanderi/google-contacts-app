import 'package:google_contacts_app/core/errors/result.dart';
import 'package:google_contacts_app/domain/repositories/i_contact_repository.dart';

class DeleteContact {
  const DeleteContact(this._repository);

  final IContactRepository _repository;

  Future<Result<Unit>> call(String id) {
    return _repository.deleteContact(id);
  }
}
