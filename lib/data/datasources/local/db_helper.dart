import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  static const String _dbName = 'contacts_app.db';
  static const int _dbVersion = 6;

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.transaction((txn) async {
      await txn.execute('''
        CREATE TABLE contacts (
          id TEXT PRIMARY KEY,
          first_name TEXT NOT NULL,
          last_name TEXT DEFAULT '',
          nickname TEXT,
          phone TEXT,
          email TEXT,
          company TEXT,
          job_title TEXT,
          department TEXT,
          website_urls TEXT DEFAULT '[]',
          birthday TEXT,
          notes TEXT,
          is_favorite INTEGER DEFAULT 0,
          is_synced INTEGER DEFAULT 0,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 5) {
      final columns = await db.rawQuery('PRAGMA table_info(contacts)');
      final columnNames = columns
          .map((row) => row['name'] as String?)
          .whereType<String>()
          .toSet();

      if (!columnNames.contains('phone')) {
        await db.execute('ALTER TABLE contacts ADD COLUMN phone TEXT');
      }
      if (!columnNames.contains('email')) {
        await db.execute('ALTER TABLE contacts ADD COLUMN email TEXT');
      }

      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table'",
      );
      final tableNames = tables
          .map((row) => row['name'] as String?)
          .whereType<String>()
          .toSet();

      if (tableNames.contains('contact_phones')) {
        await db.execute('''
          UPDATE contacts
          SET phone = (
            SELECT value
            FROM contact_phones
            WHERE contact_phones.contact_id = contacts.id
            ORDER BY rowid ASC
            LIMIT 1
          )
          WHERE phone IS NULL
        ''');
        await db.execute('DROP TABLE contact_phones');
      }

      if (tableNames.contains('contact_emails')) {
        await db.execute('''
          UPDATE contacts
          SET email = (
            SELECT value
            FROM contact_emails
            WHERE contact_emails.contact_id = contacts.id
            ORDER BY rowid ASC
            LIMIT 1
          )
          WHERE email IS NULL
        ''');
        await db.execute('DROP TABLE contact_emails');
      }

      await db.execute('DROP TABLE IF EXISTS contact_addresses');
    }

    if (oldVersion < 6) {
      await db.execute('DROP TABLE IF EXISTS contact_groups');
      await db.execute('DROP TABLE IF EXISTS groups');
    }
  }
}
