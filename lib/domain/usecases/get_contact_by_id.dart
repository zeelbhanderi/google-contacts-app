import 'package:google_contacts_app/core/errors/result.dart';
import 'package:google_contacts_app/domain/entities/contact_entity.dart';
import 'package:google_contacts_app/domain/repositories/i_contact_repository.dart';

class GetContactById {
  const GetContactById(this._repository);

  final IContactRepository _repository;

  Future<Result<ContactEntity>> call(String id) async {
    final result = await _repository.getContactById(id);
    return switch (result) {
      Success(data: final contact) when contact != null => Success(contact),
      Success() => const Failure('Contact not found'),
      Failure(message: final message, exception: final exception) =>
        Failure(message, exception: exception),
    };
  }
}
