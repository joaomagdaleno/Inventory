import 'package:flutter/material.dart';
import 'package:patrimonio_ifsul/data/datasources/database_helper.dart';
import 'package:patrimonio_ifsul/data/datasources/patrimonio_local_data_source.dart';
import 'package:patrimonio_ifsul/domain/entities/patrimonio_item.dart';
import 'package:patrimonio_ifsul/domain/repositories/patrimonio_repository.dart';
import 'package:patrimonio_ifsul/presentation/providers/patrimonio_provider.dart';
import 'package:patrimonio_ifsul/presentation/screens/item_detail_screen.dart';
import 'package:patrimonio_ifsul/presentation/screens/item_list_screen.dart';
import 'package:patrimonio_ifsul/presentation/screens/item_form_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final dbHelper = DatabaseHelper();
        final localDataSource = PatrimonioLocalDataSourceImpl(databaseHelper: dbHelper);
        final repository = PatrimonioRepositoryImpl(localDataSource: localDataSource);
        return PatrimonioProvider(repository: repository)..fetchItems();
      },
      child: MaterialApp(
        title: 'Controle de Patrimônio',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          if (settings.name == '/item-detail') {
            final item = settings.arguments as PatrimonioItem;
            return MaterialPageRoute(
              builder: (context) => ItemDetailScreen(item: item),
            );
          }
          if (settings.name == '/edit-item') {
            final item = settings.arguments as PatrimonioItem;
            return MaterialPageRoute(
              builder: (context) => ItemFormScreen(item: item),
            );
          }
          if (settings.name == '/add-item') {
            return MaterialPageRoute(
              builder: (context) => const ItemFormScreen(),
            );
          }
          return MaterialPageRoute(
            builder: (context) => const ItemListScreen(),
          );
        },
        routes: {
          '/': (context) => const ItemListScreen(),
        },
      ),
    );
  }
}
