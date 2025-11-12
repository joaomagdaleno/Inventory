import 'package:patrimonio_ifsul/data/datasources/patrimonio_local_data_source.dart';
import 'package:patrimonio_ifsul/domain/entities/patrimonio_item.dart';

abstract class PatrimonioRepository {
  Future<int> insertItem(PatrimonioItem item);
  Future<List<PatrimonioItem>> getAllItems();
  Future<int> updateItem(PatrimonioItem item);
  Future<int> deleteItem(int id);
}

class PatrimonioRepositoryImpl implements PatrimonioRepository {
  final PatrimonioLocalDataSource localDataSource;

  PatrimonioRepositoryImpl({required this.localDataSource});

  @override
  Future<int> insertItem(PatrimonioItem item) {
    return localDataSource.insertItem(item);
  }

  @override
  Future<List<PatrimonioItem>> getAllItems() {
    return localDataSource.getAllItems();
  }

  @override
  Future<int> updateItem(PatrimonioItem item) {
    return localDataSource.updateItem(item);
  }

  @override
  Future<int> deleteItem(int id) {
    return localDataSource.deleteItem(id);
  }
}
