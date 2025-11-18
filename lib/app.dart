import 'package:flutter/material.dart';
import 'package:finovo/screens/auth/login_screen.dart';
import 'package:finovo/screens/dashboard/dashboard_screen.dart';
import 'package:finovo/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class FinovoApp extends StatelessWidget {
  const FinovoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finovo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: auth.user == null ? const LoginScreen() : const DashboardScreen(),
    );
  }
}
