import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    try {
      if (_database != null) return _database!;

      // If the database is not initialized, initialize it
      _database = await _initDatabase();
      return _database!;
    } catch (e) {
      throw Exception('Error getting database: $e');
    }
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    try {
      final String path = join(await getDatabasesPath(), 'user_data.db');

      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          // Create a table for storing the required user data
          return db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userCode TEXT,
            userDisplayName TEXT,
            email TEXT,
            userEmployeeCode TEXT,
            companyCode TEXT,
            userLocations TEXT,  -- Storing list as a String 
            userPermissions TEXT -- Storing list as a String
          )
        ''');
        },
      );
    } catch (e) {
      throw Exception('Error initializing database: $e');
    }
    
  }

  // Save user data to the SQLite database
  Future<void> saveUser(Map<String, dynamic> userData) async {
    try {
      final db = await database;

      // Convert lists to JSON string
      String userLocations = userData['User_Locations'] != null
          ? jsonEncode(
              userData['User_Locations']) // Convert list to JSON string
          : '[]';
      String userPermissions = userData['User_Permissions'] != null
          ? jsonEncode(
              userData['User_Permissions']) // Convert list to JSON string
          : '[]';

      final userMap = {
        'userCode': userData['User_Code'],
        'userDisplayName': userData['User_Display_Name'],
        'email': userData['Email'],
        'userEmployeeCode': userData['User_Employee_Code'],
        'companyCode': userData['Company_Code'],
        'userLocations': userLocations,
        'userPermissions': userPermissions,
      };

      // Insert or update the user data
      await db.insert(
        'users',
        userMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Error saving user data: $e');
    }
  }

  // Get the user data from the SQLite database
  Future<Map<String, dynamic>?> getUser() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result = await db.query('users');

      if (result.isNotEmpty) {
        final Map<String, dynamic> user =
            Map<String, dynamic>.from(result.first);

        try {
          // Safely decode the JSON strings into Lists
          user['userLocations'] = jsonDecode(user['userLocations']);
          user['userPermissions'] = jsonDecode(user['userPermissions']);
        } catch (e) {
          print('Error decoding user fields: $e');
        }

        return user;
      }
      return null;
    } catch (e) {
      throw Exception('Error getting user data: $e');
    }
  }

  // Delete all user data (used for logout)
  Future<void> deleteUserData() async {
    try {
      final db = await database;
      await db.delete('users');
    } catch (e) {
      throw Exception('Error deleting all user data: $e');
    }
  }
}
