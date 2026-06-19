import 'package:google_contacts_app/core/errors/result.dart';
import 'package:google_contacts_app/domain/repositories/i_contact_repository.dart';

class ClearAllLocalContacts {
  const ClearAllLocalContacts(this._repository);

  final IContactRepository _repository;

  Future<Result<Unit>> call() => _repository.clearAllLocalContacts();
}
