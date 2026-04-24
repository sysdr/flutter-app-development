final class AuditTarget {
  const AuditTarget({
    required this.name,
    required this.semanticLabel,
    required this.touchTargetWidth,
    required this.touchTargetHeight,
    required this.hasSemanticRole,
  });
  final String name, semanticLabel;
  final double touchTargetWidth, touchTargetHeight;
  final bool   hasSemanticRole;
}

sealed class AuditResult {
  const AuditResult({required this.checkName, required this.targetName});
  final String checkName, targetName;
}

final class AuditPass extends AuditResult {
  const AuditPass({required super.checkName, required super.targetName});
}

final class AuditFail extends AuditResult {
  const AuditFail({
    required super.checkName,
    required super.targetName,
    required this.issue,
    required this.fixHint,
  });
  final String issue, fixHint;
}

abstract interface class AccessibilityAudit {
  List<AuditResult> auditTouchTargets(List<AuditTarget> targets);
  List<AuditResult> auditSemanticLabels(List<AuditTarget> targets);
  List<AuditResult> auditSemanticRoles(List<AuditTarget> targets);
}

final class DefaultAccessibilityAudit implements AccessibilityAudit {
  const DefaultAccessibilityAudit();
  static const double _min = 48.0;

  @override
  List<AuditResult> auditTouchTargets(List<AuditTarget> targets) =>
      targets.map((t) {
        if (t.touchTargetWidth < _min || t.touchTargetHeight < _min) {
          return AuditFail(
            checkName: 'Touch Target >= 48dp', targetName: t.name,
            issue: '${t.touchTargetWidth.toInt()}x${t.touchTargetHeight.toInt()} dp below minimum',
            fixHint: 'Wrap with ConstrainedBox(minWidth:48, minHeight:48)');
        }
        return AuditPass(checkName: 'Touch Target >= 48dp', targetName: t.name);
      }).toList();

  @override
  List<AuditResult> auditSemanticLabels(List<AuditTarget> targets) =>
      targets.map((t) {
        if (t.semanticLabel.trim().isEmpty) {
          return AuditFail(
            checkName: 'Semantic Label', targetName: t.name,
            issue: 'empty label', fixHint: 'Add Semantics(label:...)');
        }
        return AuditPass(checkName: 'Semantic Label', targetName: t.name);
      }).toList();

  @override
  List<AuditResult> auditSemanticRoles(List<AuditTarget> targets) =>
      targets.map((t) {
        if (!t.hasSemanticRole) {
          return AuditFail(
            checkName: 'Semantic Role', targetName: t.name,
            issue: 'no role', fixHint: 'Add button:true or textField:true');
        }
        return AuditPass(checkName: 'Semantic Role', targetName: t.name);
      }).toList();
}
