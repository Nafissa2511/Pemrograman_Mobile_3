import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _teleponController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiPasswordController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _passwordController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();

    _namaController.clear();
    _emailController.clear();
    _teleponController.clear();
    _passwordController.clear();
    _konfirmasiPasswordController.clear();
  }

  void _daftar() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registrasi Berhasil'),
          content: Text(
            'Nama: ${_namaController.text}\n'
            'Email: ${_emailController.text}\n'
            'Nomor Telepon: ${_teleponController.text}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Registrasi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _namaController,
                label: 'Nama',
                hint: 'Masukkan nama lengkap',
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),

              CustomTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'contoh@email.com',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email tidak boleh kosong';
                  }

                  if (!RegExp(
                    r'^[\w.+-]+@[\w-]+\.[\w.-]+$',
                  ).hasMatch(value.trim())) {
                    return 'Format email tidak valid';
                  }

                  return null;
                },
              ),

              CustomTextField(
                controller: _teleponController,
                label: 'Nomor Telepon',
                hint: '081234567890',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor telepon tidak boleh kosong';
                  }

                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Nomor telepon hanya boleh angka';
                  }

                  if (value.length < 10 || value.length > 13) {
                    return 'Nomor telepon harus 10–13 digit';
                  }

                  return null;
                },
              ),

              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                hint: 'Minimal 8 karakter',
                prefixIcon: Icons.lock,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }

                  if (value.length < 8) {
                    return 'Password minimal 8 karakter';
                  }

                  return null;
                },
              ),

              CustomTextField(
                controller: _konfirmasiPasswordController,
                label: 'Konfirmasi Password',
                hint: 'Masukkan ulang password',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password tidak boleh kosong';
                  }

                  if (value != _passwordController.text) {
                    return 'Password tidak sama';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: _daftar,
                child: const Text('Daftar'),
              ),

              const SizedBox(height: 8),

              OutlinedButton(
                onPressed: _resetForm,
                child: const Text('Reset'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}