import 'package:patrimonio_ifsul/data/datasources/database_helper.dart';
import 'package:patrimonio_ifsul/domain/entities/patrimonio_item.dart';

abstract class PatrimonioLocalDataSource {
  Future<int> insertItem(PatrimonioItem item);
  Future<List<PatrimonioItem>> getAllItems();
  Future<int> updateItem(PatrimonioItem item);
  Future<int> deleteItem(int id);
}

class PatrimonioLocalDataSourceImpl implements PatrimonioLocalDataSource {
  final DatabaseHelper databaseHelper;

  PatrimonioLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<int> insertItem(PatrimonioItem item) async {
    final db = await databaseHelper.database;
    return await db.insert('patrimonio', item.toMap());
  }

  @override
  Future<List<PatrimonioItem>> getAllItems() async {
    final db = await databaseHelper.database;
    final maps = await db.query('patrimonio');
    return List.generate(maps.length, (i) {
      return PatrimonioItem.fromMap(maps[i]);
    });
  }

  @override
  Future<int> updateItem(PatrimonioItem item) async {
    final db = await databaseHelper.database;
    return await db.update(
      'patrimonio',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  @override
  Future<int> deleteItem(int id) async {
    final db = await databaseHelper.database;
    return await db.delete(
      'patrimonio',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
