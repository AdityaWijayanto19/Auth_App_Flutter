import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String username;
  final String profileImageUrl;
  final VoidCallback? onSettingsTap;

  const Header({
    super.key,
    this.username = "Itami",
    this.profileImageUrl = 'https://i.imgur.com/BoN9kdC.png',
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryOrange = const Color(0xFFFF5024);
    final Color textDark = const Color(0xFF2D2D2D);

    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top + 10),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(profileImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Text(
                username,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: textDark,
                ),
              ),
              const SizedBox(width: 4),
              const Text("🔥", style: TextStyle(fontSize: 20)),

              const Spacer(),

              InkWell(
                onTap: onSettingsTap,
                child: Container(
                  color: Colors.transparent,
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
