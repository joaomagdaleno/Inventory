import 'package:flutter/material.dart';
import 'package:patrimonio_ifsul/domain/entities/patrimonio_item.dart';
import 'package:patrimonio_ifsul/domain/repositories/patrimonio_repository.dart';

class PatrimonioProvider with ChangeNotifier {
  final PatrimonioRepository repository;

  PatrimonioProvider({required this.repository});

  List<PatrimonioItem> _items = [];
  List<PatrimonioItem> get items => _items;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchItems() async {
    _isLoading = true;
    notifyListeners();
    _items = await repository.getAllItems();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addItem(PatrimonioItem item) async {
    await repository.insertItem(item);
    await fetchItems();
  }

  Future<void> updateItem(PatrimonioItem item) async {
    await repository.updateItem(item);
    await fetchItems();
  }

  Future<void> deleteItem(int id) async {
    await repository.deleteItem(id);
    await fetchItems();
  }
}
