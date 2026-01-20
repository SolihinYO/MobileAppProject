import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddDriverScreen extends StatefulWidget {
  const AddDriverScreen({super.key});

  @override
  State<AddDriverScreen> createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  // Controllers to retrieve text from input fields
  final TextEditingController _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _licenseController = TextEditingController();

  // FUNCTION TO SAVE TO SUPABASE
  Future<void> _saveDriverToSupabase() async {
    if (_formKey.currentState!.validate()) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        await supabase.from('drivers').insert({
          'full_name': _nameController.text.trim(),
          'phone_number': _phoneController.text.trim(),
          'license_number': _licenseController.text.trim(),
        });

        if (mounted) {
          Navigator.pop(context); // Close loading dialog
          Navigator.pop(context); // Return to previous screen

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Driver successfully added!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (error) {
        if (mounted) {
          Navigator.pop(context); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${error.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Driver'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Driver Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Name Input
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter name' : null,
              ),
              const SizedBox(height: 15),

              // Phone Number Input
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter phone number' : null,
              ),
              const SizedBox(height: 15),

              // License Number Input
              TextFormField(
                controller: _licenseController,
                decoration: const InputDecoration(
                  labelText: 'License Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.card_membership),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter license number' : null,
              ),
              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _saveDriverToSupabase,
                  child: const Text(
                    'SAVE DRIVER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
