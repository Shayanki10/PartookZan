import 'package:material_ui/material_ui.dart';

/// Round translucent icon button used on gradient surfaces.
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color color;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 42,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.2),
        ),
        child: Icon(icon, size: size * 0.5, color: color),
      ),
    );
  }
}
