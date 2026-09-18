import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  // Enable performance overlay programmatically for verification
  // Toggle via Flutter Inspector in Android Studio instead
  runApp(const Lesson2VerificationApp());
}

class Lesson2VerificationApp extends StatelessWidget {
  const Lesson2VerificationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lesson 2 Verification',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A73E8)),
        useMaterial3: true,
      ),
      home: const HotReloadVerificationScreen(),
    );
  }
}

class HotReloadVerificationScreen extends StatefulWidget {
  const HotReloadVerificationScreen({super.key});

  @override
  State<HotReloadVerificationScreen> createState() =>
      _HotReloadVerificationScreenState();
}

class _HotReloadVerificationScreenState
    extends State<HotReloadVerificationScreen>
    with SingleTickerProviderStateMixin {
  int _reloadCount = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // ── HOT RELOAD VERIFICATION INSTRUCTION ──────────────────────────────────
  // Change this string, save the file, and verify the UI updates in < 1.5s
  // without losing _reloadCount state. That's hot reload working correctly.
  static const String _verificationLabel = 'HOT RELOAD READY';
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text('Lesson 2 — Hot Reload Verifier'),
        backgroundColor: const Color(0xFF1A73E8),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A73E8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1A73E8).withOpacity(0.35),
                      blurRadius: 32,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.bolt, color: Colors.white, size: 80),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              _verificationLabel,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF1A73E8),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'State preserved across $_reloadCount reload(s)',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),
            FilledButton.icon(
              onPressed: () => setState(() => _reloadCount++),
              icon: const Icon(Icons.refresh),
              label: const Text('Simulate Reload Event'),
            ),
            const SizedBox(height: 24),
            _PerformanceGuide(),
          ],
        ),
      ),
    );
  }
}

class _PerformanceGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E8FF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _GuideRow(icon: Icons.timer, label: 'Hot reload target', value: '< 1.5s'),
          _GuideRow(icon: Icons.speed, label: 'UI thread budget', value: '< 12ms'),
          _GuideRow(icon: Icons.memory, label: 'GPU thread budget', value: '< 12ms'),
        ],
      ),
    );
  }
}

class _GuideRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _GuideRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF1A73E8)),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF34A853),
            ),
          ),
        ],
      ),
    );
  }
}
