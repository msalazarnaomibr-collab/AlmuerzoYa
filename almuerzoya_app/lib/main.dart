

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/orders_screen.dart';
import 'services/api_service.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AlmuerzoYaApp());
}

class AlmuerzoYaApp extends StatelessWidget {
  const AlmuerzoYaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AlmuerzoYa',
      theme: AppTheme.theme,
      home: const InicioApp(),
    );
  }
}

class InicioApp extends StatelessWidget {
  const InicioApp({super.key});

  Future<bool> comprobarSesion() async {
    final token = await ApiService.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: comprobarSesion(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return const OrdersScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
