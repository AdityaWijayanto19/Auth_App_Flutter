import 'package:auth_app/presentation/pages/setting.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/header.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Color primaryOrange = const Color(0xFFFF5024);
  final Color navBgPeach = const Color(0xFFFFF0EB);

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Stack(
        children: [
          // ====== KONTEN DASHBOARD ======
          Header(),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _emptyState(
                    "Anda belum memiliki data kalori saat ini. Silakan lengkapi data pribadi dan target kalori Anda terlebih dahulu untuk menampilkan indikator pada dashboard.",
                  ),
                ),
              ],
            ),
          ),

          // ====== BOTTOM BAR ======
          BottomBar(
            primaryOrange: primaryOrange,
            navBgPeach: navBgPeach,
            bottomPadding: bottomPadding,
            activeTab: BottomTab.catatan,
          ),
        ],
      ),
    );
  }

  Widget _emptyState(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: primaryOrange,
            fontSize: 13,
            height: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 35),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: primaryOrange, width: 3),
          ),
          child: Center(child: Icon(Icons.add, color: primaryOrange, size: 38)),
        ),
        // Tambahkan space di bawah agar tidak tertutup navbar jika di-scroll (opsional jika nanti pakai ListView)
      ],
    );
  }
}
