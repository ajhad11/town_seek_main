import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'package:uuid/uuid.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('town_seek.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path, 
      version: 3, 
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        // Simple migration: Drop all and recreate for dev
        await db.execute('DROP TABLE IF EXISTS user_profiles');
        await db.execute('DROP TABLE IF EXISTS businesses');
        await db.execute('DROP TABLE IF EXISTS products');
        await db.execute('DROP TABLE IF EXISTS services');
        await db.execute('DROP TABLE IF EXISTS bookings');
        await db.execute('DROP TABLE IF EXISTS reviews');
        await db.execute('DROP TABLE IF EXISTS admins');
        await db.execute('DROP TABLE IF EXISTS offers');
        await db.execute('DROP TABLE IF EXISTS auth_users');
        await db.execute('DROP TABLE IF EXISTS hospitals');
        await db.execute('DROP TABLE IF EXISTS doctors');
        await db.execute('DROP TABLE IF EXISTS categories');
        await _createDB(db, newVersion);
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT';
    const boolType = 'INTEGER'; // 0 or 1
    const integerType = 'INTEGER';
    const realType = 'REAL';
    const jsonType = 'TEXT'; // For storing JSON/Map data

    await db.execute('''
      CREATE TABLE categories (
        id $idType,
        name $textType,
        icon $textType,
        created_at $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE user_profiles (
        id $idType,
        email $textType,
        full_name $textType,
        avatar_url $textType,
        role $textType,
        created_at $textType,
        is_blocked $boolType DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE businesses (
        id $idType,
        owner_id $textType,
        name $textType,
        category $textType,
        description $textType,
        image_url $textType,
        address $textType,
        latitude $realType,
        longitude $realType,
        phone $textType,
        email $textType,
        website $textType,
        images $jsonType,
        rating $realType,
        review_count $integerType,
        tags $jsonType,
        facilities $jsonType,
        metadata $jsonType,
        is_open $boolType DEFAULT 1,
        is_verified $boolType DEFAULT 0,
        is_active $boolType DEFAULT 1,
        timing_flexible $jsonType,
        created_at $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id $idType,
        business_id $textType,
        name $textType,
        description $textType,
        price $realType,
        image_url $textType,
        category $textType,
        stock_quantity $integerType,
        is_available $boolType DEFAULT 1,
        created_at $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE services (
        id $idType,
        business_id $textType,
        name $textType,
        description $textType,
        price $realType,
        duration_minutes $integerType,
        image_url $textType,
        is_available $boolType DEFAULT 1,
        created_at $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE bookings (
        id $idType,
        user_id $textType,
        business_id $textType,
        service_id $textType,
        booking_date $textType,
        status $textType,
        item_details $jsonType,
        notes $textType,
        total_price $realType,
        created_at $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE reviews (
        id $idType,
        user_id $textType,
        business_id $textType,
        rating $realType,
        comment $textType,
        reply $textType,
        created_at $textType,
        is_flagged $boolType DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE admins (
        id $idType,
        email $textType,
        role $textType,
        business_id $textType,
        is_approved $boolType DEFAULT 0,
        created_at $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE offers (
        id $idType,
        business_id $textType,
        title $textType,
        description $textType,
        discount $realType,
        start_date $textType,
        end_date $textType,
        is_active $boolType DEFAULT 1,
        created_at $textType
      )
    ''');
    
    // Hospitals Table
    await db.execute('''
      CREATE TABLE hospitals (
        id $idType,
        name $textType,
        address $textType,
        phone $textType,
        email $textType,
        image_url $textType,
        is_active $boolType DEFAULT 1,
        created_at $textType
      )
    ''');

    // Doctors Table
    await db.execute('''
      CREATE TABLE doctors (
        id $idType,
        hospital_id $textType,
        name $textType,
        specialization $textType,
        image_url $textType,
        availability $jsonType,
        is_active $boolType DEFAULT 1,
        created_at $textType
      )
    ''');
    
    // Auth table to simulate Supabase Auth
    await db.execute('''
      CREATE TABLE auth_users (
        id $idType,
        email $textType,
        password $textType, 
        created_at $textType,
        last_sign_in_at $textType
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}

