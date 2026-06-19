import 'package:google_contacts_app/core/errors/result.dart';
import 'package:google_contacts_app/domain/entities/contact_entity.dart';
import 'package:google_contacts_app/domain/repositories/i_contact_repository.dart';

class AddContact {
  const AddContact(this._repository);

  final IContactRepository _repository;

  Future<Result<ContactEntity>> call(ContactEntity contact) async {
    final result = await _repository.insertContact(contact);
    return switch (result) {
      Success() => Success(contact),
      Failure(message: final message, exception: final exception) =>
        Failure(message, exception: exception),
    };
  }
}
