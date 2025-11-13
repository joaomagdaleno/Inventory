import 'package:flutter/material.dart';
import 'package:patrimonio_ifsul/presentation/providers/auth_provider.dart';
import 'package:patrimonio_ifsul/presentation/screens/item_list_screen.dart';
import 'package:patrimonio_ifsul/presentation/screens/login_screen.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isAuthenticated) {
      return const ItemListScreen();
    } else {
      return const LoginScreen();
    }
  }
}
