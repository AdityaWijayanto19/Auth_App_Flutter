import 'dart:io';
import 'package:auth_app/presentation/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../service/auth_service.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Register> {
  final _fullNameC = TextEditingController();
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();

  bool _obscurePassword = true;
  File? _avatarFile;
  bool _isLoading = false;
  String? _error;
  String? _info;

  // ===================== IMAGE PICKER =====================
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.gallery);

    if (result != null) {
      setState(() {
        _avatarFile = File(result.path);
      });
    }
  }

  // ===================== REGISTER HANDLER =====================
  Future<void> _handleRegister() async {
    if (_fullNameC.text.trim().isEmpty ||
        _emailC.text.trim().isEmpty ||
        _passwordC.text.trim().isEmpty) {
      setState(() {
        _error = 'Semua field wajib diisi.';
        _info = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _info = null;
    });

    try {
      await AuthService().signUpWithProfile(
        email: _emailC.text.trim(),
        password: _passwordC.text.trim(),
        fullName: _fullNameC.text.trim(),
        avatarFile: _avatarFile,
      );

      setState(() {
        _info = 'Registrasi berhasil. Silakan cek email untuk verifikasi, lalu login.';
      });

      // Kalau mau langsung arahkan ke halaman login:
      // Navigator.pushReplacement(
      // 	 context,
      // 	 MaterialPageRoute(builder: (_) => const LoginForm()),
      // );

    } on AuthException catch (e) {
      setState(() {
        _error = 'Autentikasi Gagal: ${e.message}';
      });
    } on StorageException catch (e) {
      setState(() {
        _error = 'Storage Error: ${e.message}. Akun berhasil dibuat, tetapi avatar gagal diunggah.';
      });
    } on Exception catch (e) {
      // Menangkap exception yang dilempar dari AuthService (misalnya PostgrestException)
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } catch (e) {
      setState(() {
        _error = 'Terjadi kesalahan tidak terduga, coba lagi.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _fullNameC.dispose();
    _emailC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Register',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // ===================== AVATAR =====================
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: _avatarFile != null
                              ? FileImage(_avatarFile!)
                              : null,
                          child: _avatarFile == null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.deepOrange,
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: _pickImage,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // ===================== TEXTFIELDS =====================
                    _buildTextField(
                      label: 'Name',
                      icon: Icons.person_outline,
                      controller: _fullNameC,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailC,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      label: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      onSuffixTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      controller: _passwordC,
                    ),
                    const SizedBox(height: 16),

                    // ===================== ERROR / INFO =====================
                    if (_error != null)
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    if (_info != null)
                      Text(
                        _info!,
                        style: const TextStyle(color: Colors.green),
                        textAlign: TextAlign.center,
                      ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            // ===================== BUTTON DAFTAR =====================
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(
                          'Daftar',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== REUSABLE TEXTFIELD =====================
  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    TextEditingController? controller,
  }) {
    return Focus(
      child: Builder(
        builder: (context) {
          final hasFocus = Focus.of(context).hasFocus;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: hasFocus
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              cursorColor: Colors.deepOrange,
              decoration: InputDecoration(
                label: Text(label),
                prefixIcon: Icon(icon, color: hasFocus ? Colors.deepOrange : Colors.grey),
                suffixIcon: suffixIcon != null
                    ? GestureDetector(
                        onTap: onSuffixTap,
                        child: Icon(suffixIcon, color: Colors.grey),
                      )
                    : null,
                floatingLabelStyle: const TextStyle(color: Colors.deepOrange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: hasFocus ? Colors.deepOrange : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color: Colors.deepOrange,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    )),
              ),
            ),
          );
        },
      ),
    );
  }
}