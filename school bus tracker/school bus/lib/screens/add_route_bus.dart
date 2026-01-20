import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddRouteBusScreen extends StatefulWidget {
  const AddRouteBusScreen({super.key});

  @override
  State<AddRouteBusScreen> createState() => _AddRouteBusScreenState();
}

class _AddRouteBusScreenState extends State<AddRouteBusScreen> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client; 
  
  final TextEditingController _routeNameController = TextEditingController();
  final TextEditingController _startPointController = TextEditingController();
  final TextEditingController _endPointController = TextEditingController();
  final TextEditingController _estimatedTimeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController(); // Controller Baru

  bool _isSaving = false;

  Future<void> _saveBusRoute() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      try {
        await supabase.from('bus_routes').insert({
          'route_name': _routeNameController.text.trim(),
          'start_point': _startPointController.text.trim(),
          'end_point': _endPointController.text.trim(),
          'estimated_time': _estimatedTimeController.text.trim(),
          'price_per_day': double.tryParse(_priceController.text.trim()) ?? 0.0, // Simpan Harga
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Route Saved Successfully!'), backgroundColor: Colors.green),
          );
          Navigator.pop(context); 
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bus Route'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Route Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              
              _buildTextField(_routeNameController, "Route Name (e.g., Utama Path)", Icons.route),
              const SizedBox(height: 15),
              _buildTextField(_startPointController, "Start Location", Icons.location_on),
              const SizedBox(height: 15),
              _buildTextField(_endPointController, "End Location (School)", Icons.school),
              const SizedBox(height: 15),
              _buildTextField(_estimatedTimeController, "Estimated Time (e.g., 30 Mins)", Icons.timer),
              const SizedBox(height: 15),
              
              // INPUT HARGA BARU
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Fare Price Per Day (RM)', 
                  border: OutlineInputBorder(),
                  prefixText: 'RM ',
                  prefixIcon: Icon(Icons.money_off_csred_rounded)
                ),
                validator: (value) => value!.isEmpty ? 'Please enter fare price' : null,
              ),
              
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _isSaving ? null : _saveBusRoute,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55), 
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSaving 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("SAVE ROUTE", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label, 
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon)
      ),
      validator: (value) => value!.isEmpty ? 'Field required' : null,
    );
  }
}