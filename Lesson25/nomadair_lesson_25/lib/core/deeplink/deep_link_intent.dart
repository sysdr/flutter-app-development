import '../../../features/search/models/search_criteria.dart';

// Sealed union produced by DeepLinkResolver.
//
// SearchIntent  — all required params present and validated.
//                 DeepLinkHandler will attempt a cache-first search.
// PreFillIntent — partial params (no date, or no destination).
//                 DeepLinkHandler navigates to Search tab and pre-fills.
// InvalidIntent — an IATA code was unrecognised or the URI was malformed.
//                 DeepLinkHandler shows an error SnackBar.
sealed class DeepLinkIntent {
  const DeepLinkIntent();
}

final class SearchIntent extends DeepLinkIntent {
  const SearchIntent(this.criteria);
  final SearchCriteria criteria;
}

final class PreFillIntent extends DeepLinkIntent {
  const PreFillIntent({this.originIata, this.destinationIata, this.date});
  final String?   originIata;
  final String?   destinationIata;
  final DateTime? date;
}

final class InvalidIntent extends DeepLinkIntent {
  const InvalidIntent(this.reason);
  final String reason;
}
