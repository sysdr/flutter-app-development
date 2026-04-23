import 'package:flutter/material.dart';
import '../../../core/services/theme_preference_service.dart';

final class DarkModeExplorerScreen extends StatefulWidget {
  const DarkModeExplorerScreen({
    required this.service,
    required this.onSaveMode,
    required this.onClearMode,
    super.key,
  });

  final ThemePreferenceService service;
  final Future<void> Function(ThemeMode mode) onSaveMode;
  final Future<void> Function() onClearMode;

  @override
  State<DarkModeExplorerScreen> createState() => _DarkModeExplorerScreenState();
}

final class _DarkModeExplorerScreenState extends State<DarkModeExplorerScreen> {
  bool tintOn = true;
  int launchCount = 0;
  ThemeMode savedMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadPersistState();
  }

  Future<void> _loadPersistState() async {
    final count = await widget.service.getLaunchCount();
    final mode = await widget.service.getSavedThemeMode();
    if (!mounted) return;
    setState(() {
      launchCount = count;
      savedMode = mode;
    });
  }

  Future<void> _save(ThemeMode mode) async {
    await widget.onSaveMode(mode);
    await _loadPersistState();
  }

  Future<void> _clear() async {
    await widget.onClearMode();
    await _loadPersistState();
  }

  String _modeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const lightTokenRows = <(String, String, String)>[
      ('primaryColor', '#1A73E8', '4.98:1'),
      ('onPrimaryColor', '#FFFFFF', '4.98:1'),
      ('surfaceColor', '#FFFFFF', '21.00:1'),
      ('onSurfaceColor', '#1A1A1A', '16.12:1'),
    ];
    const darkTokenRows = <(String, String, String)>[
      ('primaryColor', '#8AB4F8', '4.73:1'),
      ('onPrimaryColor', '#0D47A1', '4.66:1'),
      ('surfaceColor', '#121417', '16.30:1'),
      ('onSurfaceColor', '#E6E6E6', '15.20:1'),
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('DarkModeExplorer'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'TOKENS'),
              Tab(text: 'TINTING'),
              Tab(text: 'PERSIST'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(12),
              children: [
                const Text('LIGHT THEME    |    DARK THEME'),
                const SizedBox(height: 12),
                for (var i = 0; i < lightTokenRows.length; i++)
                  Card(
                    child: ListTile(
                      dense: true,
                      title: Text('${lightTokenRows[i].$1} | ${darkTokenRows[i].$1}'),
                      subtitle: Text(
                        '${lightTokenRows[i].$2} (${lightTokenRows[i].$3})    ->    '
                        '${darkTokenRows[i].$2} (${darkTokenRows[i].$3})',
                      ),
                    ),
                  ),
              ],
            ),
            ListView(
              padding: const EdgeInsets.all(12),
              children: [
                SwitchListTile(
                  title: const Text('Dark Tint'),
                  subtitle: const Text('Apply image overlay tint in dark mode'),
                  value: tintOn,
                  onChanged: (value) => setState(() => tintOn = value),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ListTile(
                        title: Text('Destination Card Preview'),
                        subtitle: Text('Light Mode vs Dark Mode Tint'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(child: Text('Light Mode')),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ColorFiltered(
                                colorFilter: isDark && tintOn
                                    ? const ColorFilter.mode(
                                        Color(0x66303050),
                                        BlendMode.srcATop,
                                      )
                                    : const ColorFilter.mode(
                                        Colors.transparent,
                                        BlendMode.srcATop,
                                      ),
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade400,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      isDark && tintOn ? 'Dark Tint ON' : 'Dark Tint OFF',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Card(
                  child: ListTile(
                    title: const Text('Launch Count'),
                    subtitle: const Text('Number of times app has been launched'),
                    trailing: Text('$launchCount', key: const ValueKey('launch_count')),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    title: const Text('Saved Mode'),
                    subtitle: const Text('The currently saved theme preference'),
                    trailing: Text(
                      _modeText(savedMode),
                      key: const ValueKey('saved_mode'),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _save(ThemeMode.light),
                        child: const Text('Save Light'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => _save(ThemeMode.dark),
                        child: const Text('Save Dark'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _clear,
                        child: const Text('Clear'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
