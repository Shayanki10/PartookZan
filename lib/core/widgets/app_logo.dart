import 'package:material_ui/material_ui.dart';

/// "PartookZan" wordmark where the double "oo" in "Partook" is drawn as sunglasses.
class AppLogo extends StatelessWidget {
  final double size;
  final Color color;
  const AppLogo({super.key, this.size = 32, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color,
      height: 1.1,
      letterSpacing: -0.5,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      // The glasses have no text baseline, so their bottom edge sits on the
      // baseline, exactly where the lowercase "oo" would be.
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text('Part', style: style),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size * 0.03),
          child: _Glasses(height: size * 0.56, color: color),
        ),
        Text('kZan', style: style),
      ],
    );
  }
}

class _Glasses extends StatelessWidget {
  final double height;
  final Color color;
  const _Glasses({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    final stroke = height * 0.17;
    Widget lens() => Container(
          width: height,
          height: height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.38), // tinted lens
            border: Border.all(color: color, width: stroke),
          ),
        );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        lens(),
        Container(
          width: height * 0.22,
          height: stroke,
          margin: EdgeInsets.only(bottom: height * 0.15),
          color: color,
        ), // bridge
        lens(),
      ],
    );
  }
}
