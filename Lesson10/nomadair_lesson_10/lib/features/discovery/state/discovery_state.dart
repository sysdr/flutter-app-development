import '../models/destination_model.dart';

/// Discovery feature UI state.
///
/// Currently managed with [setState] inside [DiscoveryScreen].
/// Migrates to Riverpod [AsyncNotifier] in Lesson 32.
///
/// Naming convention: state classes in the [state/] folder will be
/// promoted to generated Riverpod notifiers. The folder name signals
/// the migration target to every developer on the team.
final class DiscoveryState {
  const DiscoveryState({
    this.filter  = DiscoveryFilter.all,
    this.loading = false,
  });

  final DiscoveryFilter filter;
  final bool            loading;

  DiscoveryState copyWith({
    DiscoveryFilter? filter,
    bool?            loading,
  }) => DiscoveryState(
    filter:  filter  ?? this.filter,
    loading: loading ?? this.loading,
  );

  List<DiscoveryDestination> filtered(List<DiscoveryDestination> all) =>
      filter == DiscoveryFilter.all
          ? all
          : all.where((d) =>
              d.category == filter.name || d.category == 'both').toList();
}
