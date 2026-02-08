import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String _selectedRole = 'siswa';

  // Common fields
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Stan fields
  final _namaStanController = TextEditingController();
  final _namaPemilikController = TextEditingController();
  final _telpStanController = TextEditingController();

  // Siswa fields
  final _namaSiswaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _telpSiswaController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _namaStanController.dispose();
    _namaPemilikController.dispose();
    _telpStanController.dispose();
    _namaSiswaController.dispose();
    _alamatController.dispose();
    _telpSiswaController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    Map<String, dynamic> data = {
      'username': _usernameController.text.trim(),
      'password': _passwordController.text,
      'role': _selectedRole,
    };

    if (_selectedRole == 'stan') {
      data.addAll({
        'nama_stan': _namaStanController.text.trim(),
        'nama_pemilik': _namaPemilikController.text.trim(),
        'telp': _telpStanController.text.trim(),
      });
    } else if (_selectedRole == 'siswa') {
      data.addAll({
        'nama_siswa': _namaSiswaController.text.trim(),
        'alamat': _alamatController.text.trim(),
        'telp': _telpSiswaController.text.trim(),
      });
    }

    final result = await _authService.register(data);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Registrasi gagal'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akun'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Silakan isi data di bawah ini',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 24),
                // Role selection
                const Text(
                  'Pilih Role',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedRole,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: 'siswa',
                          child: Text('Siswa'),
                        ),
                        DropdownMenuItem(
                          value: 'stan',
                          child: Text('Stan'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedRole = value!);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Common fields
                CustomTextField(
                  controller: _usernameController,
                  label: 'Username',
                  hint: 'Masukkan username',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username tidak boleh kosong';
                    }
                    if (value.length < 3) {
                      return 'Username minimal 3 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Masukkan password',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Role-specific fields
                if (_selectedRole == 'stan') ...[
                  CustomTextField(
                    controller: _namaStanController,
                    label: 'Nama Stan',
                    hint: 'Masukkan nama stan',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama stan tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _namaPemilikController,
                    label: 'Nama Pemilik',
                    hint: 'Masukkan nama pemilik',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama pemilik tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _telpStanController,
                    label: 'Telepon',
                    hint: 'Masukkan nomor telepon',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Telepon tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ] else if (_selectedRole == 'siswa') ...[
                  CustomTextField(
                    controller: _namaSiswaController,
                    label: 'Nama Siswa',
                    hint: 'Masukkan nama lengkap',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama siswa tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _alamatController,
                    label: 'Alamat',
                    hint: 'Masukkan alamat',
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alamat tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _telpSiswaController,
                    label: 'Telepon',
                    hint: 'Masukkan nomor telepon',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Telepon tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 24),
                // Register button
                CustomButton(
                  text: 'Daftar',
                  onPressed: _register,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
