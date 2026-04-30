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
  State<CityPickerField> createState() => _S();
}

final class _S extends State<CityPickerField> {
  late final TextEditingController _c;
  late final FocusNode _f;
  SelectedCity? _sel;

  @override
  void initState() {
    super.initState();
    _sel = widget.initialValue;
    _c = TextEditingController(text: widget.initialValue?.displayName ?? '');
    _f = FocusNode();
  }

  @override
  void dispose() {
    _c.dispose();
    _f.dispose();
    super.dispose();
  }

  void _onSel(SelectedCity c) {
    setState(() {
      _sel = c;
      _c.text = c.displayName;
    });
    widget.onChanged(c);
    _f.unfocus();
  }

  void _onTxt(String t) {
    if (_sel != null && t != _sel!.displayName) {
      setState(() => _sel = null);
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
          textEditingController: _c,
          focusNode: _f,
          optionsBuilder: (v) => CityDatabase.search(v.text),
          displayStringForOption: (c) => c.displayName,
          onSelected: _onSel,
          fieldViewBuilder: (ctx, ctrl, fn, _) => Semantics(
            label: widget.label,
            textField: true,
            child: TextField(
              controller: ctrl,
              focusNode: fn,
              onChanged: _onTxt,
              style: AppTypography.bodyLarge.copyWith(color: t.onSurfaceColor),
              cursorColor: t.brandPrimary,
              decoration: InputDecoration(
                labelText: widget.label,
                hintText: 'Type to search...',
                prefixIcon: ExcludeSemantics(
                  child: Icon(
                    widget.prefixIcon,
                    size: 20,
                    color: t.onSurfaceColor.withAlpha(160),
                  ),
                ),
                suffixIcon: _sel != null
                    ? ExcludeSemantics(
                        child: Icon(
                          Icons.check_circle,
                          color: t.successColor,
                          size: 18,
                        ),
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
                    color: widget.errorText != null
                        ? t.errorColor
                        : t.brandPrimary,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: br,
                  borderSide: BorderSide(color: t.errorColor),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: br,
                  borderSide: BorderSide(color: t.errorColor, width: 2),
                ),
              ),
            ),
          ),
          optionsViewBuilder: (ctx, onSel, opts) => Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              color: t.surfaceColor,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 240),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  shrinkWrap: true,
                  itemCount: opts.length,
                  itemBuilder: (_, i) {
                    final c = opts.toList()[i];
                    return InkWell(
                      onTap: () => onSel(c),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.flight,
                              size: 16,
                              color: t.onSurfaceColor.withAlpha(120),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.name,
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: t.onSurfaceColor,
                                    ),
                                  ),
                                  Text(
                                    c.iata,
                                    style: AppTypography.monoSmall.copyWith(
                                      color: t.brandPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              widget.errorText!,
              style: AppTypography.bodySmall.copyWith(color: t.errorColor),
            ),
          ),
        ],
      ],
    );
  }
}

