import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterChildScreen extends StatefulWidget {
  const RegisterChildScreen({super.key});

  @override
  State<RegisterChildScreen> createState() => _RegisterChildScreenState();
}

class _RegisterChildScreenState extends State<RegisterChildScreen> {
  final _supabase = Supabase.instance.client;
  
  // Controllers mengikut keperluan pangkalan data anda
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegistering = false;

  Future<void> _registerChild() async {
    // 1. Dapatkan ID Bapa (Parent) yang sedang login sekarang
    final String? currentParentId = _supabase.auth.currentUser?.id;

    if (currentParentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session Error: Please login again'), backgroundColor: Colors.red)
      );
      return;
    }

    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields'), backgroundColor: Colors.orange)
      );
      return;
    }

    setState(() => _isRegistering = true);
    
    try {
      // 2. Daftar akaun baru dalam Supabase Auth (untuk anak login nanti)
      final AuthResponse res = await _supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (res.user != null) {
        // 3. Masukkan data ke dalam jadual 'students' mengikut skema SQL anda
        await _supabase.from('students').insert({
          'id': res.user!.id,               // UUID dari Auth Anak
          'parent_id': currentParentId,      // UUID Bapa yang sah (Fix Foreign Key Error)
          'student_name': _nameController.text.trim(), //
          'age': int.tryParse(_ageController.text) ?? 0, //
          'email': _emailController.text.trim(), //
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Child Registered Successfully!'), backgroundColor: Colors.green)
          );
          // Kosongkan form selepas berjaya
          _nameController.clear();
          _ageController.clear();
          _emailController.clear();
          _passwordController.clear();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Failed: $e'), backgroundColor: Colors.red)
        );
      }
    } finally {
      if (mounted) setState(() => _isRegistering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Student Registration'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Child's Information",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: "Age", border: OutlineInputBorder(), prefixIcon: Icon(Icons.cake)),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Login Email (Unique)", border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Login Password", border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock)),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isRegistering ? null : _registerChild,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isRegistering 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("REGISTER CHILD", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}