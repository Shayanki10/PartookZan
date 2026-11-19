import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const GradientButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: AppTheme.gradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppTheme.green.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(label,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
