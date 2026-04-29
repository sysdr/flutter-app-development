import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

import '../../../router/navigator_routes.dart';
import '../models/destination_model.dart';
import '../widgets/filter_chip_bar_widget.dart';
import '../widgets/destination_card_widget.dart';

// ── Feed state ─────────────────────────────────────────────────────

enum _FeedMode { grid, pageView }

sealed class _FeedState { const _FeedState(); }
final class _Loading extends _FeedState { const _Loading(); }
final class _Loaded  extends _FeedState {
  const _Loaded(this.items, this.filter);
  final List<DiscoveryDestination> items;
  final DiscoveryFilter            filter;
}
final class _Error extends _FeedState {
  const _Error(this.message);
  final String message;
}

// ── Screen ─────────────────────────────────────────────────────────

/// Lesson 13 — Production Discovery Feed Screen.
///
/// Three states: Loading (shimmer) · Loaded (grid) · Error (retry)
/// Two modes:    Grid (adaptive 1–2 col) · PageView (full-screen vertical)
///
/// Key patterns:
///   [AnimationController] — one shimmer controller, shared to all tiles
///   [AnimatedSwitcher]    — skeleton → content, 300ms fade, no shift
///   [GridView.builder]    — virtualized, cacheExtent: 500
///   [PageView.builder]    — vertical-snapping full-screen feed
///   [ValueKey] on items   — stable element identity for filter transitions
final class DiscoveryFeedScreen extends StatefulWidget {
  const DiscoveryFeedScreen({super.key});

  @override
  State<DiscoveryFeedScreen> createState() =>
      _DiscoveryFeedScreenState();
}

final class _DiscoveryFeedScreenState
    extends State<DiscoveryFeedScreen>
    with SingleTickerProviderStateMixin {

  // ── Shimmer: one controller for all tiles ──────────────────────
  late final AnimationController _shimmer;

  // ── Feed state ─────────────────────────────────────────────────
  _FeedState  _state     = const _Loading();
  _FeedMode   _mode      = _FeedMode.grid;
  DiscoveryFilter _filter = DiscoveryFilter.all;

  // ── PageView controller ────────────────────────────────────────
  late final PageController _pageCtrl;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
    _shimmer = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _loadFeed();
  }

  @override
  void dispose() {
    _shimmer.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  // Simulates a network fetch.
  // Lesson 17: replaced with MockFlightRepository.
  // Lesson 32: replaced with Riverpod AsyncNotifier.
  Future<void> _loadFeed() async {
    setState(() => _state = const _Loading());
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _state = _Loaded(
      DiscoveryDestination.samples, _filter));
  }

  List<DiscoveryDestination> get _filtered {
    if (_state is! _Loaded) return [];
    final all = (_state as _Loaded).items;
    return switch (_filter) {
      DiscoveryFilter.all     => all,
      DiscoveryFilter.flights =>
          all.where((d) => d.category == 'flights' ||
                           d.category == 'both').toList(),
      DiscoveryFilter.hotels  =>
          all.where((d) => d.category == 'hotels' ||
                           d.category == 'both').toList(),
    };
  }

  void _onFilterChanged(DiscoveryFilter f) {
    if (_state is! _Loaded) return;
    setState(() {
      _filter = f;
      _state  = _Loaded((_state as _Loaded).items, f);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header bar ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Discover',
                      style: AppTypography.displayLarge.copyWith(
                        color: t.onSurfaceColor),
                    ),
                  ),
                  // Mode toggle
                  Semantics(
                    label: _mode == _FeedMode.grid
                        ? 'Switch to full-screen feed'
                        : 'Switch to grid view',
                    button: true,
                    child: IconButton(
                      icon: Icon(
                        _mode == _FeedMode.grid
                            ? Icons.view_day_outlined
                            : Icons.grid_view_outlined),
                      tooltip: _mode == _FeedMode.grid
                          ? 'Full Screen' : 'Grid',
                      onPressed: () => setState(() {
                        _mode = _mode == _FeedMode.grid
                            ? _FeedMode.pageView
                            : _FeedMode.grid;
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              // Filter chips — disabled while loading
              AnimatedOpacity(
                opacity: _state is _Loading ? 0.4 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: FilterChipBarWidget(
                  active:    _filter,
                  onChanged: _state is _Loading
                      ? (_) {} : _onFilterChanged,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // ── Feed body ───────────────────────────────────────────
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve:  Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: KeyedSubtree(
              // Key on state type forces AnimatedSwitcher to
              // treat Loading → Loaded as distinct widgets
              key: ValueKey(
                '${_state.runtimeType}-$_mode-$_filter'),
              child: _buildBody(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return switch (_state) {
      _Loading() => _buildShimmerGrid(),
      _Loaded()  => _mode == _FeedMode.grid
          ? _buildGrid()
          : _buildPageView(),
      _Error(:final message) => _buildError(message),
    };
  }

  // ── Loading: shimmer skeleton ───────────────────────────────────

  Widget _buildShimmerGrid() {
    return LayoutBuilder(builder: (ctx, cs) {
      final cols = cs.maxWidth >= 576 ? 2 : 1;
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:  cols,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: cols == 1 ? 1.4 : 0.85,
        ),
        // Fixed count matches the expected real item count
        itemCount: DiscoveryDestination.samples.length,
        itemBuilder: (_, __) => DiscoveryCardShimmer(
          animation: _shimmer),
      );
    });
  }

  // ── Loaded: real grid ───────────────────────────────────────────

  Widget _buildGrid() {
    final items = _filtered;
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(child: Icon(
              Icons.search_off,
              size:  64,
              color: Theme.of(context)
                  .extension<NomadThemeExtension>()!
                  .onSurfaceColor.withAlpha(80),
            )),
            const SizedBox(height: AppSpacing.md),
            Text('No destinations match this filter.',
              style: AppTypography.bodyMedium),
          ],
        ),
      );
    }
    return LayoutBuilder(builder: (ctx, cs) {
      final cols = cs.maxWidth >= 576 ? 2 : 1;
      return GridView.builder(
        cacheExtent: 500, // pre-render 500dp buffer
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:  cols,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: cols == 1 ? 1.4 : 0.85,
        ),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final dest = items[i];
          return DestinationCardWidget(
            // Stable key: element survives filter transitions
            key:         ValueKey(dest.id),
            destination: dest,
            onTap: () => context.go(
              NavigatorRoutes.destinationDetail,
              extra: dest,
            ),
          );
        },
      );
    });
  }

  // ── Loaded: full-screen PageView ────────────────────────────────

  Widget _buildPageView() {
    final items = _filtered;
    if (items.isEmpty) {
      return const Center(child: Text('No destinations.'));
    }
    return Stack(
      children: [
        PageView.builder(
          controller:      _pageCtrl,
          scrollDirection: Axis.vertical,
          itemCount:       items.length,
          onPageChanged:   (i) =>
              setState(() => _pageIndex = i),
          itemBuilder: (_, i) => DiscoveryCardFull(
            key:         ValueKey(items[i].id),
            destination: items[i],
            onBook: () => context.go(
              NavigatorRoutes.destinationDetail,
              extra: items[i],
            ),
          ),
        ),
        // Page indicator dots
        Positioned(
          right:  AppSpacing.md,
          top:    0,
          bottom: 0,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(items.length, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.xs),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width:  8,
                  height: i == _pageIndex ? 20 : 8,
                  decoration: BoxDecoration(
                    color: i == _pageIndex
                        ? AppColors.white
                        : AppColors.white.withAlpha(120),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // ── Error state ─────────────────────────────────────────────────

  Widget _buildError(String message) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(child: Icon(
              Icons.wifi_off,
              size:  64,
              color: t.errorColor.withAlpha(160),
            )),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Could not load destinations',
              style: AppTypography.headlineSmall.copyWith(
                color: t.onSurfaceColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              style: AppTypography.bodySmall.copyWith(
                color: t.onSurfaceColor.withAlpha(160)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: 200,
              child: NomadButton(
                label:    'Retry',
                icon:     Icons.refresh,
                onPressed: _loadFeed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
