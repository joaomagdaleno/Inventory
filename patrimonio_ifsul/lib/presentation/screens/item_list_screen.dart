import 'package:flutter/material.dart';
import 'package:patrimonio_ifsul/domain/entities/user.dart';
import 'package:patrimonio_ifsul/presentation/providers/auth_provider.dart';
import 'package:patrimonio_ifsul/presentation/providers/patrimonio_provider.dart';
import 'package:provider/provider.dart';

class ItemListScreen extends StatelessWidget {
  const ItemListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bool canEdit = authProvider.currentUser?.role == UserRole.admin || authProvider.currentUser?.role == UserRole.tecnico;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Patrimônio'),
        actions: [
          if (authProvider.currentUser?.role == UserRole.admin)
            IconButton(
              icon: const Icon(Icons.people),
              onPressed: () {
                Navigator.of(context).pushNamed('/user-management');
              },
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
            },
          ),
        ],
      ),
      body: Consumer<PatrimonioProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.items.isEmpty) {
            return const Center(child: Text('Nenhum item cadastrado.'));
          }
          return ListView.builder(
            itemCount: provider.items.length,
            itemBuilder: (context, index) {
              final item = provider.items[index];
              return ListTile(
                title: Text(item.nome),
                subtitle: Text(item.numeroDeSerie),
                onTap: () {
                  Navigator.of(context).pushNamed('/item-detail', arguments: item);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: canEdit
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/add-item');
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
