import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

/// Discover Screen — Module 1 Mastery Challenge.
///
/// Patterns demonstrated:
///   - NomadChip filter chips (Lesson 05)
///   - DestinationCard with ColorFilter tinting (Lessons 07, 08)
///   - LayoutBuilder adaptive grid: 1 column < 600dp, 2 columns >= 600dp
///   - All items accessible: MergeSemantics + labels (Lesson 08)
final class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

final class _DiscoverScreenState extends State<DiscoverScreen> {
  String _activeFilter = 'all';

  static const Map<String, String> _filters = {
    'all':     'All',
    'flights': 'Flights',
    'hotels':  'Hotels',
  };

  List<DestinationModel> get _filtered => _activeFilter == 'all'
      ? DestinationModel.samples
      : DestinationModel.samples
          .where((d) =>
              d.category == _activeFilter || d.category == 'both')
          .toList();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Where to next?',
                style: AppTypography.displayLarge.copyWith(
                  color: t.onSurfaceColor,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Handpicked destinations for every traveller',
                style: AppTypography.bodyMedium.copyWith(
                  color: t.onSurfaceColor.withAlpha(160),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Filter chips
              Wrap(
                spacing: AppSpacing.sm,
                children: _filters.entries.map((e) {
                  return NomadChip(
                    label: e.value,
                    variant: const FilterChipVariant(),
                    selected: _activeFilter == e.key,
                    semanticLabel:
                        '${e.value} filter, '
                        '${_activeFilter == e.key ? 'selected' : 'not selected'}',
                    onTap: () =>
                        setState(() => _activeFilter = e.key),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        // ── Destination grid ──────────────────────────────────
        Expanded(
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              // Adaptive grid: 1 col on compact, 2 cols on medium+
              final cols = constraints.maxWidth >= AppSpacing.minTouchTarget * 12
                  ? 2
                  : 1;
              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: cols == 1 ? 1.4 : 0.85,
                ),
                itemCount: _filtered.length,
                itemBuilder: (_, i) => DestinationCard(
                  destination: _filtered[i],
                  onTap: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
