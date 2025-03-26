import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;
  static const String _dbName = 'easi_bank.db';

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    // Xóa database cũ nếu tồn tại
    if (await databaseExists(path)) {
      await deleteDatabase(path);
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        fullName TEXT NOT NULL,
        accountNumber TEXT UNIQUE NOT NULL,
        balance REAL NOT NULL,
        phoneNumber TEXT,
        email TEXT
      )
    ''');

    // Create demo user
    await db.insert('users', {
      'username': '1',
      'password': '1',
      'fullName': 'DUONG VAN MUOI',
      'accountNumber': '7254328762',
      'balance': 1000000.0,
      'phoneNumber': '0123456789',
      'email': 'demo@easibank.com',
    });
  }

  Future<User?> getUser(String username, String password) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  Future<User?> getUserByUsername(String username) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  Future<bool> isUsernameAvailable(String username) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return maps.isEmpty;
  }

  Future<User> createUser({
    required String username,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String email,
  }) async {
    final db = await instance.database;

    // Generate random account number (10 digits)
    final random = Random();
    String accountNumber;
    bool isUnique = false;

    do {
      accountNumber = '';
      for (int i = 0; i < 10; i++) {
        accountNumber += random.nextInt(10).toString();
      }

      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'accountNumber = ?',
        whereArgs: [accountNumber],
      );
      isUnique = maps.isEmpty;
    } while (!isUnique);

    // Generate random initial balance between 100,000 and 10,000,000
    final balance = random.nextDouble() * (10000000 - 100000) + 100000;

    final id = await db.insert('users', {
      'username': username,
      'password': password,
      'fullName': fullName,
      'accountNumber': accountNumber,
      'balance': balance,
      'phoneNumber': phoneNumber,
      'email': email,
    });

    return User(
      id: id,
      username: username,
      password: password,
      fullName: fullName,
      accountNumber: accountNumber,
      balance: balance,
      phoneNumber: phoneNumber,
      email: email,
    );
  }

  Future<User?> getUserByAccountNumber(String accountNumber) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'accountNumber = ?',
      whereArgs: [accountNumber],
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  Future<void> updateUserBalance(String accountNumber, double newBalance) async {
    final db = await instance.database;
    await db.update(
      'users',
      {'balance': newBalance},
      where: 'accountNumber = ?',
      whereArgs: [accountNumber],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
} 