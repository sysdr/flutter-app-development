import 'package:flutter/material.dart';

void main() {
  runApp(const TravelApp());
}

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Booking App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const FlightSearchScreen(),
    );
  }
}

class FlightInfo {
  final String route;
  final int price;
  final String departureLine;
  final String airlineLine;
  final String flightNo;
  final String gate;
  final String duration;

  const FlightInfo({
    required this.route,
    required this.price,
    required this.departureLine,
    required this.airlineLine,
    required this.flightNo,
    required this.gate,
    required this.duration,
  });
}

class FlightSearchScreen extends StatefulWidget {
  const FlightSearchScreen({super.key});

  @override
  State<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen> {
  bool _isSearching = false;
  int _primaryTaps = 0;
  int _accentTaps = 0;
  int _fieldEdits = 0;
  int _demoRuns = 0;
  int _flightIndex = 0;

  final List<FlightInfo> _flights = const <FlightInfo>[
    FlightInfo(
      route: 'NYC to LDN',
      price: 899,
      departureLine: 'Oct 26, 2026',
      airlineLine: 'Global Airways',
      flightNo: 'GA101',
      gate: 'A12',
      duration: '7h 30m',
    ),
    FlightInfo(
      route: 'NYC to PAR',
      price: 749,
      departureLine: 'Nov 2, 2026',
      airlineLine: 'Continental Air',
      flightNo: 'CA220',
      gate: 'B7',
      duration: '7h 15m',
    ),
    FlightInfo(
      route: 'NYC to TYO',
      price: 1199,
      departureLine: 'Dec 10, 2026',
      airlineLine: 'Pacific Skies',
      flightNo: 'PS88',
      gate: 'C3',
      duration: '13h 40m',
    ),
  ];

  FlightInfo get _currentFlight => _flights[_flightIndex];

  void _runDemo() {
    setState(() {
      _demoRuns += 1;
      _primaryTaps += 1;
      _accentTaps += 1;
      _fieldEdits += 1;
    });
  }

  Future<void> _startSearch() async {
    setState(() {
      _isSearching = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSearching = false;
      _primaryTaps += 1;
      _demoRuns += 1;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Flight search completed!')),
    );
  }

  Widget _metricRow(String label, int value, Key valueKey) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: Text(label)),
          Text(
            '$value',
            key: valueKey,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _flightDetailLine(FlightInfo flight, int index) {
    final bool isSelected = index == _flightIndex;
    final Color color = isSelected ? Colors.blueAccent : Colors.black54;
    final FontWeight weight = isSelected ? FontWeight.w700 : FontWeight.w500;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '${index + 1}. ${flight.route} • \$${flight.price} • ${flight.departureLine} • ${flight.airlineLine}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color, fontWeight: weight),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Your Next Adventure'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Dashboard',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Metrics update when you use the demo below or tap "Run demo".',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54),
                    ),
                    const SizedBox(height: 12),
                    _metricRow('Find Flights / search completes', _primaryTaps, const ValueKey<String>('metric_primary')),
                    _metricRow('View Flight Details taps', _accentTaps, const ValueKey<String>('metric_accent')),
                    _metricRow('Flight card expand toggles', _fieldEdits, const ValueKey<String>('metric_field')),
                    _metricRow('Demo runs', _demoRuns, const ValueKey<String>('metric_demo')),
                    const SizedBox(height: 10),
                    Text(
                      'Next flight: ${_currentFlight.route}',
                      key: const ValueKey<String>('dashboard_next_flight'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Available flights',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        for (int i = 0; i < _flights.length; i++) _flightDetailLine(_flights[i], i),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _runDemo,
                      child: const Text('Run demo (updates all metrics)'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                setState(() {
                  _flightIndex = (_flightIndex + 1) % _flights.length;
                  _demoRuns += 1; // keep dashboard non-zero after interaction
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Where to next?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: _AnimatedSearchButton(
                isSearching: _isSearching,
                onPressed: _isSearching ? null : _startSearch,
              ),
            ),
            const SizedBox(height: 40),
            FlightCard(
              flight: _currentFlight,
              onExpansionToggle: () {
                setState(() {
                  _fieldEdits += 1;
                  _demoRuns += 1;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _accentTaps += 1;
                  _demoRuns += 1;
                });
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => const FlightDetailsScreen()),
                );
              },
              child: const Text('View Flight Details (Assignment)'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedSearchButton extends StatelessWidget {
  const _AnimatedSearchButton({
    super.key,
    required this.isSearching,
    this.onPressed,
  });

  final bool isSearching;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.colorScheme.primary;
    final Color onPrimaryColor = theme.colorScheme.onPrimary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isSearching ? 60 : 250,
      height: 60,
      decoration: BoxDecoration(
        color: isSearching ? Colors.grey : primaryColor,
        borderRadius: BorderRadius.circular(isSearching ? 30 : 20),
        boxShadow: isSearching
            ? <BoxShadow>[]
            : <BoxShadow>[
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(isSearching ? 30 : 20),
          onTap: onPressed,
          child: Center(
            child: isSearching
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(onPrimaryColor),
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Find Flights',
                    style: TextStyle(color: onPrimaryColor, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    );
  }
}

class FlightCard extends StatefulWidget {
  const FlightCard({super.key, required this.flight, this.onExpansionToggle});

  final FlightInfo flight;

  final VoidCallback? onExpansionToggle;

  @override
  State<FlightCard> createState() => _FlightCardState();
}

class _FlightCardState extends State<FlightCard> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    widget.onExpansionToggle?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      clipBehavior: Clip.antiAlias,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 44),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          widget.flight.route,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${widget.flight.price}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Departure: ${widget.flight.departureLine}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Airline: ${widget.flight.airlineLine}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    AnimatedOpacity(
                      opacity: _isExpanded ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: _isExpanded
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const SizedBox(height: 10),
                                const Divider(),
                                Text(
                                  'Details:',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text('Flight No: ${widget.flight.flightNo}', style: Theme.of(context).textTheme.bodySmall),
                                Text('Gate: ${widget.flight.gate}', style: Theme.of(context).textTheme.bodySmall),
                                Text('Duration: ${widget.flight.duration}', style: Theme.of(context).textTheme.bodySmall),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: IconButton(
                  icon: Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                  onPressed: _toggleExpansion,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FlightDetailsScreen extends StatelessWidget {
  const FlightDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Detailed Flight Information',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 20),
            const Text('Departure: New York (JFK)'),
            const Text('Arrival: London (LHR)'),
            const Text('Date: October 26, 2026'),
            Text(r'Price: $899'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
