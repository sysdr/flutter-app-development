import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

import '../data/city_database.dart';
import '../models/selected_city.dart';

/// City autocomplete field using [RawAutocomplete].
///
/// Displays a floating suggestions overlay while the user types.
/// A valid selection stores a [SelectedCity] object.
/// Raw text without a selection fails validation.
///
/// Validation: the [validator] checks [_selected], not the text value.
///   "Mum" (no selection) → invalid
///   "Mumbai Chhatrapati Shivaji (BOM)" (selected) → valid
final class CityPickerField extends StatefulWidget {
  const CityPickerField({
    super.key,
    required this.label,
    required this.prefixIcon,
    required this.onChanged,
    this.initialValue,
    this.errorText,
  });

  final String        label;
  final IconData      prefixIcon;
  final ValueChanged<SelectedCity?> onChanged;
  final SelectedCity? initialValue;
  final String?       errorText;

  @override
  State<CityPickerField> createState() => _CityPickerFieldState();
}

final class _CityPickerFieldState extends State<CityPickerField> {
  late final TextEditingController _ctrl;
  late final FocusNode             _focus;
  SelectedCity? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
    _ctrl = TextEditingController(
      text: widget.initialValue?.displayName ?? '');
    _focus = FocusNode();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onSelected(SelectedCity city) {
    setState(() {
      _selected = city;
      _ctrl.text = city.displayName;
    });
    widget.onChanged(city);
    _focus.unfocus();
  }

  void _onTextChanged(String text) {
    // When user edits text after selection, invalidate the selection
    if (_selected != null && text != _selected!.displayName) {
      setState(() => _selected = null);
      widget.onChanged(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    final br = BorderRadius.circular(AppSpacing.radiusMd);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RawAutocomplete<SelectedCity>(
          textEditingController: _ctrl,
          focusNode: _focus,
          optionsBuilder: (v) => CityDatabase.search(v.text),
          displayStringForOption: (c) => c.displayName,
          onSelected: _onSelected,
          fieldViewBuilder: (ctx, ctrl, fn, onSubmit) {
            return Semantics(
              label: widget.label,
              textField: true,
              child: TextField(
                controller:    ctrl,
                focusNode:     fn,
                onChanged:     _onTextChanged,
                style: AppTypography.bodyLarge.copyWith(
                  color: t.onSurfaceColor),
                cursorColor:   t.brandPrimary,
                decoration: InputDecoration(
                  labelText: widget.label,
                  hintText:  'Type to search cities…',
                  prefixIcon: ExcludeSemantics(
                    child: Icon(widget.prefixIcon, size: 20,
                      color: t.onSurfaceColor.withAlpha(160))),
                  suffixIcon: _selected != null
                      ? ExcludeSemantics(
                          child: Icon(Icons.check_circle,
                            color: t.successColor, size: 18))
                      : null,
                  filled: true,
                  fillColor: t.surfaceColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: br,
                    borderSide: BorderSide(
                      color: widget.errorText != null
                          ? t.errorColor
                          : t.onSurfaceColor.withAlpha(60))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: br,
                    borderSide: BorderSide(
                      color: widget.errorText != null
                          ? t.errorColor : t.brandPrimary,
                      width: 2)),
                  errorBorder: OutlineInputBorder(
                    borderRadius: br,
                    borderSide: BorderSide(color: t.errorColor)),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: br,
                    borderSide: BorderSide(
                      color: t.errorColor, width: 2)),
                ),
              ),
            );
          },
          optionsViewBuilder: (ctx, onSelected, options) =>
              _SuggestionsOverlay(
                options:    options.toList(),
                onSelected: onSelected,
              ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md),
            child: Text(widget.errorText!,
              style: AppTypography.bodySmall.copyWith(
                color: t.errorColor)),
          ),
        ],
      ],
    );
  }
}

final class _SuggestionsOverlay extends StatelessWidget {
  const _SuggestionsOverlay({
    required this.options,
    required this.onSelected,
  });
  final List<SelectedCity>         options;
  final AutocompleteOnSelected<SelectedCity> onSelected;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        color: t.surfaceColor,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 240),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.xs),
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (_, i) {
              final city = options[i];
              return Semantics(
                label: city.displayName,
                button: true,
                child: InkWell(
                  onTap: () => onSelected(city),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical:   AppSpacing.sm),
                    child: Row(children: [
                      ExcludeSemantics(child: Icon(
                        Icons.flight,
                        size: 16,
                        color: t.onSurfaceColor.withAlpha(120))),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(city.name,
                            style: AppTypography.bodyMedium.copyWith(
                              color: t.onSurfaceColor)),
                          Text(city.iata,
                            style: AppTypography.monoSmall.copyWith(
                              color: t.brandPrimary,
                              fontWeight: FontWeight.w700)),
                        ],
                      )),
                    ]),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
