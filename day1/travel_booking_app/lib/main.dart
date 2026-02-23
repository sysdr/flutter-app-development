import 'package:flutter/material.dart';

void main() {
  runApp(const TravelBookingApp());
}

class TravelBookingApp extends StatelessWidget {
  const TravelBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelWise',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto', // Default, we'll customize in assignment
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to TravelWise'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.travel_explore,
                size: 120,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 32),
              Text(
                'Your Journey, Our Expertise.',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Experience seamless travel planning with a touch of magic. Get ready to explore!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Demo metrics data
  int _bookingsCount = 0;
  int _activeTrips = 0;
  double _totalSpent = 0.0;
  int _savedDestinations = 0;
  
  @override
  void initState() {
    super.initState();
    _loadMetrics();
    // Simulate metrics updates
    _startMetricsUpdate();
  }
  
  void _loadMetrics() {
    // Demo: Simulate loading metrics
    setState(() {
      _bookingsCount = 12;
      _activeTrips = 3;
      _totalSpent = 2450.75;
      _savedDestinations = 8;
    });
  }
  
  void _startMetricsUpdate() {
    // Update metrics every 3 seconds for demo
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _bookingsCount += 1;
          _totalSpent += 125.50;
        });
        _startMetricsUpdate();
      }
    });
  }
  
  void _runDemo() {
    // Demo functionality
    setState(() {
      _bookingsCount = 0;
      _activeTrips = 0;
      _totalSpent = 0.0;
      _savedDestinations = 0;
    });
    
    // Simulate demo data loading
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _bookingsCount = 25;
          _activeTrips = 5;
          _totalSpent = 5678.90;
          _savedDestinations = 15;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TravelWise Dashboard'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _runDemo,
            tooltip: 'Run Demo',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadMetrics();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Metrics Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildMetricCard(
                    'Total Bookings',
                    _bookingsCount.toString(),
                    Icons.book_online,
                    Colors.blue,
                  ),
                  _buildMetricCard(
                    'Active Trips',
                    _activeTrips.toString(),
                    Icons.flight_takeoff,
                    Colors.green,
                  ),
                  _buildMetricCard(
                    'Total Spent',
                    '\$${_totalSpent.toStringAsFixed(2)}',
                    Icons.attach_money,
                    Colors.orange,
                  ),
                  _buildMetricCard(
                    'Saved Destinations',
                    _savedDestinations.toString(),
                    Icons.favorite,
                    Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Demo Section
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.play_circle, color: Theme.of(context).primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'Demo',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Click the refresh button in the app bar to run a demo that resets and updates all metrics.',
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _runDemo,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Run Demo Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Status indicator
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'All metrics are updating in real-time',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
