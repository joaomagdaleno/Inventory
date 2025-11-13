import 'package:flutter/material.dart';
import 'package:patrimonio_ifsul/domain/entities/patrimonio_item.dart';
import 'package:patrimonio_ifsul/presentation/providers/patrimonio_provider.dart';
import 'package:patrimonio_ifsul/presentation/screens/barcode_scanner_screen.dart';
import 'package:provider/provider.dart';

class ItemFormScreen extends StatefulWidget {
  final PatrimonioItem? item;

  const ItemFormScreen({super.key, this.item});

  @override
  _ItemFormScreenState createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _numeroDeSerieController = TextEditingController();
  final _codigoDeBarrasController = TextEditingController();
  DateTime _dataDeAquisicao = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nomeController.text = widget.item!.nome;
      _descricaoController.text = widget.item!.descricao;
      _numeroDeSerieController.text = widget.item!.numeroDeSerie;
      _codigoDeBarrasController.text = widget.item!.codigoDeBarras;
      _dataDeAquisicao = widget.item!.dataDeAquisicao;
    }
  }

  Future<void> _scanBarcode() async {
    final barcode = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
    );
    if (barcode != null) {
      setState(() {
        _codigoDeBarrasController.text = barcode;
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final patrimonioProvider = Provider.of<PatrimonioProvider>(context, listen: false);

      if (widget.item == null) {
        // Create new item
        final newItem = PatrimonioItem(
          nome: _nomeController.text,
          descricao: _descricaoController.text,
          numeroDeSerie: _numeroDeSerieController.text,
          codigoDeBarras: _codigoDeBarrasController.text,
          dataDeAquisicao: _dataDeAquisicao,
          status: 'Ativo',
        );
        patrimonioProvider.addItem(newItem);
      } else {
        // Update existing item
        final updatedItem = PatrimonioItem(
          id: widget.item!.id,
          nome: _nomeController.text,
          descricao: _descricaoController.text,
          numeroDeSerie: _numeroDeSerieController.text,
          codigoDeBarras: _codigoDeBarrasController.text,
          dataDeAquisicao: _dataDeAquisicao,
          status: widget.item!.status,
        );
        patrimonioProvider.updateItem(updatedItem);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Novo Item' : 'Editar Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextFormField(
                controller: _numeroDeSerieController,
                decoration: const InputDecoration(labelText: 'Número de Série'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _codigoDeBarrasController,
                decoration: InputDecoration(
                  labelText: 'Código de Barras',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: _scanBarcode,
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              ListTile(
                title: Text('Data de Aquisição: ${_dataDeAquisicao.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _dataDeAquisicao,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null && pickedDate != _dataDeAquisicao) {
                    setState(() {
                      _dataDeAquisicao = pickedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
