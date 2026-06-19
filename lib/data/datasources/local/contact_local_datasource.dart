import 'dart:convert';

import 'package:google_contacts_app/core/errors/exceptions.dart';
import 'package:google_contacts_app/core/utils/date_utils.dart';
import 'package:google_contacts_app/data/datasources/local/db_helper.dart';
import 'package:google_contacts_app/data/models/contact_model.dart';

abstract class IContactLocalDatasource {
  Future<List<ContactModel>> getAllContacts();

  Future<ContactModel?> getContactById(String id);

  Future<List<ContactModel>> searchContacts(String query);

  Future<List<ContactModel>> getFavorites();

  Future<List<ContactModel>> getUnsynced();

  Future<void> insertContact(ContactModel contact);

  Future<void> updateContact(ContactModel contact);

  Future<void> deleteContact(String id);

  Future<void> markSynced(String id);

  Future<void> toggleFavorite(String id, bool value);

  Future<void> upsertContact(ContactModel contact);

  Future<void> clearAllContacts();
}

class ContactLocalDatasourceImpl implements IContactLocalDatasource {
  ContactLocalDatasourceImpl({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  static const String _contactsTable = 'contacts';

  @override
  Future<List<ContactModel>> getAllContacts() {
    return _run(() async {
      final db = await _dbHelper.database;
      final rows = await db.query(
        _contactsTable,
        orderBy: 'first_name ASC, last_name ASC',
      );

      return rows.map(_contactFromRow).toList();
    });
  }

  @override
  Future<ContactModel?> getContactById(String id) {
    return _run(() async {
      final db = await _dbHelper.database;
      final rows = await db.query(
        _contactsTable,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (rows.isEmpty) {
        return null;
      }

      return _contactFromRow(rows.first);
    });
  }

  @override
  Future<List<ContactModel>> searchContacts(String query) {
    return _run(() async {
      final db = await _dbHelper.database;
      final pattern = '%$query%';
      final rows = await db.query(
        _contactsTable,
        where: '''
          first_name LIKE ?
          OR last_name LIKE ?
          OR company LIKE ?
          OR phone LIKE ?
          OR email LIKE ?
        ''',
        whereArgs: [pattern, pattern, pattern, pattern, pattern],
        orderBy: 'first_name ASC, last_name ASC',
      );

      return rows.map(_contactFromRow).toList();
    });
  }

  @override
  Future<List<ContactModel>> getFavorites() {
    return _run(() async {
      final db = await _dbHelper.database;
      final rows = await db.query(
        _contactsTable,
        where: 'is_favorite = ?',
        whereArgs: [1],
        orderBy: 'first_name ASC, last_name ASC',
      );

      return rows.map(_contactFromRow).toList();
    });
  }

  @override
  Future<List<ContactModel>> getUnsynced() {
    return _run(() async {
      final db = await _dbHelper.database;
      final rows = await db.query(
        _contactsTable,
        where: 'is_synced = ?',
        whereArgs: [0],
        orderBy: 'updated_at ASC',
      );

      return rows.map(_contactFromRow).toList();
    });
  }

  @override
  Future<void> insertContact(ContactModel contact) {
    return _run(() async {
      final db = await _dbHelper.database;
      await db.insert(_contactsTable, _contactToRow(contact));
    });
  }

  @override
  Future<void> updateContact(ContactModel contact) {
    return _run(() async {
      final db = await _dbHelper.database;
      await db.update(
        _contactsTable,
        _contactToRow(contact),
        where: 'id = ?',
        whereArgs: [contact.id],
      );
    });
  }

  @override
  Future<void> deleteContact(String id) {
    return _run(() async {
      final db = await _dbHelper.database;
      await db.delete(
        _contactsTable,
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  @override
  Future<void> markSynced(String id) {
    return _run(() async {
      final db = await _dbHelper.database;
      await db.update(
        _contactsTable,
        {'is_synced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  @override
  Future<void> toggleFavorite(String id, bool value) {
    return _run(() async {
      final db = await _dbHelper.database;
      await db.update(
        _contactsTable,
        {'is_favorite': value ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  @override
  Future<void> upsertContact(ContactModel contact) {
    return _run(() async {
      final existing = await getContactById(contact.id);
      if (existing != null) {
        await updateContact(contact);
      } else {
        await insertContact(contact);
      }
    });
  }

  @override
  Future<void> clearAllContacts() {
    return _run(() async {
      final db = await _dbHelper.database;
      await db.delete(_contactsTable);
    });
  }

  Future<T> _run<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (error) {
      throw DatabaseException(error.toString(), cause: error);
    }
  }

  ContactModel _contactFromRow(Map<String, dynamic> row) {
    return ContactModel(
      id: row['id'] as String,
      firstName: row['first_name'] as String,
      lastName: row['last_name'] as String? ?? '',
      nickname: row['nickname'] as String?,
      phone: row['phone'] as String?,
      email: row['email'] as String?,
      company: row['company'] as String?,
      jobTitle: row['job_title'] as String?,
      department: row['department'] as String?,
      websiteUrls: _websiteUrlsFromRow(row['website_urls']),
      birthday: DateUtilsX.birthdayFromStorage(row['birthday'] as String?),
      notes: row['notes'] as String?,
      isFavorite: (row['is_favorite'] as int? ?? 0) == 1,
      isSynced: (row['is_synced'] as int? ?? 0) == 1,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }

  Map<String, dynamic> _contactToRow(ContactModel contact) {
    return {
      'id': contact.id,
      'first_name': contact.firstName,
      'last_name': contact.lastName,
      'nickname': contact.nickname,
      'phone': contact.phone,
      'email': contact.email,
      'company': contact.company,
      'job_title': contact.jobTitle,
      'department': contact.department,
      'website_urls': jsonEncode(contact.websiteUrls),
      'birthday': DateUtilsX.birthdayToStorage(contact.birthday),
      'notes': contact.notes,
      'is_favorite': contact.isFavorite ? 1 : 0,
      'is_synced': contact.isSynced ? 1 : 0,
      'created_at': contact.createdAt.toIso8601String(),
      'updated_at': contact.updatedAt.toIso8601String(),
    };
  }

  List<String> _websiteUrlsFromRow(Object? value) {
    if (value == null) {
      return const [];
    }
    if (value is String) {
      return (jsonDecode(value) as List<dynamic>).map((item) => item as String).toList();
    }
    return (value as List<dynamic>).map((item) => item as String).toList();
  }
}
