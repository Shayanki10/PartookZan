import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_logo.dart';
import '../providers/books_provider.dart';
import 'home_screen.dart';

/// Shows the logo, calls the API once to confirm it is reachable,
/// then moves on to the home screen. On failure it offers a retry.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _anim =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _connect());
  }

  Future<void> _connect() async {
    final books = context.read<BooksProvider>();
    // keep the splash visible for at least a moment so it does not flash
    await Future.wait([books.load(), Future.delayed(const Duration(milliseconds: 1500))]);
    if (!mounted || books.state != LoadState.success) return;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => const HomeScreen(),
      transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
    ));
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final books = context.watch<BooksProvider>();
    final failed = books.state == LoadState.error;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.gradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: FadeTransition(
                    opacity: _anim,
                    child: ScaleTransition(
                      scale: Tween(begin: 0.85, end: 1.0)
                          .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutBack)),
                      child: const AppLogo(size: 46),
                    ),
                  ),
                ),
              ),
              if (failed) ...[
                const Icon(Icons.wifi_off_rounded, size: 34, color: Colors.white),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(books.errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.green,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  ),
                  onPressed: _connect,
                  child: const Text('Try again'),
                ),
              ] else ...[
                const SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                ),
                const SizedBox(height: 12),
                const Text('Connecting to the library...',
                    style: TextStyle(color: Colors.white70)),
              ],
              const SizedBox(height: 56),
            ],
          ),
        ),
      ),
    );
  }
}
