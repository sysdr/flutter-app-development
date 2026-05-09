import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';

class _Assertion {
  const _Assertion({required this.tag, required this.label, this.checked = false});
  final String tag, label;
  final bool checked;
  _Assertion copyWith({bool? checked}) =>
      _Assertion(tag: tag, label: label, checked: checked ?? this.checked);
}

// Lesson 20 MasteryRubricScreen.
// 44 assertions: NAV + STATE + MOCK + LINK + DOMAIN + PERSIST.
final class MasteryRubricScreen extends StatefulWidget {
  const MasteryRubricScreen({super.key});
  @override State<MasteryRubricScreen> createState() =>
      _MasteryRubricScreenState();
}

final class _MasteryRubricScreenState
    extends State<MasteryRubricScreen> {

  static const _all = <_Assertion>[
    // â”€â”€ NAV (7) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    _Assertion(tag: 'NAV',   label: 'Search tab renders SearchScreen'),
    _Assertion(tag: 'NAV',   label: 'Valid form submit pushes searchResults'),
    _Assertion(tag: 'NAV',   label: 'Back from results preserves form values'),
    _Assertion(tag: 'NAV',   label: 'Tap flight card â†’ FlightDetailScreen'),
    _Assertion(tag: 'NAV',   label: 'FlightDetailScreen shows airline name'),
    _Assertion(tag: 'NAV',   label: 'New Search resets criteria + pops results'),
    _Assertion(tag: 'NAV',   label: 'BookingStub accessible from detail CTA'),
    // â”€â”€ STATE (6) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    _Assertion(tag: 'STATE', label: 'SearchCriteriaNotifier resets all fields'),
    _Assertion(tag: 'STATE', label: 'Idle â†’ Loading â†’ Loaded state machine'),
    _Assertion(tag: 'STATE', label: 'setSortBy triggers no re-fetch'),
    _Assertion(tag: 'STATE', label: 'Results screen reads criteria from Provider'),
    _Assertion(tag: 'STATE', label: 'Sort chips reorder flight list in place'),
    _Assertion(tag: 'STATE', label: 'Error state: Retry re-calls search()'),
    // â”€â”€ MOCK (6) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    _Assertion(tag: 'MOCK',  label: 'searchFlights returns 10 results'),
    _Assertion(tag: 'MOCK',  label: '4 non-stop Â· 4 one-stop Â· 2 two-stop'),
    _Assertion(tag: 'MOCK',  label: 'Same route+date â†’ same results (seeded RNG)'),
    _Assertion(tag: 'MOCK',  label: 'Business avg > 3Ã— Economy avg price'),
    _Assertion(tag: 'MOCK',  label: 'FlightResult JSON round-trip'),
    _Assertion(tag: 'MOCK',  label: 'JSON keys are snake_case'),
    // â”€â”€ LINK (5) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    _Assertion(tag: 'LINK',  label: 'AndroidManifest has nomadair:// scheme'),
    _Assertion(tag: 'LINK',  label: 'from=BOM resolves to Mumbai'),
    _Assertion(tag: 'LINK',  label: 'to=DXB resolves to Dubai'),
    _Assertion(tag: 'LINK',  label: 'Unknown IATA â†’ null (graceful)'),
    _Assertion(tag: 'LINK',  label: 'Route accepts from= and to= params'),
    // â”€â”€ DOMAIN â€” NEW in L19 (11) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    _Assertion(tag: 'DOMAIN', label: 'Flight.copyWith returns new instance'),
    _Assertion(tag: 'DOMAIN', label: 'Flight equality is structural (value-based)'),
    _Assertion(tag: 'DOMAIN', label: 'Flight.fromFlightResult maps all fields'),
    _Assertion(tag: 'DOMAIN', label: 'TravelClass.fromCabinClass handles all 4'),
    _Assertion(tag: 'DOMAIN', label: 'formattedDuration: 210 min â†’ 3h 30m'),
    _Assertion(tag: 'DOMAIN', label: 'stopsLabel: Non-stop / 1 stop / 2 stops'),
    _Assertion(tag: 'DOMAIN', label: 'PriceBreakdown.total computed correctly'),
    _Assertion(tag: 'DOMAIN', label: 'PriceBreakdown.hasDiscount false when 0'),
    _Assertion(tag: 'DOMAIN', label: 'Itinerary.isRoundTrip false by default'),
    _Assertion(tag: 'DOMAIN', label: 'BookingState.when dispatches correctly'),
    _Assertion(tag: 'DOMAIN', label: 'All 42 domain tests pass'),
    // â”€â”€ PERSIST â€” NEW in L20 (8) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    _Assertion(tag: 'PERSIST', label: 'Hive.initFlutter() called before runApp'),
    _Assertion(tag: 'PERSIST', label: 'RecentSearchAdapter registered before openBox'),
    _Assertion(tag: 'PERSIST', label: 'Recent searches survive hot restart'),
    _Assertion(tag: 'PERSIST', label: 'Max 5 recent searches enforced'),
    _Assertion(tag: 'PERSIST', label: 'Duplicate route deduped, newest at front'),
    _Assertion(tag: 'PERSIST', label: 'Theme mode persists across sessions'),
    _Assertion(tag: 'PERSIST', label: 'LocalStorageService is an interface'),
    _Assertion(tag: 'PERSIST', label: 'All 22 storage tests pass'),
    // â”€â”€ HTTP â€” NEW in L21 (9) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    _Assertion(tag: 'HTTP', label: 'http.Client injected â€” not hardcoded'),
    _Assertion(tag: 'HTTP', label: 'Token cached after first fetch'),
    _Assertion(tag: 'HTTP', label: 'Token refreshes 30s before expiry'),
    _Assertion(tag: 'HTTP', label: '5xx triggers one retry, then throws'),
    _Assertion(tag: 'HTTP', label: '4xx fails immediately â€” no retry'),
    _Assertion(tag: 'HTTP', label: '401 throws NetworkAuthException'),
    _Assertion(tag: 'HTTP', label: 'Parse error throws NetworkParseException'),
    _Assertion(tag: 'HTTP', label: 'useMock=false â†’ AmadeusFlightRepository'),
    _Assertion(tag: 'HTTP', label: 'All 28 HTTP tests pass'),
  ];

  late List<_Assertion> _items;

  @override void initState() {
    super.initState();
    _items = List.from(_all);
  }

  void _toggle(int i) => setState(
      () => _items[i] = _items[i].copyWith(checked: !_items[i].checked));

  void _markAll(bool v) => setState(
      () => _items = _items.map((a) => a.copyWith(checked: v)).toList());

  Color _tagColor(String tag, NomadThemeExtension t) => switch (tag) {
    'NAV'    => t.brandPrimary,
    'STATE'  => t.successColor,
    'MOCK'   => t.warningColor,
    'LINK'   => const Color(0xFF7C3AED),
    'DOMAIN'  => const Color(0xFF0D9488),
    'PERSIST' => const Color(0xFF7C2D12),
    'HTTP'    => const Color(0xFF1D4ED8),
    _         => t.onSurfaceColor.withAlpha(120),
  };

  @override
  Widget build(BuildContext context) {
    final t       = Theme.of(context).extension<NomadThemeExtension>()!;
    final checked = _items.where((a) => a.checked).length;
    final total   = _items.length;
    final done    = checked == total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mastery Rubric â€” L21'),
        surfaceTintColor: Colors.transparent,
        leading: BackButton(onPressed: () => context.pop()),
        actions: [
          Semantics(
            label: done ? 'Uncheck all' : 'Check all',
            button: true,
            child: TextButton(
              onPressed: () => _markAll(!done),
              child: Text(done ? 'Uncheck all' : 'Check all'))),
        ]),
      body: Column(children: [
        LinearProgressIndicator(
          value: total > 0 ? checked / total : 0,
          backgroundColor: t.dividerColor,
          color: done ? t.successColor : t.brandPrimary,
          minHeight: 6),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$checked / $total assertions verified',
                style: AppTypography.bodyMedium.copyWith(
                  color: t.onSurfaceColor)),
              if (done)
                Row(mainAxisSize: MainAxisSize.min, children: [
                  ExcludeSemantics(child: Icon(
                    Icons.verified, size: 16, color: t.successColor)),
                  const SizedBox(width: 4),
                  Text('COMPLETE',
                    style: AppTypography.labelLarge.copyWith(
                      color: t.successColor)),
                ]),
            ])),
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
          itemCount: _items.length,
          itemBuilder: (_, i) {
            final a   = _items[i];
            final col = _tagColor(a.tag, t);
            return Semantics(
              label: '${a.tag}: ${a.label}. '
                '${a.checked ? "Checked" : "Unchecked"}',
              button: true,
              child: InkWell(
                onTap: () => _toggle(i),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.sm),
                  child: Row(children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        key: ValueKey(a.checked),
                        a.checked
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                        size: 22,
                        color: a.checked
                          ? t.successColor
                          : t.onSurfaceColor.withAlpha(80))),
                    const SizedBox(width: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: col.withAlpha(18),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusFull),
                        border: Border.all(color: col.withAlpha(80))),
                      child: Text(a.tag,
                        style: AppTypography.monoSmall.copyWith(
                          color: col,
                          fontWeight: FontWeight.w700,
                          fontSize: 9))),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: Text(a.label,
                      style: AppTypography.bodyMedium.copyWith(
                        color: a.checked
                          ? t.onSurfaceColor.withAlpha(100)
                          : t.onSurfaceColor,
                        decoration: a.checked
                          ? TextDecoration.lineThrough : null))),
                  ]))));
          })),
      ]));
  }
}
