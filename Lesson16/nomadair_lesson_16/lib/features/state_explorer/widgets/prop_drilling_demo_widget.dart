import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import '../../search/models/search_criteria.dart';

final class PropDrillingDemoWidget extends StatefulWidget {
  const PropDrillingDemoWidget({super.key});

  @override
  State<PropDrillingDemoWidget> createState() => _S();
}

final class _S extends State<PropDrillingDemoWidget> {
  int _d = 3;
  PassengerCount _p = const PassengerCount();

  void _set(PassengerCount p) => setState(() => _p = p);

  @override
  Widget build(BuildContext ctx) {
    final t = Theme.of(ctx).extension<NomadThemeExtension>()!;
    final relayCount = _d - 1;
    final paramCount = relayCount * 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tree depth: $_d',
                      style: AppTypography.headlineSmall.copyWith(
                        color: t.onSurfaceColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: paramCount > 4
                          ? t.errorColor.withAlpha(18)
                          : t.successColor.withAlpha(18),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      border: Border.all(
                        color: paramCount > 4
                            ? t.errorColor.withAlpha(80)
                            : t.successColor.withAlpha(80),
                      ),
                    ),
                    child: Text(
                      '$paramCount relay params',
                      style: AppTypography.monoSmall.copyWith(
                        color: paramCount > 4 ? t.errorColor : t.successColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                value: _d.toDouble(),
                min: 1,
                max: 6,
                divisions: 5,
                label: '$_d',
                onChanged: (v) => setState(() => _d = v.round()),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                _Node(
                  level: 0,
                  label: '_PropDemoState',
                  ownsState: true,
                  relays: false,
                  isLeaf: _d == 1,
                  pax: _p,
                  onChange: _set,
                  child: _d > 1 ? _tree(1) : null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tree(int lvl) {
    if (lvl >= _d) return const SizedBox.shrink();
    final leaf = lvl == _d - 1;
    return _Node(
      level: lvl,
      label: leaf ? '_LeafWidget (USES state)' : '_RelayWidget',
      ownsState: false,
      relays: !leaf,
      isLeaf: leaf,
      pax: _p,
      onChange: _set,
      child: leaf ? null : _tree(lvl + 1),
    );
  }
}

final class _Node extends StatelessWidget {
  const _Node({
    required this.level,
    required this.label,
    required this.ownsState,
    required this.relays,
    required this.isLeaf,
    required this.pax,
    required this.onChange,
    this.child,
  });

  final int level;
  final String label;
  final bool ownsState;
  final bool relays;
  final bool isLeaf;
  final PassengerCount pax;
  final ValueChanged<PassengerCount> onChange;
  final Widget? child;

  @override
  Widget build(BuildContext ctx) {
    final t = Theme.of(ctx).extension<NomadThemeExtension>()!;
    final color = ownsState
        ? AppColors.blue600
        : isLeaf
            ? AppColors.green500
            : AppColors.amber600;
    return Padding(
      padding: EdgeInsets.only(left: level * 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: AppSpacing.xs),
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withAlpha(10),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(
                color: color.withAlpha(100),
                width: isLeaf || ownsState ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'L$level $label',
                  style: AppTypography.monoSmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (relays)
                  Text(
                    '  receives (PassengerCount, ValueChanged) · passes down',
                    style: AppTypography.monoSmall.copyWith(
                      color: AppColors.amber600,
                      fontSize: 9,
                    ),
                  ),
                if (isLeaf) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pax.summary,
                          style: AppTypography.labelLarge.copyWith(
                            color: t.onSurfaceColor,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: pax.adults <= 1
                              ? t.onSurfaceColor.withAlpha(40)
                              : AppColors.green500,
                        ),
                        onPressed: pax.adults <= 1
                            ? null
                            : () => onChange(
                                  pax.copyWith(adults: pax.adults - 1),
                                ),
                        iconSize: 22,
                      ),
                      Text(
                        '${pax.adults}',
                        style: AppTypography.headlineMedium.copyWith(
                          color: t.onSurfaceColor,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: pax.adults >= 9
                              ? t.onSurfaceColor.withAlpha(40)
                              : AppColors.green500,
                        ),
                        onPressed: pax.adults >= 9
                            ? null
                            : () => onChange(
                                  pax.copyWith(adults: pax.adults + 1),
                                ),
                        iconSize: 22,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

