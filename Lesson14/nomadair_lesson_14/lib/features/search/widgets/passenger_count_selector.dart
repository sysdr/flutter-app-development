import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

import '../models/search_criteria.dart';

/// Tappable field that opens a bottom sheet passenger count selector.
///
/// Constraints enforced:
///   adults:   1–9
///   children: 0–8
///   infants:  0–adults (each infant must sit on an adult's lap)
final class PassengerCountSelector extends StatelessWidget {
  const PassengerCountSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final PassengerCount value;
  final ValueChanged<PassengerCount> onChanged;

  Future<void> _openSheet(BuildContext context) async {
    final result = await showModalBottomSheet<PassengerCount>(
      context:       context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusMd))),
      builder: (_) => _PassengerSheet(initial: value),
    );
    if (result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final t  = Theme.of(context).extension<NomadThemeExtension>()!;
    final br = BorderRadius.circular(AppSpacing.radiusMd);
    return Semantics(
      label: 'Passengers: ${value.summary}',
      button: true,
      child: InkWell(
        onTap:        () => _openSheet(context),
        borderRadius: br,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Passengers',
            filled:     true,
            fillColor:  t.surfaceColor,
            prefixIcon: ExcludeSemantics(child: Icon(
              Icons.people_outline,
              size:  20,
              color: t.onSurfaceColor.withAlpha(160))),
            suffixIcon: ExcludeSemantics(child: Icon(
              Icons.expand_more,
              color: t.onSurfaceColor.withAlpha(160))),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: br,
              borderSide: BorderSide(
                color: t.onSurfaceColor.withAlpha(60))),
            focusedBorder: OutlineInputBorder(
              borderRadius: br,
              borderSide: BorderSide(
                color: t.brandPrimary, width: 2)),
          ),
          child: Text(value.summary,
            style: AppTypography.bodyLarge.copyWith(
              color: t.onSurfaceColor)),
        ),
      ),
    );
  }
}

// ── Bottom sheet ───────────────────────────────────────────────────

final class _PassengerSheet extends StatefulWidget {
  const _PassengerSheet({required this.initial});
  final PassengerCount initial;

  @override
  State<_PassengerSheet> createState() => _PassengerSheetState();
}

final class _PassengerSheetState extends State<_PassengerSheet> {
  late int _adults, _children, _infants;

  @override
  void initState() {
    super.initState();
    _adults   = widget.initial.adults;
    _children = widget.initial.children;
    _infants  = widget.initial.infants;
  }

  PassengerCount get _current => PassengerCount(
    adults: _adults, children: _children, infants: _infants);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(width: 40, height: 4,
              decoration: BoxDecoration(
                color: t.onSurfaceColor.withAlpha(60),
                borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: AppSpacing.md),
            Text('Passengers',
              style: AppTypography.headlineMedium.copyWith(
                color: t.onSurfaceColor)),
            const SizedBox(height: AppSpacing.lg),
            _CountRow(
              label:    'Adults',
              sublabel: '12+ years',
              count:    _adults,
              min:      1,
              max:      9,
              onDecrement: () => setState(() => _adults--),
              onIncrement: () => setState(() {
                _adults++;
                // Clamp infants if exceeding new adults count
                if (_infants > _adults) _infants = _adults;
              }),
            ),
            Divider(color: t.dividerColor, height: AppSpacing.lg),
            _CountRow(
              label:    'Children',
              sublabel: '2–11 years',
              count:    _children,
              min:      0,
              max:      8,
              onDecrement: () => setState(() => _children--),
              onIncrement: () => setState(() => _children++),
            ),
            Divider(color: t.dividerColor, height: AppSpacing.lg),
            _CountRow(
              label:    'Infants',
              sublabel: 'Under 2 · on lap · max = adults',
              count:    _infants,
              min:      0,
              max:      _adults, // constraint
              onDecrement: () => setState(() => _infants--),
              onIncrement: () => setState(() => _infants++),
            ),
            const SizedBox(height: AppSpacing.xl),
            NomadButton(
              label: 'Confirm  ·  ${_current.summary}',
              onPressed: () => Navigator.of(context).pop(_current),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

final class _CountRow extends StatelessWidget {
  const _CountRow({
    required this.label,
    required this.sublabel,
    required this.count,
    required this.min,
    required this.max,
    required this.onDecrement,
    required this.onIncrement,
  });

  final String   label, sublabel;
  final int      count, min, max;
  final VoidCallback onDecrement, onIncrement;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Row(children: [
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
            style: AppTypography.bodyLarge.copyWith(
              color: t.onSurfaceColor,
              fontWeight: FontWeight.w600)),
          Text(sublabel,
            style: AppTypography.bodySmall.copyWith(
              color: t.onSurfaceColor.withAlpha(140))),
        ],
      )),
      Semantics(
        label: 'Decrease $label',
        button: true,
        child: IconButton(
          icon: Icon(Icons.remove_circle_outline,
            color: count <= min
                ? t.onSurfaceColor.withAlpha(60)
                : t.brandPrimary),
          onPressed: count <= min ? null : onDecrement,
          iconSize: 28,
        ),
      ),
      SizedBox(
        width: 36,
        child: Text('$count',
          textAlign: TextAlign.center,
          style: AppTypography.headlineMedium.copyWith(
            color: t.onSurfaceColor,
            fontWeight: FontWeight.w700)),
      ),
      Semantics(
        label: 'Increase $label',
        button: true,
        child: IconButton(
          icon: Icon(Icons.add_circle_outline,
            color: count >= max
                ? t.onSurfaceColor.withAlpha(60)
                : t.brandPrimary),
          onPressed: count >= max ? null : onIncrement,
          iconSize: 28,
        ),
      ),
    ]);
  }
}
