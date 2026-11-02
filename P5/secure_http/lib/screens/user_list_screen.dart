import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ApiService _apiService = ApiService();
  
  // Controller & Query untuk Latihan 4 (Pencarian)
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchUsers() {
    setState(() {
      // CARA PANGGILAN NORMAL (Default 10 detik):
      _usersFuture = _apiService.getUsers(timeout: const Duration(milliseconds: 1));

      // UNTUK SCREENSHOT L5-b (Uji Timeout 1 Milidetik):
      // Hilangkan tanda komen '//' di baris bawah ini untuk tes error timeout:
      // _usersFuture = _apiService.getUsers(timeout: const Duration(milliseconds: 1));
    });
  }

  // Getter Filtered Users untuk Latihan 4
  List<User> _getFilteredUsers(List<User> users) {
    final q = _query.toLowerCase();
    if (q.isEmpty) return users;
    return users
        .where((u) =>
            u.name.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q))
        .toList();
  }

  void _showUserDetail(User user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(user.name),
        content: Text('Email: ${user.email}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengguna'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchUsers,
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          // State 1: Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // State 2: Error (Tampilan Error Timeout / Error Lainnya)
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}'.replaceAll('Exception: ', ''),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchUsers,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          // State 3: Sukses Data Diterima
          final allUsers = snapshot.data ?? [];
          final filteredUsers = _getFilteredUsers(allUsers);

          return Column(
            children: [
              // Column Pencarian (Latihan 4)
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari nama atau email...',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                          ),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),

              // Output List atau Pesan Tidak Ditemukan
              Expanded(
                child: filteredUsers.isEmpty
                    ? const Center(
                        child: Text('Pengguna tidak ditemukan'),
                      )
                    : ListView.builder(
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, i) {
                          final user = filteredUsers[i];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  user.name.isNotEmpty ? user.name[0] : '?',
                                ),
                              ),
                              title: Text(user.name),
                              subtitle: Text(user.email),
                              onTap: () => _showUserDetail(user),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}