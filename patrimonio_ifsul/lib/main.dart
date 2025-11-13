import 'package:flutter/material.dart';
import 'package:patrimonio_ifsul/data/datasources/database_helper.dart';
import 'package:patrimonio_ifsul/data/datasources/patrimonio_local_data_source.dart';
import 'package:patrimonio_ifsul/data/datasources/user_local_data_source.dart';
import 'package:patrimonio_ifsul/domain/entities/patrimonio_item.dart';
import 'package:patrimonio_ifsul/domain/repositories/patrimonio_repository.dart';
import 'package:patrimonio_ifsul/domain/repositories/user_repository.dart';
import 'package:patrimonio_ifsul/presentation/providers/auth_provider.dart';
import 'package:patrimonio_ifsul/presentation/providers/patrimonio_provider.dart';
import 'package:patrimonio_ifsul/presentation/screens/auth_wrapper.dart';
import 'package:patrimonio_ifsul/presentation/screens/item_detail_screen.dart';
import 'package:patrimonio_ifsul/presentation/screens/item_form_screen.dart';
import 'package:patrimonio_ifsul/presentation/screens/user_management_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseHelper>(create: (_) => DatabaseHelper()),
        ProxyProvider<DatabaseHelper, UserLocalDataSource>(
          update: (_, db, __) => UserLocalDataSourceImpl(databaseHelper: db),
        ),
        ProxyProvider<UserLocalDataSource, UserRepository>(
          update: (_, ds, __) => UserRepositoryImpl(localDataSource: ds),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            userRepository: context.read<UserRepository>(),
          ),
        ),
        ProxyProvider<DatabaseHelper, PatrimonioLocalDataSource>(
          update: (_, db, __) => PatrimonioLocalDataSourceImpl(databaseHelper: db),
        ),
        ProxyProvider<PatrimonioLocalDataSource, PatrimonioRepository>(
          update: (_, ds, __) => PatrimonioRepositoryImpl(localDataSource: ds),
        ),
        ChangeNotifierProvider<PatrimonioProvider>(
          create: (context) => PatrimonioProvider(
            repository: context.read<PatrimonioRepository>(),
          )..fetchItems(),
        ),
      ],
      child: MaterialApp(
        title: 'Controle de Patrimônio',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthWrapper(),
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
          if (settings.name == '/user-management') {
            return MaterialPageRoute(
              builder: (context) => const UserManagementScreen(),
            );
          }
          return null;
        },
      ),
    );
  }
}
