/// Discovery feature — public API.
///
/// Other features must import via this barrel file, never via sub-paths.
/// The `show` clause defines the public API. Internal widgets are
/// excluded intentionally.
library discovery;

export 'models/destination_model.dart'   show DiscoveryDestination, DiscoveryFilter;
export 'screens/discovery_screen.dart'   show DiscoveryScreen;
export 'screens/destination_detail_screen.dart' show DestinationDetailScreen;
export 'state/discovery_state.dart'      show DiscoveryState;
