import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nomadair_core/core.dart';

/// Tappable date field that opens the system [DatePicker].
///
/// Enforces [firstDate] so past dates cannot be selected.
/// Shows the selected date formatted as "dd MMM yyyy".
final class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.label,
    required this.onChanged,
    this.value,
    this.firstDate,
    this.errorText,
    this.enabled = true,
  });

  final String    label;
  final DateTime? value;
  final DateTime? firstDate;
  final String?   errorText;
  final bool      enabled;
  final ValueChanged<DateTime?> onChanged;

  static final _fmt = DateFormat('dd MMM yyyy');

  Future<void> _pick(BuildContext context) async {
    final now  = DateTime.now();
    final first = firstDate ?? now;
    final initial = value != null && value!.isAfter(first)
        ? value!
        : first;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate:   first,
      lastDate:    now.add(const Duration(days: 365)),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final t  = Theme.of(context).extension<NomadThemeExtension>()!;
    final br = BorderRadius.circular(AppSpacing.radiusMd);
    final display = value != null ? _fmt.format(value!) : '';
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: value != null
              ? '$label: $display' : '$label: not selected',
          button: true,
          child: InkWell(
            onTap: enabled ? () => _pick(context) : null,
            borderRadius: br,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText:  label,
                filled:     true,
                fillColor:  enabled
                    ? t.surfaceColor
                    : t.onSurfaceColor.withAlpha(10),
                prefixIcon: ExcludeSemantics(child: Icon(
                  Icons.calendar_today,
                  size:  20,
                  color: t.onSurfaceColor.withAlpha(160))),
                suffixIcon: value != null
                    ? ExcludeSemantics(child: Icon(
                        Icons.check_circle,
                        color: t.successColor, size: 18))
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: br,
                  borderSide: BorderSide(
                    color: hasError
                        ? t.errorColor
                        : t.onSurfaceColor.withAlpha(60))),
                focusedBorder: OutlineInputBorder(
                  borderRadius: br,
                  borderSide: BorderSide(
                    color: hasError ? t.errorColor : t.brandPrimary,
                    width: 2)),
                errorBorder: OutlineInputBorder(
                  borderRadius: br,
                  borderSide: BorderSide(color: t.errorColor)),
                disabledBorder: OutlineInputBorder(
                  borderRadius: br,
                  borderSide: BorderSide(
                    color: t.onSurfaceColor.withAlpha(30))),
              ),
              child: Text(
                display.isEmpty ? '' : display,
                style: AppTypography.bodyLarge.copyWith(
                  color: t.onSurfaceColor),
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md),
            child: Text(errorText!,
              style: AppTypography.bodySmall.copyWith(
                color: t.errorColor)),
          ),
        ],
      ],
    );
  }
}
