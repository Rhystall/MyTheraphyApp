import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/obat.dart';

class DBHelper {
  static const _databaseName = 'obat.db';
  static const _databaseVersion = 1; // Tidak perlu versi tinggi untuk testing
  static Database? _db;

  /// Mendapatkan instance database
  static Future<Database> getDatabase() async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  /// Inisialisasi database
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);

    // Buat database baru
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await _createTable(db);
      },
    );
  }

  static Future<int> updateObat(Obat obat) async {
    final db = await getDatabase();
    final data = obat.toJson();

    // Debugging log
    print("Data yang akan diupdate ke database: $data");

    return await db.update(
      'obat',
      data,
      where: 'id = ?',
      whereArgs: [obat.id],
    );
  }

  /// Membuat tabel `obat`
  static Future<void> _createTable(Database db) async {
    await db.execute('''
      CREATE TABLE obat (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        tanggalMulai TEXT NOT NULL,
        tanggalAkhir TEXT NOT NULL,
        jumlah INTEGER NOT NULL,
        dosis INTEGER NOT NULL,
        waktu TEXT NOT NULL,
        isAlarm INTEGER NOT NULL,
        waktuAlarm TEXT, -- Kolom baru
        tanggalKonsumsi TEXT NOT NULL
      )
    ''');
    print("Tabel 'obat' berhasil dibuat.");
  }

  /// Debug: Cetak struktur tabel `obat`
  static Future<void> printTableSchema() async {
    final db = await getDatabase();
    final result = await db.rawQuery('PRAGMA table_info(obat)');
    print("Struktur tabel obat: $result");
  }

  /// Menambahkan data obat ke tabel
  static Future<int> insertObat(Obat obat) async {
    final db = await getDatabase();
    return await db.insert('obat', obat.toJson());
  }

  /// Mendapatkan semua data obat dari tabel
  static Future<List<Obat>> getObatList() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('obat');
    return maps.map((map) => Obat.fromJson(map)).toList();
  }

  /// Menghapus data obat berdasarkan ID
  static Future<int> deleteObat(int id) async {
    final db = await getDatabase();
    return await db.delete('obat', where: 'id = ?', whereArgs: [id]);
  }
}
