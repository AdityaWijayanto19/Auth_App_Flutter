import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart'; 

class LupaPassword extends StatefulWidget {
  const LupaPassword({super.key});

  @override
  State<LupaPassword> createState() => _LupaPasswordState();
}

class _LupaPasswordState extends State<LupaPassword> {
  // 0: Halaman Lupa Password (Masukkan Email)
  // 1: Halaman Reset Password (Masukkan OTP & Sandi Baru)
  // 2: Halaman Sukses
  int _tampilanSaatIni = 0;

  // Variabel untuk Halaman 1 (OTP)
  late List<TextEditingController> _otpControllers;
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  int _seconds = 60;
  bool _canResend = false;
  Timer? _timer;
  final String _emailMasked = 'itam*****@gmail.com'; // Contoh email masked

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(6, (_) => TextEditingController());
    // Mulai timer hanya jika tampilan awal adalah OTP (misalnya jika pengguna langsung ke sana)
    // Dalam kasus ini, kita akan memulai timer saat berpindah ke Tampilan 1.
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  // --- Fungsi Timer OTP ---

  void _startTimer() {
    _seconds = 60;
    _canResend = false;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) { // Pastikan widget masih ada sebelum memanggil setState
        timer.cancel();
        return;
      }
      if (_seconds == 0) {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  void _resendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Kode verifikasi telah dikirim ulang ke email Anda"),
      ),
    );
    _startTimer();
  }

  // Fungsi untuk beralih tampilan
  void _gantiTampilan(int index) {
    if (index == 1) {
      // Jika beralih ke tampilan OTP, mulai timer
      _startTimer();
    } else if (_timer != null && _timer!.isActive) {
      // Hentikan timer jika beralih dari tampilan OTP
      _timer?.cancel();
    }
    setState(() {
      _tampilanSaatIni = index;
    });
  }

  // --- Widget Utama Build ---

  @override
  Widget build(BuildContext context) {
    return _tampilanSaatIni == 0
        ? _buildHalamanEmail()
        : _tampilanSaatIni == 1
            ? _buildHalamanOTP()
            : _buildHalamanSukses();
  }

  // --- Tampilan 0: Meminta Email ---

  Widget _buildHalamanEmail() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Lupa Kata Sandi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        textAlign: TextAlign.center,
                        'Kami akan mengirimkan kode pengaturan ulang kata sandi ke akun email Anda.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      _buildTextFieldEmail(), // Menggunakan widget TextField khusus email
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Logika untuk mengirim kode
                      // Setelah berhasil, beralih ke Tampilan 1 (OTP)
                      _gantiTampilan(1);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Kirim kode',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget TextField khusus Halaman Email
  Widget _buildTextFieldEmail() {
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
              cursorColor: Colors.deepOrange,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
                floatingLabelStyle: const TextStyle(color: Colors.deepOrange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: hasFocus ? Colors.deepOrange : Colors.grey.shade300,
                    width: 0.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: hasFocus ? Colors.deepOrange : Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.deepOrange, width: 1.5),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Tampilan 1: Memasukkan OTP & Sandi Baru ---

  Widget _buildHalamanOTP() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            // Kembali ke halaman sebelumnya (lupa password email)
            _gantiTampilan(0);
          },
        ),
        title: const Text(
          'Reset password',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  text:
                      'Silakan masukkan kode pengaturan ulang kata sandi yang telah kami kirim ke email Anda, ',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: _emailMasked,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 48,
                        height: 56,
                        child: Focus(
                          child: Builder(
                            builder: (context) {
                              final hasFocus = Focus.of(context).hasFocus;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: hasFocus
                                        ? Colors.deepOrange
                                        : Colors.grey.shade400,
                                    width: hasFocus ? 1.5 : 1,
                                  ),
                                ),
                                child: TextField(
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  cursorColor: Colors.deepOrange,
                                  decoration: const InputDecoration(
                                    counterText: "",
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty && index < 5) {
                                      FocusScope.of(
                                              context)
                                          .requestFocus(_focusNodes[index + 1]);
                                    }
                                    if (value.isEmpty && index > 0) {
                                      FocusScope.of(
                                              context)
                                          .requestFocus(_focusNodes[index - 1]);
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  _canResend
                      ? GestureDetector(
                          onTap: _resendCode,
                          child: const Text(
                            "Belum menerima kode? Kirim ulang",
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : Text(
                          _seconds == 0
                              ? "Kirim ulang kode OTP"
                              : "Kirim ulang dalam 00:${(_seconds < 0 ? 0 : _seconds > 60 ? 60 : _seconds).toString().padLeft(2, '0')}",
                          style: TextStyle(
                            color: _seconds == 0 ? Colors.blue : Colors.grey,
                            fontWeight: _seconds == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                  const SizedBox(height: 32),
                  _buildPasswordField('Kata sandi baru'),
                  const SizedBox(height: 16),
                  _buildPasswordField('Ulangi sandi baru'),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Logika untuk reset password
                    // Setelah berhasil, beralih ke Tampilan 2 (Sukses)
                    _gantiTampilan(2);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Widget TextField khusus Password (dari file reset_password)
  Widget _buildPasswordField(String label) {
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
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: TextField(
              obscureText: true,
              cursorColor: Colors.deepOrange,
              decoration: InputDecoration(
                labelText: label,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: const Icon(
                  Icons.visibility_off_outlined,
                  color: Colors.grey,
                ),
                floatingLabelStyle: const TextStyle(color: Colors.deepOrange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: hasFocus ? Colors.deepOrange : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.deepOrange,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Tampilan 2: Sukses ---

  Widget _buildHalamanSukses() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Langsung kembali ke halaman Login
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginForm()),
              (route) => false,
            );
          },
        ),
        title: const Text(
          'Sukses!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.deepOrange,
                size: 100,
              ),
              const SizedBox(height: 24),
              const Text(
                'Kata Sandi Berhasil Diperbarui',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 12),
              const Text(
                'Sekarang Anda bisa masuk dengan kata sandi baru Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Kembali ke halaman Login
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginForm()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Kembali ke Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}