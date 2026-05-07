import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import '../data/city_database.dart';
import '../models/selected_city.dart';

final class CityPickerField extends StatefulWidget {
  const CityPickerField({
    super.key,
    required this.label,
    required this.prefixIcon,
    required this.onChanged,
    this.initialValue,
    this.errorText,
  });

  final String label;
  final IconData prefixIcon;
  final ValueChanged<SelectedCity?> onChanged;
  final SelectedCity? initialValue;
  final String? errorText;

  @override
  State<CityPickerField> createState() => _CityPickerFieldState();
}

final class _CityPickerFieldState extends State<CityPickerField> {
  late final TextEditingController _controller;
  SelectedCity? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
    _controller = TextEditingController(text: widget.initialValue?.displayName ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    final br = BorderRadius.circular(AppSpacing.radiusMd);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          onChanged: (value) {
            final matches = CityDatabase.search(value);
            final SelectedCity? match =
                matches.isEmpty ? null : matches.first;
            if (match?.displayName != value) {
              _selected = null;
              widget.onChanged(null);
              return;
            }
            _selected = match;
            widget.onChanged(match);
          },
          style: AppTypography.bodyLarge.copyWith(color: t.onSurfaceColor),
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: 'Type city (e.g. Dubai)',
            prefixIcon: ExcludeSemantics(
              child: Icon(
                widget.prefixIcon,
                size: 20,
                color: t.onSurfaceColor.withAlpha(160),
              ),
            ),
            suffixIcon: _selected != null
                ? ExcludeSemantics(
                    child: Icon(Icons.check_circle, color: t.successColor, size: 18),
                  )
                : null,
            filled: true,
            fillColor: t.surfaceColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: br,
              borderSide: BorderSide(
                color: widget.errorText != null
                    ? t.errorColor
                    : t.onSurfaceColor.withAlpha(60),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: br,
              borderSide: BorderSide(
                color: widget.errorText != null ? t.errorColor : t.brandPrimary,
                width: 2,
              ),
            ),
            errorText: widget.errorText,
          ),
        ),
      ],
    );
  }
}
