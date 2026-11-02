import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/secure_storage_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _api = ApiService();
  final _storage = SecureStorageService();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      final token = await _api.login(_email.text.trim(), _password.text);
      await _storage.saveToken(token);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Login berhasil'), backgroundColor: Colors.green));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'),
          backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(controller: _email, keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email',
                  prefixIcon: Icon(Icons.email), border: OutlineInputBorder())),
          const SizedBox(height: 16),
          TextField(controller: _password, obscureText: _obscure,
              decoration: InputDecoration(labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscure = !_obscure)))),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _login,
              child: _loading
                  ? const SizedBox(height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Login'))),
        ]),
      ),
    );
  }
}
