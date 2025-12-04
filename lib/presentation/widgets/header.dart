import 'package:flutter/material.dart';
import '../../service/auth_service.dart';
import '../pages/setting.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  Map<String, dynamic>? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await AuthService().getProfile();
    setState(() {
      _profile = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryOrange = const Color(0xFFFF5024);
    final Color textDark = const Color(0xFF2D2D2D);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final name = _profile?['full_name'] ?? 'No Name';
    final avatar = _profile?['avatar_url'];

    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top + 10),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Row(
            children: [
              // ==================== AVATAR ====================
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: avatar != null ? NetworkImage(avatar) : null,
                child: avatar == null
                    ? const Icon(Icons.person, size: 30, color: Colors.white)
                    : null,
              ),

              const SizedBox(width: 12),

              // ==================== NAME ====================
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: textDark,
                ),
              ),

              const SizedBox(width: 4),
              const Text("🔥", style: TextStyle(fontSize: 20)),

              const Spacer(),

              // ==================== SETTINGS ====================
              InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Setting()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.settings_outlined,
                    color: primaryOrange,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
