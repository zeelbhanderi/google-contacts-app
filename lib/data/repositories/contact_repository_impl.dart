import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_contacts_app/core/errors/exceptions.dart';
import 'package:google_contacts_app/core/errors/result.dart';
import 'package:google_contacts_app/data/datasources/local/contact_local_datasource.dart';
import 'package:google_contacts_app/data/datasources/remote/contact_remote_datasource.dart';
import 'package:google_contacts_app/data/models/contact_model.dart';
import 'package:google_contacts_app/domain/entities/contact_entity.dart';
import 'package:google_contacts_app/domain/repositories/i_contact_repository.dart';

class ContactRepositoryImpl implements IContactRepository {
  ContactRepositoryImpl({
    required IContactLocalDatasource localDatasource,
    required IContactRemoteDatasource remoteDatasource,
    required Connectivity connectivity,
  })  : _localDatasource = localDatasource,
        _remoteDatasource = remoteDatasource,
        _connectivity = connectivity;

  final IContactLocalDatasource _localDatasource;
  final IContactRemoteDatasource _remoteDatasource;
  final Connectivity _connectivity;

  @override
  Future<Result<List<ContactEntity>>> getAllContacts() async {
    try {
      final contacts = await _localDatasource.getAllContacts();
      if (await _isOnline()) {
        unawaited(_syncPending());
      }
      return Success(contacts.map((contact) => contact.toEntity()).toList());
    } on Exception catch (error) {
      return Failure(_failureMessage(error), exception: error);
    } catch (error) {
      return Failure(error.toString());
    }
  }

  @override
  Future<Result<ContactEntity?>> getContactById(String id) async {
    try {
      final contact = await _localDatasource.getContactById(id);
      return Success(contact?.toEntity());
    } on Exception catch (error) {
      return Failure(_failureMessage(error), exception: error);
    } catch (error) {
      return Failure(error.toString());
    }
  }

  @override
  Future<Result<List<ContactEntity>>> searchContacts(String query) async {
    try {
      final contacts = await _localDatasource.searchContacts(query);
      return Success(contacts.map((contact) => contact.toEntity()).toList());
    } on Exception catch (error) {
      return Failure(_failureMessage(error), exception: error);
    } catch (error) {
      return Failure(error.toString());
    }
  }

  @override
  Future<Result<List<ContactEntity>>> getFavorites() async {
    try {
      final contacts = await _localDatasource.getFavorites();
      return Success(contacts.map((contact) => contact.toEntity()).toList());
    } on Exception catch (error) {
      return Failure(_failureMessage(error), exception: error);
    } catch (error) {
      return Failure(error.toString());
    }
  }

  @override
  Future<Result<List<ContactEntity>>> getUnsynced() async {
    try {
      final contacts = await _localDatasource.getUnsynced();
      return Success(contacts.map((contact) => contact.toEntity()).toList());
    } on Exception catch (error) {
      return Failure(_failureMessage(error), exception: error);
    } catch (error) {
      return Failure(error.toString());
    }
  }

  @override
  Future<Result<Unit>> insertContact(ContactEntity contact) async {
    try {
      final model = _toUnsyncedModel(contact);
      await _localDatasource.insertContact(model);
      if (await _isOnline()) {
        await _remoteDatasource.upsertContact(model);
        await _localDatasource.markSynced(model.id);
      }
      return const Success(Unit.value);
    } on Exception catch (error) {
      return Failure(_failureMessage(error), exception: error);
    } catch (error) {
      return Failure(error.toString());
    }
  }

  @override
  Future<Result<Unit>> updateContact(ContactEntity contact) async {
    try {
      final model = _toUnsyncedModel(contact);
      await _localDatasource.updateContact(model);
      if (await _isOnline()) {
        await _remoteDatasource.upsertContact(model);
        await _localDatasource.markSynced(model.id);
      }
      return const Success(Unit.value);
    } on Exception catch (error) {
      return Failure(_failureMessage(error), exception: error);
    } catch (error) {
      return Failure(error.toString());
    }
  }

  @override
  Future<Result<Unit>> deleteContact(String id) async {
    try {
      await _localDatasource.deleteContact(id);
      if (await _isOnline()) {
        await _remoteDatasource.deleteContact(id);
      }
      return const Success(Unit.value);
    } on Exception catch (error) {
      return Failure(_failureMessage(error), exception: error);
    } catch (error) {
      return Failure(error.toString());
    }
  }

  @override
  Future<Result<Unit>> markSynced(String id) async {
    try {
      await _localDatasource.markSynced(id);
      return const Success(Unit.value);
    } on Exception catch (error) {
      return Failure(_failureMessage(error), exception: error);
    } catch (error) {
      return Failure(error.toString());
    }
  }

  @override
  Future<Result<Unit>> toggleFavorite(String id, bool value) async {
    try {
      await _localDatasource.toggleFavorite(id, value);
      if (await _isOnline()) {
        final contact = await _localDatasource.getContactById(id);
        if (contact != null) {
          await _remoteDatasource.upsertContact(contact);
          await _localDatasource.markSynced(id);
        }
      }
      return const Success(Unit.value);
    } on Exception catch (error) {
      return Failure(_failureMessage(error), exception: error);
    } catch (error) {
      return Failure(error.toString());
    }
  }

  Future<void> _syncPending() async {
    try {
      if (!await _isOnline()) {
        return;
      }

      final unsyncedContacts = await _localDatasource.getUnsynced();
      for (final contact in unsyncedContacts) {
        try {
          await _remoteDatasource.upsertContact(contact);
          await _localDatasource.markSynced(contact.id);
        } on Exception {
          continue;
        }
      }
    } on Exception {
      return;
    }
  }

  Future<bool> _isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  ContactModel _toUnsyncedModel(ContactEntity contact) {
    final model = ContactModel.fromEntity(contact);
    return ContactModel(
      id: model.id,
      firstName: model.firstName,
      lastName: model.lastName,
      nickname: model.nickname,
      phone: model.phone,
      email: model.email,
      company: model.company,
      jobTitle: model.jobTitle,
      department: model.department,
      websiteUrls: model.websiteUrls,
      birthday: model.birthday,
      notes: model.notes,
      isFavorite: model.isFavorite,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  String _failureMessage(Exception error) {
    if (error is DatabaseException) {
      return error.message;
    }
    if (error is RemoteException) {
      return error.message;
    }
    return error.toString();
  }

  @override
  Future<Result<Unit>> syncRemoteContactsToLocal() async {
    try {
      if (!await _isOnline()) {
        return const Success(Unit.value);
      }

      final hasRemote = await _remoteDatasource.hasRemoteContacts();
      if (!hasRemote) {
        return const Success(Unit.value);
      }

      final remoteContacts = await _remoteDatasource.fetchAllContacts();
      for (final contact in remoteContacts) {
        await _localDatasource.upsertContact(contact);
      }
      return const Success(Unit.value);
    } on Exception catch (error) {
      return Failure(_failureMessage(error), exception: error);
    } catch (error) {
      return Failure(error.toString());
    }
  }

  @override
  Future<Result<Unit>> clearAllLocalContacts() async {
    try {
      await _localDatasource.clearAllContacts();
      return const Success(Unit.value);
    } on Exception catch (error) {
      return Failure(_failureMessage(error), exception: error);
    } catch (error) {
      return Failure(error.toString());
    }
  }
}
