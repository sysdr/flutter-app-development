import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import '../data/city_database.dart';
import '../models/selected_city.dart';

final class CityPickerField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<NomadThemeExtension>()!;
    return DropdownButtonFormField<SelectedCity>(
      value: initialValue,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        prefixIcon: ExcludeSemantics(child: Icon(prefixIcon)),
      ),
      items: CityDatabase.cities
          .map(
            (city) => DropdownMenuItem<SelectedCity>(
              value: city,
              child: Text(
                city.displayName,
                style: AppTypography.bodyMedium.copyWith(color: theme.onSurfaceColor),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
