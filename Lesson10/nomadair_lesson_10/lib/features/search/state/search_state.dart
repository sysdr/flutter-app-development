import '../models/search_criteria.dart';

/// Search feature UI state.
///
/// Migrates to [SearchCriteriaNotifier] (Provider) in Lesson 16,
/// then to Riverpod AsyncNotifier in Lesson 32.
final class SearchState {
  const SearchState({
    this.criteria = const SearchCriteria(),
    this.loading  = false,
    this.error,
  });
  final SearchCriteria criteria;
  final bool           loading;
  final String?        error;

  SearchState copyWith({
    SearchCriteria? criteria, bool? loading, String? error}) =>
      SearchState(
        criteria: criteria ?? this.criteria,
        loading:  loading  ?? this.loading,
        error:    error);
}
