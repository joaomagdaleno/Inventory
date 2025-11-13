import 'package:flutter/material.dart';
import 'package:patrimonio_ifsul/domain/entities/patrimonio_item.dart';
import 'package:patrimonio_ifsul/domain/entities/user.dart';
import 'package:patrimonio_ifsul/presentation/providers/auth_provider.dart';
import 'package:patrimonio_ifsul/presentation/providers/patrimonio_provider.dart';
import 'package:provider/provider.dart';

class ItemDetailScreen extends StatelessWidget {
  final PatrimonioItem item;

  const ItemDetailScreen({super.key, required this.item});

  void _deleteItem(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Você tem certeza que deseja excluir este item?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text('Excluir'),
            onPressed: () {
              Provider.of<PatrimonioProvider>(context, listen: false).deleteItem(item.id!);
              Navigator.of(ctx).pop(); // Close the dialog
              Navigator.of(context).pop(); // Go back from detail screen
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bool canEdit = authProvider.currentUser?.role == UserRole.admin || authProvider.currentUser?.role == UserRole.tecnico;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.nome),
        actions: [
          if (canEdit)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed('/edit-item', arguments: item);
              },
            ),
          if (canEdit)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteItem(context),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Descrição: ${item.descricao}'),
            const SizedBox(height: 8),
            Text('Número de Série: ${item.numeroDeSerie}'),
            const SizedBox(height: 8),
            Text('Código de Barras: ${item.codigoDeBarras}'),
            const SizedBox(height: 8),
            Text('Data de Aquisição: ${item.dataDeAquisicao.toLocal()}'.split(' ')[0]),
            const SizedBox(height: 8),
            Text('Status: ${item.status}'),
          ],
        ),
      ),
    );
  }
}
