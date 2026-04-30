        import 'package:flutter/material.dart';
        import 'package:nomadair_core/core.dart';

        /// Lesson 15 — Rebuild Tracker.
        ///
        /// Two modes:
        ///   Correct:      counter state lives inside [_IsolatedCounter].
        ///                 Only [_IsolatedCounter] rebuilds on increment.
        ///   Anti-pattern: counter value lifted to parent via setState.
        ///                 Entire parent + all siblings rebuild on increment.
        final class RebuildTrackerWidget extends StatefulWidget {
          const RebuildTrackerWidget({super.key});
          @override
          State<RebuildTrackerWidget> createState() =>
              _RebuildTrackerWidgetState();
        }

        final class _RebuildTrackerWidgetState
            extends State<RebuildTrackerWidget> {
          bool _antiPattern = false;
          int  _parentCount = 0; // only used in anti-pattern mode

          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Mode toggle ───────────────────────────────────────
                SwitchListTile(
                  value:    _antiPattern,
                  onChanged: (v) =>
                      setState(() { _antiPattern = v; _parentCount = 0; }),
                  title: Text(_antiPattern
                      ? 'Anti-pattern: state lifted to parent'
                      : 'Correct: state isolated in counter',
                    style: AppTypography.labelLarge.copyWith(
                      color: _antiPattern ? t.errorColor : t.successColor)),
                  secondary: Icon(
                    _antiPattern ? Icons.warning_amber : Icons.check_circle,
                    color: _antiPattern ? t.errorColor : t.successColor),
                ),
                const SizedBox(height: AppSpacing.sm),

                // ── Explanation ───────────────────────────────────────
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: (_antiPattern ? t.errorColor : t.successColor)
                        .withAlpha(12),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(
                      color: (_antiPattern ? t.errorColor : t.successColor)
                          .withAlpha(60))),
                  child: Text(
                    _antiPattern
                      ? 'setState is called on the PARENT widget.\n'
                        'Every sibling rebuilds even though they don\'t use the counter value.\n'
                        'Watch all boxes flash red when you tap +.'
                      : 'setState is called inside the isolated counter.\n'
                        'Siblings have no knowledge of the counter.\n'
                        'Only the counter box flashes red on tap +.',
                    style: AppTypography.bodySmall.copyWith(
                      color: t.onSurfaceColor.withAlpha(180)))),
                const SizedBox(height: AppSpacing.md),

                // ── Widget tree ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md),
                  child: _antiPattern
                      ? _AntiPatternParent(
                          parentCount: _parentCount,
                          onIncrement: () =>
                              setState(() => _parentCount++))
                      : const _CorrectParent(),
                ),
              ],
            );
          }
        }

        // ── Correct pattern ──────────────────────────────────────────────

        final class _CorrectParent extends StatelessWidget {
          const _CorrectParent();
          @override
          Widget build(BuildContext context) {
            return Column(
              children: [
                _RebuildBox(label: 'Sibling A (never rebuilds)', color: AppColors.green500),
                const SizedBox(height: AppSpacing.sm),
                // Counter owns its own state — parent does NOT rebuild
                const _IsolatedCounter(),
                const SizedBox(height: AppSpacing.sm),
                _RebuildBox(label: 'Sibling B (never rebuilds)', color: AppColors.green500),
              ],
            );
          }
        }

        final class _IsolatedCounter extends StatefulWidget {
          const _IsolatedCounter();
          @override
          State<_IsolatedCounter> createState() => _IsolatedCounterState();
        }

        final class _IsolatedCounterState extends State<_IsolatedCounter> {
          int _count     = 0;
          int _builds    = 0;
          Color _flash   = Colors.transparent;

          void _increment() {
            setState(() {
              _count++;
              _flash = AppColors.red500.withAlpha(100);
            });
            Future<void>.delayed(const Duration(milliseconds: 300), () {
              if (mounted) setState(() => _flash = Colors.transparent);
            });
          }

          @override
          Widget build(BuildContext context) {
            _builds++;
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              color: _flash,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(children: [
                    Text('Isolated Counter',
                      style: AppTypography.labelLarge.copyWith(
                        color: t.onSurfaceColor)),
                    Text('Builds: $_builds',
                      style: AppTypography.monoSmall.copyWith(
                        color: t.brandPrimary)),
                    const SizedBox(height: AppSpacing.sm),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Semantics(label: 'Increment counter', button: true,
                        child: IconButton(
                          icon: const Icon(Icons.add_circle),
                          color: t.brandPrimary,
                          iconSize: 36,
                          onPressed: _increment)),
                      Text('$_count',
                        style: AppTypography.displayLarge.copyWith(
                          color: t.onSurfaceColor)),
                    ]),
                    Text('(only THIS box rebuilds)',
                      style: AppTypography.bodySmall.copyWith(
                        color: t.onSurfaceColor.withAlpha(140))),
                  ]),
                ),
              ),
            );
          }
        }

        // ── Anti-pattern ─────────────────────────────────────────────────

        final class _AntiPatternParent extends StatefulWidget {
          const _AntiPatternParent({
            required this.parentCount,
            required this.onIncrement,
          });
          final int parentCount;
          final VoidCallback onIncrement;
          @override
          State<_AntiPatternParent> createState() =>
              _AntiPatternParentState();
        }

        final class _AntiPatternParentState
            extends State<_AntiPatternParent> {
          int _builds = 0;

          @override
          Widget build(BuildContext context) {
            _builds++;
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              color: AppColors.red500.withAlpha(
                (_builds % 2 == 0) ? 20 : 60),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    child: Text('Parent (builds: $_builds)',
                      style: AppTypography.monoSmall.copyWith(
                        color: t.errorColor, fontWeight: FontWeight.w700))),
                  _RebuildBox(
                    label: 'Sibling A — rebuilds every time!',
                    color: AppColors.red500),
                  const SizedBox(height: AppSpacing.sm),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(children: [
                        Text('Counter (state in parent)',
                          style: AppTypography.labelLarge.copyWith(
                            color: t.onSurfaceColor)),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Semantics(
                              label: 'Increment — causes parent rebuild',
                              button: true,
                              child: IconButton(
                                icon: const Icon(Icons.add_circle),
                                color: t.errorColor,
                                iconSize: 36,
                                onPressed: widget.onIncrement)),
                            Text('${widget.parentCount}',
                              style: AppTypography.displayLarge.copyWith(
                                color: t.onSurfaceColor)),
                          ]),
                        Text('(parent ALSO rebuilds)',
                          style: AppTypography.bodySmall.copyWith(
                            color: t.errorColor)),
                      ]),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _RebuildBox(
                    label: 'Sibling B — rebuilds every time!',
                    color: AppColors.red500),
                ],
              ),
            );
          }
        }

        // ── Shared components ────────────────────────────────────────────

        final class _RebuildBox extends StatefulWidget {
          const _RebuildBox({required this.label, required this.color});
          final String label;
          final Color  color;
          @override
          State<_RebuildBox> createState() => _RebuildBoxState();
        }

        final class _RebuildBoxState extends State<_RebuildBox> {
          int _builds = 0;
          @override
          Widget build(BuildContext context) {
            _builds++;
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: widget.color.withAlpha(12),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(color: widget.color.withAlpha(60))),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(widget.label,
                    style: AppTypography.bodySmall.copyWith(
                      color: t.onSurfaceColor))),
                  Text('builds: $_builds',
                    style: AppTypography.monoSmall.copyWith(
                      color: widget.color, fontWeight: FontWeight.w700)),
                ],
              ),
            );
          }
        }
