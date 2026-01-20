import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddBusScreen extends StatefulWidget {
  const AddBusScreen({super.key});

  @override
  State<AddBusScreen> createState() => _AddBusScreenState();
}

class _AddBusScreenState extends State<AddBusScreen> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();

  String _selectedBusType = 'Small (Van)';
  String? _selectedDriver;

  // FETCH DRIVER NAMES FROM SUPABASE
  Future<List<String>> _fetchDrivers() async {
    try {
      final data = await supabase
          .from('drivers')
          .select('full_name')
          .order('full_name', ascending: true);

      return (data as List).map((row) => row['full_name'] as String).toList();
    } catch (e) {
      debugPrint("Error fetching drivers: $e");
      return [];
    }
  }

  Future<void> _saveBusToSupabase() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDriver == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a driver first!')),
        );
        return;
      }

      final String plate = _plateController.text.trim().toUpperCase();
      final int capacity = int.tryParse(_capacityController.text) ?? 0;

      // Show Loading Dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        await supabase.from('buses').insert({
          'plate_number': plate,
          'capacity': capacity,
          'bus_type': _selectedBusType,
          'driver_name': _selectedDriver,
        });

        if (mounted) {
          Navigator.pop(context); // Close loading dialog
          Navigator.pop(context); // Return to previous screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Success: Bus $plate added!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (error) {
        if (mounted) {
          Navigator.pop(context); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed: $error'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _plateController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Bus'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Bus Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),

                TextFormField(
                  controller: _plateController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Bus Plate Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.directions_bus),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter plate number'
                      : null,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _capacityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Seating Capacity',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.people),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter capacity'
                      : null,
                ),
                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  initialValue: _selectedBusType,
                  decoration: const InputDecoration(
                    labelText: 'Bus Type',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Small (Van)', 'Medium Bus', 'Large Bus']
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedBusType = value!),
                ),
                const SizedBox(height: 20),

                // --- DYNAMIC DRIVER DROPDOWN ---
                FutureBuilder<List<String>>(
                  future: _fetchDrivers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LinearProgressIndicator();
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text(
                        "No drivers found. Please add a driver first.",
                        style: TextStyle(color: Colors.red),
                      );
                    }

                    final drivers = snapshot.data!;

                    return DropdownButtonFormField<String>(
                      initialValue: _selectedDriver,
                      hint: const Text("Select Assigned Driver"),
                      decoration: const InputDecoration(
                        labelText: 'Assign Driver',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      items: drivers
                          .map(
                            (driver) => DropdownMenuItem(
                              value: driver,
                              child: Text(driver),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedDriver = value),
                      validator: (value) =>
                          value == null ? 'Please assign a driver' : null,
                    );
                  },
                ),
                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _saveBusToSupabase,
                    child: const Text(
                      'SAVE BUS',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
