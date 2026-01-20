import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _supabase = Supabase.instance.client;

  List<Map<String, dynamic>> _children = [];
  List<Map<String, dynamic>> _routes = [];
  List<Map<String, dynamic>> _drivers = [];
  List<Map<String, dynamic>> _buses = [];

  String? _selectedChildId;
  Map<String, dynamic>? _selectedRoute;
  String? _selectedDriverId;
  String? _selectedBusPlate;
  int _selectedDuration = 30;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final parentId = _supabase.auth.currentUser?.id;

      final responses = await Future.wait([
        _supabase.from('students').select().eq('parent_id', parentId!),
        _supabase.from('bus_routes').select(),
        _supabase.from('drivers').select(),
        _supabase.from('buses').select(),
      ]);

      setState(() {
        _children = List<Map<String, dynamic>>.from(responses[0]);
        debugPrint("Children loaded: ${_children.length}"); // Debug log
        _routes = List<Map<String, dynamic>>.from(responses[1]);
        _drivers = List<Map<String, dynamic>>.from(responses[2]);
        _buses = List<Map<String, dynamic>>.from(responses[3]);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
  }

  double _calculateTotal() {
    if (_selectedRoute == null) return 0.0;
    double pricePerDay = (_selectedRoute!['price_per_day'] as num).toDouble();
    return pricePerDay * _selectedDuration;
  }

  Future<void> _confirmBooking() async {
    if (_selectedChildId == null ||
        _selectedRoute == null ||
        _selectedDriverId == null ||
        _selectedBusPlate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all selections")),
      );
      return;
    }

    try {
      final totalFare = _calculateTotal();
      await _supabase.from('bookings').insert({
        'parent_id': _supabase.auth.currentUser?.id,
        'student_id': _selectedChildId,
        'route_id': _selectedRoute!['id'],
        'driver_id':
            _selectedDriverId, // Pastikan column ini ada di table bookings
        'bus_plate':
            _selectedBusPlate, // Pastikan column ini ada di table bookings
        'duration_days': _selectedDuration,
        'total_fare': totalFare,
        'status': 'pending',
      });

      if (mounted) _showReceipt(totalFare);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  void _showReceipt(double total) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Booking Success!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Route: ${_selectedRoute!['route_name']}"),
            Text("Bus: $_selectedBusPlate"),
            Text("Duration: $_selectedDuration Days"),
            const Divider(),
            Text(
              "Total Price: RM ${total.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text('Bus Booking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Select Child"),
            _buildDropdown(
              _children,
              'id',
              'student_name',
              _selectedChildId,
              (val) => setState(() => _selectedChildId = val),
            ),

            _buildLabel("Select Route"),
            DropdownButtonFormField<Map<String, dynamic>>(
              items: _routes
                  .map(
                    (r) => DropdownMenuItem(
                      value: r,
                      child: Text(r['route_name']),
                    ),
                  )
                  .toList(),
              onChanged: (val) => setState(() => _selectedRoute = val),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            if (_selectedRoute != null) ...[
              const SizedBox(height: 10),
              Text(
                "📍 Start: ${_selectedRoute!['start_point']}",
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                "🏁 End: ${_selectedRoute!['end_point']}",
                style: const TextStyle(color: Colors.grey),
              ),
            ],

            _buildLabel("Select Driver"),
            _buildDropdown(
              _drivers,
              'id',
              'full_name',
              _selectedDriverId,
              (val) => setState(() => _selectedDriverId = val),
            ),

            _buildLabel("Select Bus"),
            _buildDropdown(
              _buses,
              'plate_number',
              'plate_number',
              _selectedBusPlate,
              (val) => setState(() => _selectedBusPlate = val),
            ),

            _buildLabel("Subscription Duration"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [30, 60, 90]
                  .map(
                    (days) => ChoiceChip(
                      label: Text("$days Days"),
                      selected: _selectedDuration == days,
                      onSelected: (selected) =>
                          setState(() => _selectedDuration = days),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 30),
            _buildTotalDisplay(),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                ),
                child: const Text(
                  "CONFIRM & BOOK NOW",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  Widget _buildDropdown(
    List data,
    String valKey,
    String textKey,
    String? selected,
    Function(String?) onChange,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: selected,
      items: data
          .map(
            (item) => DropdownMenuItem(
              value: item[valKey].toString(),
              child: Text(item[textKey]),
            ),
          )
          .toList(),
      onChanged: onChange,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }

  Widget _buildTotalDisplay() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Total Fare:", style: TextStyle(fontSize: 18)),
          Text(
            "RM ${_calculateTotal().toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
