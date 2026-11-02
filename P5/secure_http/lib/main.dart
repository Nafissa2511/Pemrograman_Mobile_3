import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart'; // Import LoginScreen
import 'services/secure_storage_service.dart'; // Import SecureStorageService (sesuaikan path filenya)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final loggedIn = await SecureStorageService().hasToken();
  runApp(MyApp(loggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool loggedIn; // 1. Tambahkan variabel ini

  const MyApp({super.key, required this.loggedIn}); // 2. Tambahkan ke konstruktor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secure Storage & HTTP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 3. Gunakan logika percabangan halaman
      home: loggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}