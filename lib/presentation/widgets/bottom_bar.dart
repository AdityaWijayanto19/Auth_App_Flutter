import 'package:flutter/material.dart';

enum BottomTab { kalkulator, catatan, streak }

class BottomBar extends StatelessWidget {
  final Color primaryOrange;
  final Color navBgPeach;
  final double bottomPadding;
  final BottomTab activeTab;

  const BottomBar({
    super.key,
    required this.primaryOrange,
    required this.navBgPeach,
    required this.bottomPadding,
    required this.activeTab,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SizedBox(
        height: 88 + bottomPadding,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double w = constraints.maxWidth;

            const double horizontalPadding = 72.0;
            const double slotWidth = 64.0;

            final double kalkulatorCenterX =
                horizontalPadding + (slotWidth / 2);
            final double catatanCenterX = w / 2;
            final double streakCenterX =
                w - horizontalPadding - (slotWidth / 2);

            late double activeCenterX;
            switch (activeTab) {
              case BottomTab.kalkulator:
                activeCenterX = kalkulatorCenterX;
                break;
              case BottomTab.catatan:
                activeCenterX = catatanCenterX;
                break;
              case BottomTab.streak:
                activeCenterX = streakCenterX;
                break;
            }

            const double circleSize = 72;
            const double circleRadius = circleSize / 2;

            final double circleLeft = activeCenterX - circleRadius;
            final double circleBottom = bottomPadding + 20;

            return Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                // BACKGROUND + BUMP
                Positioned.fill(
                  child: CustomPaint(
                    painter: NavBackgroundWithBumpPainter(
                      color: navBgPeach,
                      bumpCenterX: activeCenterX,
                      radius: 28,
                    ),
                  ),
                ),

                // ROW ICON (DEFAULT STATE)
                Positioned(
                  bottom: bottomPadding + 18,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildNavSlot(
                          context: context,
                          tab: BottomTab.kalkulator,
                          icon: Icons.monitor_weight_outlined,
                          label: "Kalkulator",
                          width: slotWidth,
                          routeName: '',
                        ),
                        _buildNavSlot(
                          context: context,
                          tab: BottomTab.catatan,
                          icon: Icons.pie_chart_rounded,
                          label: "Catatan",
                          width: slotWidth,
                          routeName: '', 
                        ),
                        _buildNavSlot(
                          context: context,
                          tab: BottomTab.streak,
                          icon: Icons.local_fire_department_rounded,
                          label: "Streak",
                          width: slotWidth,
                          routeName: '',
                        ),
                      ],
                    ),
                  ),
                ),

                // LINGKARAN AKTIF
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.fastOutSlowIn,
                  left: circleLeft,
                  bottom: circleBottom,
                  child: Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryOrange,
                      boxShadow: [
                        BoxShadow(
                          color: primaryOrange.withOpacity(0.3),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _iconForTab(activeTab),
                          color: Colors.white,
                          size: 26,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _labelForTab(activeTab),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // SLOT NAV
  Widget _buildNavSlot({
    required BuildContext context,
    required BottomTab tab,
    required IconData icon,
    required String label,
    required double width,
    required String routeName,
  }) {
    final bool isActive = activeTab == tab;

    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isActive ? 0.0 : 1.0,
          child: IgnorePointer(
            ignoring: isActive,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 24, color: primaryOrange),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: primaryOrange,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconForTab(BottomTab tab) {
    switch (tab) {
      case BottomTab.kalkulator:
        return Icons.monitor_weight_outlined;
      case BottomTab.catatan:
        return Icons.pie_chart_rounded;
      case BottomTab.streak:
        return Icons.local_fire_department_rounded;
    }
  }

  String _labelForTab(BottomTab tab) {
    switch (tab) {
      case BottomTab.kalkulator:
        return "Kalkulator";
      case BottomTab.catatan:
        return "Catatan";
      case BottomTab.streak:
        return "Streak";
    }
  }
}

class NavBackgroundWithBumpPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double bumpCenterX;

  NavBackgroundWithBumpPainter({
    required this.color,
    required this.bumpCenterX,
    this.radius = 28,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    final double w = size.width;
    final double h = size.height;
    final double center = bumpCenterX.clamp(60, w - 60);

    const double bumpWidth = 140;
    const double bumpHeight = 16;

    final double startBump = center - bumpWidth / 2;
    final double endBump = center + bumpWidth / 2;

    path.moveTo(0, h);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);

    path.lineTo(startBump, 0);

    path.cubicTo(
      startBump + bumpWidth * 0.25,
      0,
      center - bumpWidth * 0.25,
      -bumpHeight,
      center,
      -bumpHeight,
    );

    path.cubicTo(
      center + bumpWidth * 0.25,
      -bumpHeight,
      endBump - bumpWidth * 0.25,
      0,
      endBump,
      0,
    );

    path.lineTo(w - radius, 0);
    path.quadraticBezierTo(w, 0, w, radius);

    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant NavBackgroundWithBumpPainter oldDelegate) {
    return oldDelegate.bumpCenterX != bumpCenterX ||
        oldDelegate.color != color ||
        oldDelegate.radius != radius;
  }
}
