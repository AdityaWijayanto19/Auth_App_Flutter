import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../service/auth_service.dart';

class UbahPassword extends StatefulWidget {
  const UbahPassword({super.key});

  @override
  State<UbahPassword> createState() => _UbahPasswordState();
}

class _UbahPasswordState extends State<UbahPassword> {
  /// ==========================
  /// CONTROLLER BARU DITAMBAHKAN
  /// ==========================
  final _oldPassC = TextEditingController();
  final _newPassC = TextEditingController();
  final _confirmPassC = TextEditingController();

  bool _obscurePasswordOld = true;
  bool _obscurePasswordNew = true;
  bool _obscurePasswordConfirm = true;

  bool _isLoading = false;

  /// =======================================
  /// 🔥 FUNGSI UPDATE PASSWORD SUPABASE
  /// =======================================
  Future<void> _updatePassword() async {
    final oldPass = _oldPassC.text.trim();
    final newPass = _newPassC.text.trim();
    final confirmPass = _confirmPassC.text.trim();

    // Validasi basic
    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      _showMessage("Semua field harus diisi", isError: true);
      return;
    }

    if (newPass != confirmPass) {
      _showMessage("Password baru tidak cocok", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService().changePassword(password: newPass);

      if (!mounted) return;

      _showMessage("Password berhasil diperbarui");

      Navigator.pop(context, true);
    } catch (e) {
      _showMessage("Gagal update password: $e", isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// ===============================
  /// SNACKBAR UNTUK NOTIFIKASI
  /// ===============================
  void _showMessage(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : Colors.green,
        content: Text(msg, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  void dispose() {
    _oldPassC.dispose();
    _newPassC.dispose();
    _confirmPassC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        title: const Text(
          'Ubah Password',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height:
                MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      const Text(
                        "Silakan masukkan kata sandi lama dan baru Anda untuk melanjutkan",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      const SizedBox(height: 70),

                      /// ===========================
                      /// FIELD PASSWORD LAMA
                      /// ===========================
                      _buildTextField(
                        label: 'Password Lama',
                        icon: Icons.lock_outline,
                        obscureText: _obscurePasswordOld,
                        suffixIcon: _obscurePasswordOld
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        onSuffixTap: () {
                          setState(() {
                            _obscurePasswordOld = !_obscurePasswordOld;
                          });
                        },
                        controller: _oldPassC,
                      ),
                      const SizedBox(height: 18),

                      /// ===========================
                      /// FIELD PASSWORD BARU
                      /// ===========================
                      _buildTextField(
                        label: 'Password Baru',
                        icon: Icons.lock_outline,
                        obscureText: _obscurePasswordNew,
                        suffixIcon: _obscurePasswordNew
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        onSuffixTap: () {
                          setState(() {
                            _obscurePasswordNew = !_obscurePasswordNew;
                          });
                        },
                        controller: _newPassC,
                      ),
                      const SizedBox(height: 18),

                      /// ===========================
                      /// FIELD KONFIRMASI PASSWORD BARU
                      /// ===========================
                      _buildTextField(
                        label: 'Konfirmasi Password Baru',
                        icon: Icons.lock_outline,
                        obscureText: _obscurePasswordConfirm,
                        suffixIcon: _obscurePasswordConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        onSuffixTap: () {
                          setState(() {
                            _obscurePasswordConfirm = !_obscurePasswordConfirm;
                          });
                        },
                        controller: _confirmPassC,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                /// ===========================
                /// TOMBOL SIMPAN DATA
                /// ===========================
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Simpan Data",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// =====================================
  /// REUSABLE TEXTFIELD (apa adanya, no change)
  /// =====================================
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
                prefixIcon: Icon(
                  icon,
                  color: hasFocus ? Colors.deepOrange : Colors.grey,
                ),
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
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
