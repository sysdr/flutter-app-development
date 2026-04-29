        import 'package:flutter/material.dart';
        import 'package:flutter/services.dart';
        import 'package:go_router/go_router.dart';
        import 'package:nomadair_core/core.dart';
        import 'package:nomadair_ui/ui.dart';

        import '../../../deep_links/deep_link_config.dart';
        import '../../../deep_links/deep_link_handler.dart';
        import '../../../router/navigator_routes.dart';

        /// Lesson 12 Visualizer — Deep Link Explorer.
        ///
        /// Three tabs:
        ///   Simulate : tap to navigate as if deep link arrived
        ///   ADB Cmds : copy-ready adb shell commands
        ///   Manifest : AndroidManifest.xml intent filter display
        final class DeepLinkExplorerScreen extends StatefulWidget {
          const DeepLinkExplorerScreen({super.key});

          @override
          State<DeepLinkExplorerScreen> createState() =>
              _DeepLinkExplorerScreenState();
        }

        final class _DeepLinkExplorerScreenState
            extends State<DeepLinkExplorerScreen>
            with SingleTickerProviderStateMixin {
          late final TabController _tab;

          @override
          void initState() {
            super.initState();
            _tab = TabController(length: 3, vsync: this);
          }

          @override
          void dispose() { _tab.dispose(); super.dispose(); }

          @override
          Widget build(BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Deep Link Explorer'),
                centerTitle: true,
                surfaceTintColor: Colors.transparent,
                bottom: TabBar(
                  controller: _tab,
                  tabs: const [
                    Tab(text: 'Simulate'),
                    Tab(text: 'ADB Commands'),
                    Tab(text: 'Manifest'),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tab,
                children: const [
                  _SimulateTab(),
                  _AdbTab(),
                  _ManifestTab(),
                ],
              ),
            );
          }
        }

        // ══════════════════════════════════════════════════════════════════════
        // TAB 1: Simulate
        // ══════════════════════════════════════════════════════════════════════

        final class _SimulateTab extends StatefulWidget {
          const _SimulateTab();

          @override
          State<_SimulateTab> createState() => _SimulateTabState();
        }

        final class _SimulateTabState extends State<_SimulateTab> {
          String? _lastNavigated;

          void _simulateDeepLink(BuildContext context, DeepLinkEntry entry) {
            // Parse the scheme URL and translate to GoRouter path
            final uri       = Uri.parse(entry.scheme);
            final goPath    = DeepLinkHandler.translate(uri) ?? entry.goPath;

            setState(() => _lastNavigated = goPath);

            // Navigate: GoRouter handles the translated path
            context.go(goPath);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Deep link → $goPath'),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            final entries = DeepLinkConfig.entries;

            return Column(
              children: [
                // Cold/Warm start explainer
                Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  child: Row(children: [
                    ExcludeSemantics(child: Icon(
                      Icons.info_outline, size: 16,
                      color: t.brandPrimary)),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(child: Text(
                      'Tap a link to simulate deep link navigation. '
                      'For real cold/warm start, use the ADB Commands tab.',
                      style: AppTypography.bodySmall.copyWith(
                        color: t.onSurfaceColor.withAlpha(160)))),
                  ]),
                ),
                if (_lastNavigated != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                    color: t.brandPrimary.withAlpha(12),
                    child: Text(
                      'Last navigated: $_lastNavigated',
                      style: AppTypography.monoSmall.copyWith(
                        color: t.brandPrimary)),
                  ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: entries.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (_, i) =>
                        _DeepLinkCard(
                          entry: entries[i],
                          onSimulate: () =>
                              _simulateDeepLink(context, entries[i]),
                        ),
                  ),
                ),
              ],
            );
          }
        }

        final class _DeepLinkCard extends StatelessWidget {
          const _DeepLinkCard({
            super.key,
            required this.entry,
            required this.onSimulate,
          });

          final DeepLinkEntry entry;
          final VoidCallback  onSimulate;

          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            return Semantics(
              label: 'Deep link: ${entry.title}. ${entry.description}',
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + badge
                      Row(children: [
                        Text(entry.title,
                          style: AppTypography.headlineSmall.copyWith(
                            color: t.onSurfaceColor)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs, vertical: 2),
                          decoration: BoxDecoration(
                            color: t.brandPrimary.withAlpha(18),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusFull),
                            border: Border.all(
                              color: t.brandPrimary.withAlpha(80))),
                          child: Text(entry.goPath,
                            style: AppTypography.monoSmall.copyWith(
                              color: t.brandPrimary, fontSize: 9))),
                      ]),
                      const SizedBox(height: AppSpacing.xs),
                      Text(entry.description,
                        style: AppTypography.bodySmall.copyWith(
                          color: t.onSurfaceColor.withAlpha(160))),
                      const SizedBox(height: AppSpacing.sm),
                      // URLs
                      _UrlRow(label: 'custom', url: entry.scheme),
                      const SizedBox(height: AppSpacing.xs),
                      _UrlRow(label: 'https ', url: entry.https),
                      const SizedBox(height: AppSpacing.md),
                      NomadButton(
                        label: 'Simulate Deep Link',
                        icon: Icons.open_in_browser,
                        semanticLabel:
                            'Simulate ${entry.title} deep link navigation',
                        onPressed: onSimulate,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }

        final class _UrlRow extends StatelessWidget {
          const _UrlRow({super.key, required this.label, required this.url});
          final String label, url;

          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            return Row(children: [
              Text('$label  ',
                style: AppTypography.monoSmall.copyWith(
                  color: t.onSurfaceColor.withAlpha(140))),
              Expanded(child: Text(url,
                style: AppTypography.monoSmall.copyWith(
                  color: t.brandPrimary),
                overflow: TextOverflow.ellipsis)),
            ]);
          }
        }

        // ══════════════════════════════════════════════════════════════════════
        // TAB 2: ADB Commands
        // ══════════════════════════════════════════════════════════════════════

        final class _AdbTab extends StatelessWidget {
          const _AdbTab();

          @override
          Widget build(BuildContext context) {
            final t       = Theme.of(context).extension<NomadThemeExtension>()!;
            final entries = DeepLinkConfig.entries;

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Text('ADB Deep Link Commands',
                  style: AppTypography.headlineLarge.copyWith(
                    color: t.onSurfaceColor)),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Run from Windows terminal with AVD running.\n'
                  'Cold start: force-stop the app first.',
                  style: AppTypography.bodySmall.copyWith(
                    color: t.onSurfaceColor.withAlpha(160))),
                const SizedBox(height: AppSpacing.sm),
                // Force-stop command
                _AdbCommandCard(
                  title: 'Force Stop (for cold start test)',
                  command:
                    'adb shell am force-stop ${APP_ID}',
                  color: AppColors.red500,
                ),
                const SizedBox(height: AppSpacing.sm),
                ...entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _AdbCommandCard(
                      title: e.title,
                      command: e.adbScheme,
                      color: t.brandPrimary,
                    ),
                  );
                }),
                const SizedBox(height: AppSpacing.md),
                // Warm start note
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.amber50,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColors.amber600.withAlpha(120))),
                  child: Text(
                    'Warm start: run a command WITHOUT force-stopping first.\n'
                    'The existing Activity receives onNewIntent(), and\n'
                    'GoRouter processes the new URI immediately.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.amber700))),
                const SizedBox(height: AppSpacing.xl),
              ],
            );
          }
        }

        final class _AdbCommandCard extends StatefulWidget {
          const _AdbCommandCard({
            super.key,
            required this.title,
            required this.command,
            required this.color,
          });
          final String title, command;
          final Color  color;

          @override
          State<_AdbCommandCard> createState() => _AdbCommandCardState();
        }

        final class _AdbCommandCardState extends State<_AdbCommandCard> {
          bool _copied = false;

          Future<void> _copy() async {
            await Clipboard.setData(ClipboardData(text: widget.command));
            if (!mounted) return;
            setState(() => _copied = true);
            await Future<void>.delayed(const Duration(seconds: 2));
            if (mounted) setState(() => _copied = false);
          }

          @override
          Widget build(BuildContext context) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.title,
                    style: AppTypography.labelLarge.copyWith(
                      color: widget.color)),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D1117),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm)),
                    child: Text(widget.command,
                      style: AppTypography.monoSmall.copyWith(
                        color: const Color(0xFFC9D1D9), height: 1.5))),
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 130,
                      child: OutlinedButton.icon(
                        icon: Icon(
                          _copied ? Icons.check : Icons.copy,
                          size: 14),
                        label: Text(_copied ? 'Copied!' : 'Copy'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: widget.color,
                          side: BorderSide(color: widget.color.withAlpha(120)),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                        ),
                        onPressed: _copy,
                      ),
                    ),
                  ),
                ]),
              ),
            );
          }
        }

        // ══════════════════════════════════════════════════════════════════════
        // TAB 3: Manifest
        // ══════════════════════════════════════════════════════════════════════

        final class _ManifestTab extends StatelessWidget {
          const _ManifestTab();

          static const String _manifest = r'''<manifest ...>
  <application ...>
    <activity
        android:name=".MainActivity"
        android:exported="true"
        android:launchMode="singleTop"   ← critical!
        ...>

      <!-- LAUNCHER intent (default Flutter) -->
      <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
      </intent-filter>

      <!-- Custom scheme: nomadair:// -->
      <intent-filter android:autoVerify="false">
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="nomadair"/>
      </intent-filter>

      <!-- HTTPS App Links: https://nomadair.com -->
      <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="https"
              android:host="nomadair.com"/>
      </intent-filter>

    </activity>
  </application>
</manifest>''';

          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Text('AndroidManifest.xml Intent Filters',
                  style: AppTypography.headlineLarge.copyWith(
                    color: t.onSurfaceColor)),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'android/app/src/main/AndroidManifest.xml\n'
                  'This file is written by the generator and appears in '
                  'the Android module of the project.',
                  style: AppTypography.bodySmall.copyWith(
                    color: t.onSurfaceColor.withAlpha(160))),
                const SizedBox(height: AppSpacing.lg),

                // Key concepts
                _ConceptCard(
                  title: 'launchMode="singleTop"',
                  color: AppColors.red500,
                  body:
                    'Without singleTop: each deep link tap creates a new '
                    'FlutterActivity — multiple app instances with separate state.\n\n'
                    'With singleTop: Android calls onNewIntent() on the existing '
                    'Activity, delivering the new URI to Flutter\'s navigation channel.',
                ),
                const SizedBox(height: AppSpacing.md),

                _ConceptCard(
                  title: 'autoVerify="true" (HTTPS App Links)',
                  color: AppColors.amber600,
                  body:
                    'Android fetches https://nomadair.com/.well-known/assetlinks.json '
                    'during APK install and verifies the signing certificate.\n\n'
                    'Without a real server, verification fails silently and the '
                    'link opens in a browser. Lesson 25 configures Firebase Hosting '
                    'to serve the assetlinks.json for production push notifications.',
                ),
                const SizedBox(height: AppSpacing.md),

                // Manifest code
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1117),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                  child: Text(_manifest,
                    style: AppTypography.monoSmall.copyWith(
                      color: const Color(0xFFC9D1D9), height: 1.7))),
                const SizedBox(height: AppSpacing.xl),
              ],
            );
          }
        }

        final class _ConceptCard extends StatelessWidget {
          const _ConceptCard({
            super.key,
            required this.title,
            required this.color,
            required this.body,
          });
          final String title, body;
          final Color  color;

          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            return Card(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: color.withAlpha(20),
                    border: Border(bottom: BorderSide(color: color.withAlpha(60)))),
                  child: Text(title,
                    style: AppTypography.labelLarge.copyWith(
                      fontFamily: 'monospace', color: color))),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Text(body,
                    style: AppTypography.bodySmall.copyWith(
                      color: t.onSurfaceColor.withAlpha(200)))),
              ]),
            );
          }
        }
