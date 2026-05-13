import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import '../models/recent_search.dart';

class RecentSearchesWidget extends StatelessWidget {
  const RecentSearchesWidget({
    super.key,
    required this.searches,
    required this.onSelected,
    this.onClear,
  });

  final List<RecentSearch>       searches;
  final ValueChanged<RecentSearch> onSelected;
  final VoidCallback?            onClear;

  @override
  Widget build(BuildContext context) {
    if (searches.isEmpty) return const SizedBox.shrink();
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.xs, AppSpacing.md, 0),
          child: Row(children: [
            Text('Recent',
              style: AppTypography.labelMedium.copyWith(
                color: t.onSurfaceColor.withAlpha(140))),
            const Spacer(),
            if (onClear != null)
              GestureDetector(
                onTap: onClear,
                child: Text('Clear',
                  style: AppTypography.labelMedium.copyWith(
                    color: t.brandPrimary))),
          ]),
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md),
            scrollDirection: Axis.horizontal,
            itemCount: searches.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppSpacing.sm),
            itemBuilder: (_, i) => _Chip(
              search: searches[i],
              onTap: () => onSelected(searches[i]),
              t: t,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.search, required this.onTap, required this.t});
  final RecentSearch search;
  final VoidCallback onTap;
  final NomadThemeExtension t;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '${search.routeLabel}, ${search.detailLabel}',
    button: true,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          border: Border.all(color: t.dividerColor),
          borderRadius:
              BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history, size: 13,
              color: t.onSurfaceColor.withAlpha(100)),
            const SizedBox(width: 4),
            Text(search.routeLabel,
              style: AppTypography.labelMedium.copyWith(
                color: t.onSurfaceColor)),
            const SizedBox(width: 4),
            Text('· ${search.detailLabel}',
              style: AppTypography.bodySmall.copyWith(
                color: t.onSurfaceColor.withAlpha(160))),
          ],
        ),
      ),
    ),
  );
}
