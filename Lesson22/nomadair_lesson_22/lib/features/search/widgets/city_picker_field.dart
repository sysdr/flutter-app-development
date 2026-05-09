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
  late final FocusNode _focusNode;
  SelectedCity? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
    _controller = TextEditingController(
      text: widget.initialValue?.displayName ?? '',
    );
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    final borderRadius = BorderRadius.circular(AppSpacing.radiusMd);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RawAutocomplete<SelectedCity>(
          textEditingController: _controller,
          focusNode: _focusNode,
          optionsBuilder: (value) => CityDatabase.search(value.text),
          displayStringForOption: (city) => city.displayName,
          onSelected: (city) {
            setState(() {
              _selected = city;
              _controller.text = city.displayName;
            });
            widget.onChanged(city);
            _focusNode.unfocus();
          },
          fieldViewBuilder: (context, controller, focusNode, _) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: (value) {
                if (_selected != null && value != _selected!.displayName) {
                  setState(() => _selected = null);
                  widget.onChanged(null);
                }
              },
              style: AppTypography.bodyLarge.copyWith(color: t.onSurfaceColor),
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
                suffixIcon: _selected != null
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
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    color: widget.errorText != null
                        ? t.errorColor
                        : t.onSurfaceColor.withAlpha(60),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    color: widget.errorText != null
                        ? t.errorColor
                        : t.brandPrimary,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(color: t.errorColor),
                ),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            final list = options.toList();
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                color: t.surfaceColor,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 240),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs,
                    ),
                    itemCount: list.length,
                    itemBuilder: (_, index) {
                      final city = list[index];
                      return InkWell(
                        onTap: () => onSelected(city),
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
                                      city.name,
                                      style: AppTypography.bodyMedium
                                          .copyWith(color: t.onSurfaceColor),
                                    ),
                                    Text(
                                      city.iata,
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
            );
          },
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
