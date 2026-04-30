        import 'package:flutter/material.dart';
        import 'package:nomadair_core/core.dart';
        import 'package:nomadair_ui/ui.dart';

        import '../../search/models/search_criteria.dart';

        /// Lesson 15 — Prop Drilling Demo.
        ///
        /// A depth slider (1–6) builds a widget tree where [PassengerCount]
        /// lives at the root but is only consumed at the leaf.
        /// Every intermediate widget must receive and relay both the value
        /// and the callback — the relay cost grows linearly with depth.
        final class PropDrillingDemoWidget extends StatefulWidget {
          const PropDrillingDemoWidget({super.key});
          @override
          State<PropDrillingDemoWidget> createState() =>
              _PropDrillingDemoWidgetState();
        }

        final class _PropDrillingDemoWidgetState
            extends State<PropDrillingDemoWidget> {
          int           _depth      = 3;
          PassengerCount _passengers = const PassengerCount();

          void _setPassengers(PassengerCount p) =>
              setState(() => _passengers = p);

          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            final relayCount = _depth - 1;
            final paramCount = relayCount * 2; // value + callback per relay

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Controls ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text('Tree depth: $_depth',
                          style: AppTypography.headlineSmall.copyWith(
                            color: t.onSurfaceColor)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs),
                          decoration: BoxDecoration(
                            color: paramCount > 4
                                ? t.errorColor.withAlpha(18)
                                : t.successColor.withAlpha(18),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusFull),
                            border: Border.all(
                              color: paramCount > 4
                                  ? t.errorColor.withAlpha(80)
                                  : t.successColor.withAlpha(80))),
                          child: Text(
                            '$paramCount relay params',
                            style: AppTypography.monoSmall.copyWith(
                              color: paramCount > 4
                                  ? t.errorColor
                                  : t.successColor,
                              fontWeight: FontWeight.w700))),
                      ]),
                      Slider(
                        value:    _depth.toDouble(),
                        min:      1, max: 6, divisions: 5,
                        label:    '$_depth',
                        onChanged: (v) =>
                            setState(() => _depth = v.round()),
                      ),
                      Text(
                        _depth <= 2
                          ? 'Shallow tree: prop drilling is manageable'
                          : _depth <= 4
                          ? 'Medium tree: relay params accumulate'
                          : 'Deep tree: this is why we need Provider',
                        style: AppTypography.bodySmall.copyWith(
                          color: _depth <= 2
                              ? t.successColor
                              : _depth <= 4
                              ? t.warningColor
                              : t.errorColor)),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ),
                ),

                // ── Tree visualization ────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(children: [
                      // Root (owns state)
                      _TreeNode(
                        level:     0,
                        label:     '_PropDrillingDemoState',
                        ownsState: true,
                        relays:    false,
                        isLeaf:    _depth == 1,
                        passengers: _passengers,
                        onChanged:  _setPassengers,
                        totalDepth: _depth,
                        child: _depth > 1
                            ? _buildTree(1, _passengers, _setPassengers)
                            : null,
                      ),
                    ]),
                  ),
                ),
              ],
            );
          }

          Widget _buildTree(int level, PassengerCount value,
              ValueChanged<PassengerCount> onChanged) {
            if (level >= _depth) return const SizedBox.shrink();
            final isLeaf = level == _depth - 1;
            return _TreeNode(
              level:      level,
              label:      isLeaf ? '_LeafWidget (USES state)' : '_RelayWidget',
              ownsState:  false,
              relays:     !isLeaf,
              isLeaf:     isLeaf,
              passengers: value,
              onChanged:  onChanged,
              totalDepth: _depth,
              child: isLeaf ? null : _buildTree(level + 1, value, onChanged),
            );
          }
        }

        final class _TreeNode extends StatelessWidget {
          const _TreeNode({
            required this.level,
            required this.label,
            required this.ownsState,
            required this.relays,
            required this.isLeaf,
            required this.passengers,
            required this.onChanged,
            required this.totalDepth,
            this.child,
          });

          final int            level;
          final String         label;
          final bool           ownsState;
          final bool           relays;
          final bool           isLeaf;
          final PassengerCount passengers;
          final ValueChanged<PassengerCount> onChanged;
          final int            totalDepth;
          final Widget?        child;

          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            final indent = level * 16.0;

            final borderColor = ownsState
                ? AppColors.blue600
                : isLeaf
                ? AppColors.green500
                : AppColors.amber600;

            final bg = ownsState
                ? AppColors.blue600.withAlpha(10)
                : isLeaf
                ? AppColors.green500.withAlpha(10)
                : AppColors.amber600.withAlpha(10);

            return Padding(
              padding: EdgeInsets.only(left: indent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(color: borderColor.withAlpha(100),
                        width: isLeaf || ownsState ? 2 : 1)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text('L$level ',
                            style: AppTypography.monoSmall.copyWith(
                              color: borderColor, fontWeight: FontWeight.w700)),
                          Expanded(child: Text(label,
                            style: AppTypography.monoSmall.copyWith(
                              color: t.onSurfaceColor))),
                        ]),
                        if (relays) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '  passengers: PassengerCount  ← receives, passes down\n'
                            '  onChanged: ValueChanged<PassengerCount>  ← relay',
                            style: AppTypography.monoSmall.copyWith(
                              color: t.warningColor, fontSize: 9)),
                        ],
                        if (ownsState) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '  PassengerCount _passengers  ← STATE LIVES HERE\n'
                            '  void _setPassengers(...)    ← setState owner',
                            style: AppTypography.monoSmall.copyWith(
                              color: AppColors.blue600, fontSize: 9)),
                        ],
                        if (isLeaf) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '  // Finally uses passengers:\n'
                            '  Text(passengers.summary)    ← READS\n'
                            '  PassengerCountSelector(onChanged: onChanged)',
                            style: AppTypography.monoSmall.copyWith(
                              color: AppColors.green500, fontSize: 9)),
                          const SizedBox(height: AppSpacing.sm),
                          // Show current value + edit control
                          Row(children: [
                            Expanded(child: Text(passengers.summary,
                              style: AppTypography.labelLarge.copyWith(
                                color: t.onSurfaceColor))),
                            _PaxButtons(
                              passengers: passengers,
                              onChanged: onChanged),
                          ]),
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

        final class _PaxButtons extends StatelessWidget {
          const _PaxButtons({
            required this.passengers,
            required this.onChanged,
          });
          final PassengerCount passengers;
          final ValueChanged<PassengerCount> onChanged;

          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            return Row(children: [
              Semantics(label: 'Remove adult', button: true,
                child: IconButton(
                  icon: Icon(Icons.remove_circle_outline,
                    color: passengers.adults <= 1
                        ? t.onSurfaceColor.withAlpha(40)
                        : AppColors.green500),
                  onPressed: passengers.adults <= 1 ? null : () =>
                      onChanged(passengers.copyWith(
                        adults: passengers.adults - 1)))),
              Text('${passengers.adults}',
                style: AppTypography.headlineMedium.copyWith(
                  color: t.onSurfaceColor)),
              Semantics(label: 'Add adult', button: true,
                child: IconButton(
                  icon: Icon(Icons.add_circle_outline,
                    color: passengers.adults >= 9
                        ? t.onSurfaceColor.withAlpha(40)
                        : AppColors.green500),
                  onPressed: passengers.adults >= 9 ? null : () =>
                      onChanged(passengers.copyWith(
                        adults: passengers.adults + 1)))),
            ]);
          }
        }
