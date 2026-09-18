/// Sealed class representing the result of a single environment check.
///
/// Using [sealed] forces exhaustive pattern matching at every switch
/// site in the codebase. If a new state is added here, every switch
/// that handles [EnvCheckResult] becomes a compile error until it
/// covers the new case. That is the type system enforcing correctness —
/// not a comment or a convention.
sealed class EnvCheckResult {
  const EnvCheckResult({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;
}

/// Check has not yet been triggered.
final class CheckPending extends EnvCheckResult {
  const CheckPending({
    required super.name,
    required super.description,
  });
}

/// Check is executing asynchronously.
final class CheckRunning extends EnvCheckResult {
  const CheckRunning({
    required super.name,
    required super.description,
  });
}

/// Check completed successfully.
final class CheckPassing extends EnvCheckResult {
  const CheckPassing({
    required super.name,
    required super.description,
    required this.value,
  });

  /// Human-readable string describing the passing result.
  final String value;
}

/// Check detected a problem.
final class CheckFailing extends EnvCheckResult {
  const CheckFailing({
    required super.name,
    required super.description,
    required this.error,
    required this.fix,
  });

  /// Short description of what went wrong.
  final String error;

  /// Actionable instruction to resolve the failure.
  final String fix;
}
