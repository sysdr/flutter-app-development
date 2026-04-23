import 'package:flutter/material.dart';

// ── Audit target descriptor ───────────────────────────────────────────

/// Describes a single UI component for accessibility auditing.
final class AuditTarget {
  const AuditTarget({
    required this.name,
    required this.semanticLabel,
    required this.touchTargetWidth,
    required this.touchTargetHeight,
    required this.hasSemanticRole,
  });

  final String name;
  final String semanticLabel;
  final double touchTargetWidth;
  final double touchTargetHeight;
  final bool   hasSemanticRole;
}

// ── AuditResult sealed class ──────────────────────────────────────────

/// Result of a single accessibility check.
///
/// Sealed class: every switch on [AuditResult] is exhaustive at compile
/// time. Adding a new subtype forces every switch site to handle it.
sealed class AuditResult {
  const AuditResult({required this.checkName, required this.targetName});
  final String checkName;
  final String targetName;
}

/// Check passed — this component meets the accessibility requirement.
final class AuditPass extends AuditResult {
  const AuditPass({required super.checkName, required super.targetName});
}

/// Check failed — this component has an accessibility issue.
final class AuditFail extends AuditResult {
  const AuditFail({
    required super.checkName,
    required super.targetName,
    required this.issue,
    required this.fixHint,
  });

  /// Short description of what failed.
  final String issue;

  /// Specific, actionable instruction to fix the issue.
  final String fixHint;
}

// ── AccessibilityAudit interface ──────────────────────────────────────

/// Programmatic accessibility audit service.
///
/// [abstract interface class]: implement-only contract.
/// The [DefaultAccessibilityAudit] is the production implementation.
/// Tests can substitute an in-memory mock.
abstract interface class AccessibilityAudit {
  /// Audits that all targets meet the WCAG 2.5.5 minimum touch target size.
  ///
  /// Minimum: 44×44 CSS px (WCAG 2.5.5) or 48×48 dp (Material).
  /// NomadAir uses 48×48 dp ([AppSpacing.minTouchTarget]).
  List<AuditResult> auditTouchTargets(List<AuditTarget> targets);

  /// Audits that all targets have a non-empty semantic label.
  List<AuditResult> auditSemanticLabels(List<AuditTarget> targets);

  /// Audits that all targets have a semantic role declared.
  List<AuditResult> auditSemanticRoles(List<AuditTarget> targets);
}

// ── Default implementation ─────────────────────────────────────────────

final class DefaultAccessibilityAudit implements AccessibilityAudit {
  const DefaultAccessibilityAudit();

  static const double _minTarget = 48.0;

  @override
  List<AuditResult> auditTouchTargets(List<AuditTarget> targets) {
    return targets.map((t) {
      final tooNarrow  = t.touchTargetWidth  < _minTarget;
      final tooShort   = t.touchTargetHeight < _minTarget;
      if (tooNarrow || tooShort) {
        final dim = '${t.touchTargetWidth.toInt()}×${t.touchTargetHeight.toInt()} dp';
        return AuditFail(
          checkName:  'Touch Target ≥ 48×48 dp',
          targetName: t.name,
          issue:      '$dim is below minimum (48×48 dp)',
          fixHint:    'Wrap with ConstrainedBox(constraints: '
                      'BoxConstraints(minWidth: 48, minHeight: 48)) '
                      'or use IconButton which enforces minimumSize.',
        );
      }
      return AuditPass(
        checkName:  'Touch Target ≥ 48×48 dp',
        targetName: t.name,
      );
    }).toList();
  }

  @override
  List<AuditResult> auditSemanticLabels(List<AuditTarget> targets) {
    return targets.map((t) {
      if (t.semanticLabel.trim().isEmpty) {
        return AuditFail(
          checkName:  'Semantic Label Non-Empty',
          targetName: t.name,
          issue:      'semanticLabel is empty or missing',
          fixHint:    'Add Semantics(label: "Descriptive label") '
                      'or provide a tooltip/hint to the component.',
        );
      }
      return AuditPass(
        checkName:  'Semantic Label Non-Empty',
        targetName: t.name,
      );
    }).toList();
  }

  @override
  List<AuditResult> auditSemanticRoles(List<AuditTarget> targets) {
    return targets.map((t) {
      if (!t.hasSemanticRole) {
        return AuditFail(
          checkName:  'Semantic Role Declared',
          targetName: t.name,
          issue:      'No semantic role set (button/textField/image/selected)',
          fixHint:    'Add Semantics(button: true) for tappable items, '
                      'Semantics(textField: true) for inputs, '
                      'Semantics(image: true) for images.',
        );
      }
      return AuditPass(
        checkName:  'Semantic Role Declared',
        targetName: t.name,
      );
    }).toList();
  }
}
