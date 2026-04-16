/// NomadAir Core Package
///
/// Public API surface for nomadair_core. External packages import ONLY
/// from this barrel file. Internal `src/` files are not part of the
/// public contract and may change without notice.
library nomadair_core;

// Design tokens
export 'src/tokens/app_colors.dart' show AppColors;
export 'src/tokens/app_typography.dart' show AppTypography;
export 'src/tokens/app_spacing.dart' show AppSpacing;

// Domain models
export 'src/models/flight_model.dart' show FlightModel;

// Repository interfaces
export 'src/interfaces/flight_repository.dart' show FlightRepository;
