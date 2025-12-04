import 'package:flutter/material.dart';
import 'lupaPassword.dart';
import 'register.dart';
import 'home.dart';
import '../../service/auth_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginState();
}

class _LoginState extends State<LoginForm> {
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();

  String? _error;
  String? _info;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailC.text.trim().isEmpty || _passwordC.text.trim().isEmpty) {
      setState(() {
        _error = 'semua field wajib diisi.';
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
      print('login di mulai');
      final res = await AuthService().signInWithEmailPassword(
        email: _emailC.text.trim(),
        password: _passwordC.text.trim(),
      );

      setState(() {
        _info = 'Login berhasil';
      });

      print("berhasil login: ${res.session != null}");
      if (res.session == null) {
        setState(() {
          _error = "Akun belum terverifikasi. Silakan cek email.";
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Home()),
        );

        return;
      }
    } catch (e) {
      setState(() {
        _error = "Terjadi kesalahan, coba lagi";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Masuk',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // textfield email
                      _buildTextField(
                        label: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailC,
                      ),
                      const SizedBox(height: 16),
                      // textfield password
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
                      Align(
                        alignment: Alignment.centerRight,
                        // lupa password
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LupaPassword(),
                              ),
                            );
                          },
                          child: const Text(
                            'Lupa kata sandi?',
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                        ),
                      ),
                      if (_error != null)
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      if (_info != null)
                        Text(
                          _info!,
                          style: const TextStyle(color: Colors.green),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // button login
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Masuk',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Anda Sudah Punya Akun?',
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 5)),
                        child: Text(
                          'Daftar Akun',
                          style: TextStyle(
                            color: Colors.deepOrange,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.deepOrange
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                labelText: label,
                prefixIcon: Icon(icon),
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
                  borderSide: BorderSide(color: Colors.deepOrange, width: 1.5),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
