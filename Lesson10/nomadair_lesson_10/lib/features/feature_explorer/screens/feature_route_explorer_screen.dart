import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

import '../../../routes/navigator_routes.dart';

final class _FeatureDef {
  const _FeatureDef({
    required this.name,
    required this.folder,
    required this.color,
    required this.icon,
    required this.description,
    required this.routes,
    required this.models,
    required this.navigateTo,
  });

  final String name;
  final String folder;
  final Color color;
  final IconData icon;
  final String description;
  final List<String> routes;
  final List<String> models;
  final String navigateTo;
}

final class FeatureRouteExplorerScreen extends StatefulWidget {
  const FeatureRouteExplorerScreen({super.key});

  @override
  State<FeatureRouteExplorerScreen> createState() =>
      _FeatureRouteExplorerScreenState();
}

final class _FeatureRouteExplorerScreenState
    extends State<FeatureRouteExplorerScreen> {
  int _index = 0;
  int _conceptSection = 0;

  static const List<_FeatureDef> _features = [
    _FeatureDef(
      name: 'Discovery',
      folder: 'lib/features/discovery/',
      color: AppColors.blue600,
      icon: Icons.explore,
      description: 'Outbound exploration · destination feed',
      routes: ['/discovery', '/discovery/detail'],
      models: ['DiscoveryDestination', 'DiscoveryFilter'],
      navigateTo: NavigatorRoutes.discovery,
    ),
    _FeatureDef(
      name: 'Search',
      folder: 'lib/features/search/',
      color: AppColors.green500,
      icon: Icons.search,
      description: 'Inbound search · find the perfect flight',
      routes: ['/search', '/search/results'],
      models: ['SearchCriteria', 'PassengerCount', 'CabinClass'],
      navigateTo: NavigatorRoutes.search,
    ),
    _FeatureDef(
      name: 'Booking',
      folder: 'lib/features/booking/',
      color: AppColors.amber700,
      icon: Icons.confirmation_number_outlined,
      description: 'Checkout flow · seats, passengers, payment',
      routes: [
        '/booking/seat-map',
        '/booking/passengers',
        '/booking/payment',
        '/booking/confirmation',
      ],
      models: ['BookingRequest', 'PassengerDetail', 'SeatSelection'],
      navigateTo: NavigatorRoutes.seatMap,
    ),
    _FeatureDef(
      name: 'Profile',
      folder: 'lib/features/profile/',
      color: AppColors.semanticOverlay,
      icon: Icons.person,
      description: 'Account, trips, settings, preferences',
      routes: ['/profile', '/profile/trips', '/profile/settings'],
      models: ['UserProfile', 'SavedTrip', 'UserPreferences'],
      navigateTo: NavigatorRoutes.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _index == 0 ? AppColors.blue600 : const Color(0xFF5A45A5),
        leading: IconButton(
          icon: Icon(_index == 0 ? Icons.menu : Icons.arrow_back),
          onPressed: _index == 0 ? null : () => setState(() => _index = 0),
          tooltip: _index == 0 ? 'Menu' : 'Back to Feature Explorer',
        ),
        title: Text(
          _index == 0
              ? 'NomadAir · Feature Route Explorer'
              : 'Screen vs Widget vs Page',
          style: AppTypography.labelLarge.copyWith(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          if (_index == 1)
            Padding(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: _ConceptHeaderButton(
                      label: 'EXPLANATION',
                      selected: _conceptSection == 0,
                      onTap: () => setState(() => _conceptSection = 0),
                    ),
                  ),
                  Expanded(
                    child: _ConceptHeaderButton(
                      label: 'WIDGET TREE INSPECTOR',
                      selected: _conceptSection == 1,
                      onTap: () => setState(() => _conceptSection = 1),
                    ),
                  ),
                  Expanded(
                    child: _ConceptHeaderButton(
                      label: 'EXAMPLES',
                      selected: _conceptSection == 2,
                      onTap: () => setState(() => _conceptSection = 2),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _index == 0
                ? _FeaturesTab(features: _features)
                : _ConceptsTab(section: _conceptSection),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Feature Explorer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree_outlined),
            label: 'Screen vs Widget vs Page',
          ),
        ],
      ),
    );
  }
}

final class _FeaturesTab extends StatelessWidget {
  const _FeaturesTab({required this.features});
  final List<_FeatureDef> features;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F4F8),
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: features.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => _FeatureCard(feature: features[i]),
      ),
    );
  }
}

final class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature});
  final _FeatureDef feature;

  @override
  Widget build(BuildContext context) {
    final c = feature.color;
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: c.withAlpha(12),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: c.withAlpha(60))),
            ),
            child: Row(
              children: [
                Icon(feature.icon, color: c, size: 20),
                const SizedBox(width: 8),
                Text(
                  feature.name,
                  style: AppTypography.labelLarge.copyWith(
                    color: c,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: c.withAlpha(18),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: c.withAlpha(80)),
                  ),
                  child: Text(
                    feature.folder,
                    style: AppTypography.monoSmall.copyWith(color: c, fontSize: 9),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(feature.description, style: AppTypography.bodySmall),
                const SizedBox(height: 8),
                _InfoSection('Folder Structure', c, 'models/\nscreens/\nwidgets/\nstate/'),
                const SizedBox(height: 4),
                _InfoSection('Routes', c, feature.routes.join('\n')),
                const SizedBox(height: 4),
                _InfoSection('Models', c, feature.models.join('\n')),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: NomadButton(
                    label: 'Navigate',
                    icon: Icons.navigation,
                    semanticLabel: 'Navigate to ${feature.name} feature',
                    onPressed: () => Navigator.of(context).pushNamed(feature.navigateTo),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _InfoSection extends StatelessWidget {
  const _InfoSection(this.label, this.color, this.value);
  final String label;
  final Color color;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 92,
          child: Text(
            label,
            style: AppTypography.monoSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(value, style: AppTypography.monoSmall),
        ),
      ],
    );
  }
}

final class _ConceptsTab extends StatelessWidget {
  const _ConceptsTab({required this.section});
  final int section;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth > 900;
        return Container(
          color: const Color(0xFFF2F4F8),
          child: desktop
              ? ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _ConceptTile(
                            title: 'Page',
                            color: Color(0xFFE8EBFF),
                            icon: Icons.description,
                            summary: 'Route target. Owns navigation.\nNo layout of its own.',
                            example: 'DiscoveryPage',
                            depth: 'Shallow',
                            nodes: ['MaterialPage', '{child}'],
                            section: section,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _ConceptTile(
                            title: 'Screen',
                            color: Color(0xFFEAF2FF),
                            icon: Icons.crop_square,
                            summary: 'Full layout root. Owns Scaffold.\nManages local UI state.',
                            example: 'DiscoveryScreen',
                            depth: 'Medium',
                            nodes: ['Scaffold', 'AppBar', 'Body', '...'],
                            section: section,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _ConceptTile(
                            title: 'Widget',
                            color: Color(0xFFEFF9E8),
                            icon: Icons.extension,
                            summary: 'Reusable UI component.\nNo routing or navigation.',
                            example: 'DestinationCard',
                            depth: 'Deep',
                            nodes: ['Container', 'Column', 'Text', 'Icon'],
                            section: section,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    _ConceptCompactTile(
                      title: 'Page',
                      color: Color(0xFFE8EBFF),
                      icon: Icons.description,
                      summary: 'Route target. Owns navigation.\nNo layout of its own.',
                      example: 'DiscoveryPage',
                      depth: 'Shallow',
                      section: section,
                    ),
                    SizedBox(height: 10),
                    _ConceptCompactTile(
                      title: 'Screen',
                      color: Color(0xFFEAF2FF),
                      icon: Icons.crop_square,
                      summary: 'Full layout root.\nOwns Scaffold.\nManages local UI state.',
                      example: 'DiscoveryScreen',
                      depth: 'Medium',
                      section: section,
                    ),
                    SizedBox(height: 10),
                    _ConceptCompactTile(
                      title: 'Widget',
                      color: Color(0xFFEFF9E8),
                      icon: Icons.extension,
                      summary: 'Reusable UI component.\nNo routing or navigation.',
                      example: 'DestinationCard\nPriceChip',
                      depth: 'Deep',
                      section: section,
                    ),
                  ],
                ),
        );
      },
    );
  }
}

final class _ConceptCompactTile extends StatelessWidget {
  const _ConceptCompactTile({
    required this.title,
    required this.color,
    required this.icon,
    required this.summary,
    required this.example,
    required this.depth,
    required this.section,
  });

  final String title;
  final Color color;
  final IconData icon;
  final String summary;
  final String example;
  final String depth;
  final int section;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 28, color: color.withAlpha(230)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.headlineSmall.copyWith(
                            color: color.withAlpha(240),
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (section == 0)
                          Text(summary, style: AppTypography.bodySmall),
                        if (section == 1)
                          Text('Widget tree depth: $depth',
                              style: AppTypography.bodySmall),
                        if (section == 2)
                          Text('Example components',
                              style: AppTypography.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (section != 1) ...[
                    Text('Example', style: AppTypography.monoSmall),
                    const SizedBox(height: 4),
                    _Tag(text: example),
                  ],
                  if (section != 2) ...[
                    const SizedBox(height: 10),
                    Text('Inspector', style: AppTypography.monoSmall),
                    const SizedBox(height: 2),
                    Text('Widget tree depth:', style: AppTypography.bodySmall),
                    const SizedBox(height: 4),
                    _Tag(text: depth),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _ConceptTile extends StatelessWidget {
  const _ConceptTile({
    required this.title,
    required this.color,
    required this.icon,
    required this.summary,
    required this.example,
    required this.depth,
    required this.nodes,
    required this.section,
  });

  final String title;
  final Color color;
  final IconData icon;
  final String summary;
  final String example;
  final String depth;
  final List<String> nodes;
  final int section;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 18),
                  const SizedBox(width: 6),
                  Text(title, style: AppTypography.labelLarge),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (section == 0) ...[
              Text(summary, style: AppTypography.bodySmall, textAlign: TextAlign.center),
            ],
            if (section == 2) ...[
              Text('Example', style: AppTypography.monoSmall),
              const SizedBox(height: 4),
              _Tag(text: example),
            ],
            if (section == 1) ...[
              Text('Inspector', style: AppTypography.monoSmall),
              const SizedBox(height: 4),
              Text('Widget tree depth:', style: AppTypography.bodySmall),
              const SizedBox(height: 4),
              _Tag(text: depth),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: nodes.map((n) => _Tag(text: n)).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

final class _Tag extends StatelessWidget {
  const _Tag({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD4D8E0)),
      ),
      child: Text(text, style: AppTypography.monoSmall),
    );
  }
}

final class _ConceptHeaderButton extends StatelessWidget {
  const _ConceptHeaderButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? const Color(0xFF5A45A5) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? const Color(0xFF5A45A5) : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}

